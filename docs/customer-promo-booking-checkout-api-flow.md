# Customer promo — Booking & Checkout detailed API flow

**Related docs:**
- `customer-promo-api-has-vs-need.md` (short has vs need)
- `customer-promo-ui-has-vs-need.md` (UI has vs need)

**Audience:** Backend + Flutter  
**Goal:** Same contract for how user **sees**, **validates**, and **uses** promo on product checkout and service booking — without breaking production Stripe flow.

**Sellers create promo = OK** (not covered here).

---

## 0. Rules both sides must follow

1. **Browse** = see / copy only → no usage burn  
2. **Validate** = check before pay → no usage burn  
3. **Create order/booking** with `promoCode` = attach discount to payment  
4. **Webhook after Stripe success** = promo is actually **used**  
5. Flutter must **never** call `POST /promo-codes/apply` (burns usage early)

```
SEE → VALIDATE → PAY (create + Stripe) → USED (webhook) → SHOW on success
```

---

## 1. How user sees promo codes

### A) Global Deals list (Profile → Deals & Promos)

| | |
|--|--|
| **When** | User opens deals to browse |
| **API** | `GET /api/v1/promo-codes/all` |
| **Optional query** | `createdBy`, `applicableFor=product\|service\|both` |
| **User sees** | Code, %, seller name, Products/Services, min spend, expiry |
| **User action** | **Copy code** only (not “applied”) |

#### Response shape (NEED — additive fields OK)

```json
{
  "code": 200,
  "message": "Promo codes retrieved successfully",
  "data": {
    "attributes": {
      "results": [
        {
          "id": "64f...",
          "code": "SAVE10",
          "title": "10% off store",
          "discountPercentage": 10,
          "description": "Valid on products",
          "applicableFor": "product",
          "minPurchaseAmount": 50,
          "maxUsageCount": 100,
          "currentUsageCount": 12,
          "expiryDate": "2026-12-31T00:00:00.000Z",
          "isActive": true,
          "createdBy": {
            "id": "64a...",
            "fullName": "Jane Vendor",
            "businessName": "Glow Store",
            "role": "vendor",
            "phoneNumber": "+1..."
          }
        }
      ],
      "page": 1,
      "limit": 10,
      "totalPages": 1,
      "totalResults": 1
    }
  }
}
```

**HAS:** list works.  
**NEED (backend, small):** include `createdBy.role` (and businessName if missing).  
**NEED (Flutter):** show those fields; button = Copy, not fake Apply.

---

### B) Product checkout — list for this vendor only

| | |
|--|--|
| **When** | User opens promo sheet on checkout |
| **API** | `GET /api/v1/promo-codes/all?createdBy={vendorId}&applicableFor=product` |
| **User sees** | Only that vendor’s product (or both) codes |
| **User action** | Pick from list **or** paste code → then **Validate** |

Same response shape as above.

---

### C) Service booking — list for this beautician only

| | |
|--|--|
| **When** | User opens Add Promo on booking confirm |
| **API** | `GET /api/v1/promo-codes/all?createdBy={beauticianId}&applicableFor=service` |
| **User sees** | Only that beautician’s service (or both) codes |
| **User action** | Pick **or** paste → then **Validate** |

---

## 2. How VALIDATE works (NEW API)

### Purpose

Before Pay, app asks: *“Is this code OK for this cart/booking right now?”*  
User sees green discount or red reason.  
**Does not** increase `currentUsageCount` / `usedBy`.

### Endpoint

```
POST /api/v1/promo-codes/validate
Auth: Bearer token (customer)
```

### Request body

Use **one context** only (product checkout OR service booking).

#### Product checkout

```json
{
  "code": "SAVE10",
  "subtotal": 100,
  "vendorId": "64aVENDOR_ID"
}
```

(Alternative also OK if easier for backend reuse: `productId` instead of / with `vendorId`.)

#### Service booking

```json
{
  "code": "HAIR15",
  "subtotal": 80,
  "beauticianId": "64aBEAUTICIAN_ID"
}
```

(Alternative: `serviceId` instead of / with `beauticianId`.)

| Field | Required | Meaning |
|-------|----------|---------|
| `code` | Yes | Promo string user typed/picked |
| `subtotal` | Yes | Items/service subtotal **before** fee/tax/tip (same base you discount today) |
| `vendorId` | Product flow | Must match promo creator |
| `beauticianId` | Booking flow | Must match promo creator |
| `productId` / `serviceId` | Optional alt | Ownership check via product/service |

### Success response (NEED)

Match existing `response()` style used elsewhere:

```json
{
  "code": 200,
  "status": "OK",
  "message": "Promo code is valid",
  "data": {
    "attributes": {
      "valid": true,
      "code": "SAVE10",
      "promoId": "64f...",
      "discountPercentage": 10,
      "discountAmount": 10,
      "finalSubtotal": 90,
      "applicableFor": "product",
      "minPurchaseAmount": 50,
      "createdBy": {
        "id": "64a...",
        "businessName": "Glow Store",
        "role": "vendor"
      }
    }
  }
}
```

**Flutter uses this to show:** `✓ SAVE10 · −$10`

### Fail response (NEED — clear human messages)

```json
{
  "code": 400,
  "status": "ERROR",
  "message": "This promo code is not valid for this store",
  "data": {
    "attributes": {
      "valid": false,
      "reason": "WRONG_SELLER"
    }
  }
}
```

Suggested `reason` values (for app logic + message):

| reason | User message example |
|--------|----------------------|
| `NOT_FOUND` | Invalid promo code |
| `EXPIRED` | Promo code expired |
| `INACTIVE` | Promo code is not active |
| `WRONG_SELLER` | Not valid for this store / beautician |
| `WRONG_TYPE` | This code is for products only / services only |
| `MIN_PURCHASE` | Minimum purchase is $50 |
| `USAGE_LIMIT` | Promo usage limit reached |
| `ALREADY_USED` | You already used this promo |
| `REQUIRED_CONTEXT` | Missing vendor/beautician context |

**Important:** HTTP 400 is fine; Flutter shows `message` in red. Do **not** burn usage on fail or success of validate.

---

## 3. Product checkout — full step flow

```
1. Open CheckOutScreen
2. GET /promo-codes/all?createdBy={vendorId}
   → user sees vendor promos
3. User picks or pastes code
4. POST /promo-codes/validate
   { code, subtotal, vendorId }
   → UI: green −$ or red error
5. User taps Pay
6. POST /product-orders
   {
     "vendorId": "...",
     "items": [...],
     "deliveryMethod": "...",
     "deliveryAddress": {...},
     "tip": 5,
     "promoCode": "SAVE10"
   }
7. Response has checkoutUrl + priceBreakdown
8. Open Stripe WebView
9. Pay success → webhook consumes promo
10. Success screen shows promo line
```

### Create order response (HAS — already similar)

```json
{
  "code": 201,
  "status": "OK",
  "message": "Order created",
  "data": {
    "attributes": {
      "order": { "...": "order document" },
      "checkoutUrl": "https://checkout.stripe.com/...",
      "sessionId": "cs_...",
      "priceBreakdown": {
        "itemsSubtotal": 100,
        "serviceFee": 4,
        "tax": 5,
        "deliveryPrice": 10,
        "shippingPrice": 0,
        "tip": 5,
        "promoCode": "SAVE10",
        "promoDiscount": 10,
        "total": 114
      }
    }
  }
}
```

**Flutter:** trust `priceBreakdown` / Stripe amount for final display; validate was only preview.

**Promo used?** Not yet — only after Stripe webhook success.

---

## 4. Service booking — full step flow

```
1. Open booking confirm screen
2. GET /promo-codes/all?createdBy={beauticianId}&applicableFor=service
   → user sees that beautician’s codes
3. User picks or pastes on Add Promo screen
4. POST /promo-codes/validate
   { code, subtotal, beauticianId }
   → UI shows ✓ −$ on confirm breakdown
5. User taps Pay
6. POST /bookings
   {
     "serviceId": "...",
     "bookingItems": [...],
     "appointmentDate": "2026-09-20",
     "appointmentTime": "10:00",
     "tip": 8,
     "promoCode": "HAIR15"
   }
7. Response has checkoutUrl + priceBreakdown
8. Stripe WebView
9. Pay success → webhook consumes promo
10. Success screen shows promo line
```

### Create booking response (HAS / keep)

```json
{
  "code": 201,
  "status": "OK",
  "message": "Booking created",
  "data": {
    "attributes": {
      "booking": { "...": "booking document" },
      "checkoutUrl": "https://checkout.stripe.com/...",
      "sessionId": "cs_...",
      "priceBreakdown": {
        "serviceBasePrice": 60,
        "variantsTotal": 20,
        "serviceDiscount": 0,
        "subtotal": 80,
        "serviceFee": 3.2,
        "tax": 4,
        "tip": 8,
        "promoCode": "HAIR15",
        "promoDiscount": 12,
        "totalAmount": 83.2
      }
    }
  }
}
```

**HAS (backend):** can accept `promoCode` and return breakdown.  
**NEED (Flutter):** actually send `promoCode` (+ `tip` if selected).  
**NEED (both):** validate before step 6.

---

## 5. After pay — what happens / what user sees

| Step | Who | What |
|------|-----|------|
| Stripe success | Backend webhook | Set payment paid (booking) / save PI (order); **then** `usedBy` + `currentUsageCount` |
| Success UI | Flutter | Show `Promo SAVE10 (−$10)` from create response or refreshed booking/order |
| Pay cancel/fail | Both | Promo **not** used; user can try again |

No new Flutter API for “consume”. Webhook already owns that.

---

## 6. HAS vs NEED (API detail summary)

| Step | Product checkout | Service booking |
|------|------------------|-----------------|
| See list | **HAS** `GET .../all?createdBy=vendorId` | **NEED Flutter call** same with beauticianId |
| Validate | **NEED NEW** `POST .../validate` | **NEED NEW** same |
| Attach + pay | **HAS** `POST /product-orders` + `promoCode` | **HAS backend** / **NEED Flutter send** `POST /bookings` + `promoCode` |
| Consume | **HAS** webhook | **HAS** webhook |
| Show after | **NEED Flutter UI** | **NEED Flutter UI** |

---

## 7. Field name cheat sheet

| Action | Field |
|--------|--------|
| List | query `createdBy`, `applicableFor` |
| Validate | body `code` |
| Create order | body `promoCode` |
| Create booking | body `promoCode` |
| Breakdown | `promoCode`, `promoDiscount` |

Do not mix: validate uses `code`; create uses `promoCode`.

---

## 8. Backend checklist (for this doc)

- [ ] Add `POST /promo-codes/validate` (no usage increment)
- [ ] Clear error `message` + optional `reason`
- [ ] Enrich `GET /promo-codes/all` with `createdBy.role` (additive)
- [ ] Keep create order/booking + webhook consume as today
- [ ] Do not require Flutter to call `/apply`

## 9. Flutter checklist (for this doc)

- [ ] Checkout: list → validate → create with `promoCode`
- [ ] Booking: list → validate → create with `promoCode` (+ tip)
- [ ] Show validate result on confirm UI before Stripe
- [ ] Show promo on success from `priceBreakdown`
- [ ] Deals list: Copy only; never `/apply`

---

## 10. One line

**User sees codes from list → validate checks without using them → create booking/order applies discount on Stripe → webhook marks used → success UI shows the promo.**

---

*File:* `docs/customer-promo-booking-checkout-api-flow.md`
