# Service Booking Payment Alignment — Backend Specification

**Project:** TNP Beauty (`the_noire_hub_v1`)  
**Audience:** Backend developer  
**Goal:** Stripe Checkout must charge **exactly** the same total shown in the mobile app **Confirm Booking** screen — not more, not less.

---

## 1. Executive summary

The mobile app shows a full price breakdown on **Confirm Booking** (service + variants + **4% service fee** + **5% GST/tax**).  
When the user taps **Pay Now**, the app calls `POST /bookings` and opens the returned Stripe `checkoutUrl`.

**Today:** The app displays one total (e.g. **$109.00** on a $100 service), but Stripe may charge a different amount because the backend creates the Stripe session without applying the same **4% fee** and **5% tax** rules as the app.

**Required:** Backend must calculate the booking total using the **same rules as the app** and create the Stripe Checkout Session for that **exact** amount. The stored `totalAmount` on the booking must match what the customer paid.

---

## 2. Current mobile app flow (no changes planned on UI totals)

```
Service Booking Screen  →  Confirm Booking  →  Pay Now  →  POST /bookings  →  Stripe WebView
```

### 2.1 What the app shows on Confirm Booking

| UI line | Source |
|--------|--------|
| Service name + base price | Service `discountedPrice` from service details API |
| Each selected variant | Sum of selected sub-variant prices (shown as separate lines) |
| Service Fee | **4% of subtotal** (shared app constant) |
| GST/Tax | **5% of subtotal** (shared app constant) |
| **Total** | See formula below |
| Pay Now button | `Pay Now \| $<total>` |

### 2.2 App pricing formula (source of truth for customer-facing total)

```
subtotal     = serviceDiscountedPrice + sum(selectedVariantPrices)
serviceFee   = subtotal × 0.04
tax (GST)    = subtotal × 0.05
totalAmount  = subtotal + serviceFee + tax
```

All monetary values should be rounded to **2 decimal places** at the final step (recommended: round fee and tax to 2 decimals, then sum).

### 2.3 Worked examples

#### Example A — Service $100, no variants

| Field | Value |
|-------|------:|
| Subtotal | $100.00 |
| Service fee (4%) | $4.00 |
| GST/Tax (5%) | $5.00 |
| **Total (app + Stripe)** | **$109.00** |

#### Example B — Service $300, variants $70

| Field | Value |
|-------|------:|
| Subtotal | $370.00 |
| Service fee (4%) | $14.80 |
| GST/Tax (5%) | $18.50 |
| **Total (app + Stripe)** | **$403.30** |

#### Example C — Service $300, variants $70, quantity 2 (if supported later)

| Field | Value |
|-------|------:|
| Subtotal | ($300 + $70) × 2 = $740.00 |
| Service fee (4%) | $29.60 |
| GST/Tax (5%) | $37.00 |
| **Total** | **$806.60** |

> **Note:** Quantity is supported in app controller logic today (`quantity × price`). If backend does not support quantity yet, align with mobile team. If supported, fee/tax rules must be confirmed (fee once vs per unit).

**Same fee/tax rule applies to product checkout** on cart subtotal (delivery/tip/promo stay separate).

---

## 3. Current API behavior (problem)

### 3.1 Request today — `POST /api/v1/bookings`

```json
{
  "serviceId": "<service_id>",
  "bookingItems": [
    {
      "variantId": "<variant_id>",
      "subVariantIds": ["<sub_variant_id>"]
    }
  ],
  "appointmentDate": "2026-09-15",
  "appointmentTime": "10:00 - 11:00"
}
```

**Not sent:** subtotal, service fee, tax, total, promo, tip.

### 3.2 What the app expects in response

```json
{
  "code": 200,
  "message": "...",
  "data": {
    "attributes": {
      "checkoutUrl": "https://checkout.stripe.com/...",
      "totalAmount": 392.50,
      "stripeSessionId": "cs_..."
    }
  }
}
```

The app currently only reads `checkoutUrl`. It **does not** validate `totalAmount` yet, but booking list/detail uses `totalAmount` from stored bookings — so mismatches confuse users after payment.

### 3.3 Observed mismatch

| Step | Example A ($100 service) |
|------|-------------------------:|
| App Confirm Booking | $109.00 |
| Stripe Checkout (current, if fee/tax missing) | ~$100.00 |
| Booking record `totalAmount` (current, if fee/tax missing) | ~$100.00 |

**Root cause:** Backend Stripe session is built from **subtotal only** (service + variants), without **4% service fee** and **5% GST/tax**.

---

## 4. Required backend changes

### 4.1 Single rule

> **Stripe `amount_total` must equal the app Confirm Booking total**, using the formula in section 2.2.

The customer must never see $109.00 in the app and $100.00 on Stripe.

### 4.2 Server-side calculation (mandatory)

**Do not trust totals sent from the mobile app for charging.**  
The backend must **recalculate** from authoritative data:

1. Load service by `serviceId` → use **discounted price** (same field the app uses).
2. Load each sub-variant by IDs in `bookingItems` → sum variant prices.
3. Apply the same fee and tax rates as the app (or from config — see 4.3).
4. Create Stripe Checkout Session for **exactly** `totalAmount`.
5. Persist full breakdown on the booking document.

This prevents tampering and keeps Stripe aligned with the app.

### 4.3 Recommended config (avoid hardcoding in multiple places)

Store in admin config / env so app and backend can stay in sync:

```env
BOOKING_SERVICE_FEE_RATE=0.04
BOOKING_TAX_RATE=0.05
```

Long term, expose these via a public config endpoint so the app can read them instead of hardcoding. Until then, backend **must** use `0.04` and `0.05` to match current app builds.

### 4.4 Booking document — store full breakdown

Extend booking model (names can match your conventions):

```json
{
  "serviceBasePrice": 300.00,
  "variantsTotal": 70.00,
  "subtotal": 370.00,
  "serviceFee": 14.80,
  "tax": 18.50,
  "tip": 0.00,
  "promoDiscount": 0.00,
  "totalAmount": 403.30,
  "adminCommission": 0.00,
  "beauticianAmount": 0.00,
  "paymentStatus": "pending",
  "stripeSessionId": "cs_...",
  "stripePaymentIntentId": "pi_..."
}
```

**`totalAmount`** = amount charged on Stripe = app Confirm Booking total.

Commission split (`adminCommission`, `beauticianAmount`) should be calculated from appropriate base (clarify with product owner — e.g. from subtotal before tax, or from total after fees).

---

## 5. Stripe Checkout implementation guide

### 5.1 Create session with line items (recommended)

Use Stripe Checkout **line items** so the Stripe page breakdown is clear to the customer:

| Line item | Amount (cents) | Example B |
|-----------|---------------:|----------:|
| Service | `serviceDiscountedPrice × 100` | 30000 |
| Variants (one or grouped) | `variantsTotal × 100` | 7000 |
| Service fee (4%) | `serviceFee × 100` | 1480 |
| GST/Tax (5%) | `tax × 100` | 1850 |
| **Total** | **40330** | **403.30** |

```javascript
// Pseudocode — Node.js Stripe SDK
const subtotal = serviceDiscountedPrice + variantsTotal;
const serviceFee = round(subtotal * 0.04, 2);
const tax = round(subtotal * 0.05, 2);
const totalAmount = subtotal + serviceFee + tax;

const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  success_url: `${BASE_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${BASE_URL}/payment/cancel`,
  line_items: [
    {
      price_data: {
        currency: 'usd',
        product_data: { name: service.name },
        unit_amount: Math.round(serviceDiscountedPrice * 100),
      },
      quantity: 1,
    },
    // Optional: one line per variant, or single "Add-ons" line
    ...(variantsTotal > 0 ? [{
      price_data: {
        currency: 'usd',
        product_data: { name: 'Service add-ons' },
        unit_amount: Math.round(variantsTotal * 100),
      },
      quantity: 1,
    }] : []),
    {
      price_data: {
        currency: 'usd',
        product_data: { name: 'Service fee (4%)' },
        unit_amount: Math.round(serviceFee * 100),
      },
      quantity: 1,
    },
    {
      price_data: {
        currency: 'usd',
        product_data: { name: 'GST/Tax (5%)' },
        unit_amount: Math.round(tax * 100),
      },
      quantity: 1,
    },
  ],
  metadata: {
    bookingId: booking._id.toString(),
    serviceId,
    subtotal: subtotal.toFixed(2),
    serviceFee: serviceFee.toFixed(2),
    tax: tax.toFixed(2),
    totalAmount: totalAmount.toFixed(2),
  },
});
```

### 5.2 Validation before creating session

- Reject if service inactive or beautician unavailable.
- Reject if any `variantId` / `subVariantId` invalid or not belonging to service.
- Reject if `appointmentDate` / `appointmentTime` invalid.
- Recalculate prices from DB; **ignore** any client-sent totals (until app sends them for audit only).

### 5.3 Webhook

On `checkout.session.completed`:

1. Verify `session.amount_total / 100 === booking.totalAmount`.
2. Set `paymentStatus = paid` (or your enum).
3. Store `stripePaymentIntentId`.

On failure/cancel: keep booking as pending/unpaid; app returns user to Confirm Booking.

### 5.4 Success / cancel URLs

The mobile WebView detects:

- URL contains `success` → booking success flow
- URL contains `cancel` or `fail` → return to Confirm Booking

Ensure redirect URLs match this pattern (existing product checkout likely already does).

---

## 6. Suggested API contract update (optional but recommended)

### Option A — Backend-only recalculation (minimum change)

Keep current request body. Backend applies section 2.2 formula internally.  
**No mobile change required** for payment amount alignment.

### Option B — Request includes preview + server validates (recommended for audit)

App may later send breakdown for logging; backend recalculates and rejects if mismatch > $0.01:

```json
{
  "serviceId": "...",
  "bookingItems": [...],
  "appointmentDate": "2026-09-15",
  "appointmentTime": "10:00 - 11:00",
  "clientPreview": {
    "subtotal": 370.00,
    "serviceFee": 14.80,
    "tax": 18.50,
    "totalAmount": 403.30
  }
}
```

```json
// 400 response if preview does not match server calculation
{
  "code": 400,
  "message": "Price has changed. Please review your booking.",
  "data": {
    "attributes": {
      "serverCalculation": {
        "subtotal": 370.00,
        "serviceFee": 14.80,
        "tax": 18.50,
        "totalAmount": 403.30
      }
    }
  }
}
```

### Enhanced `POST /bookings` response

Return breakdown so mobile can optionally verify before opening Stripe:

```json
{
  "code": 201,
  "message": "Booking created",
  "data": {
    "attributes": {
      "bookingId": "...",
      "checkoutUrl": "https://checkout.stripe.com/c/pay/cs_...",
      "stripeSessionId": "cs_...",
      "pricing": {
        "serviceBasePrice": 300.00,
        "variantsTotal": 70.00,
        "subtotal": 370.00,
        "serviceFee": 14.80,
        "tax": 18.50,
        "totalAmount": 403.30,
        "currency": "usd"
      }
    }
  }
}
```

---

## 7. Future features (not in app totals yet — plan ahead)

The Confirm Booking UI has **Add Promo Code** and **Add Tip** rows, but they **do not** change the total or API payload today.

When implemented:

| Feature | Backend expectation |
|---------|---------------------|
| Promo code | Accept `promoCode` on `POST /bookings`, validate, subtract discount **before** tax (confirm rule with product) |
| Tip | Accept `tip` amount or percentage, add **after** subtotal (confirm rule with product) |
| Updated formula | Document new order of operations and update both app + backend |

Until then, Stripe total = section 2.2 formula only.

---

## 8. Test cases for backend QA

| # | Service | Variants | Expected subtotal | Fee (4%) | Tax (5%) | **Stripe total** |
|---|--------:|---------:|------------------:|---------:|---------:|-----------------:|
| 1 | 100.00 | 0.00 | 100.00 | 4.00 | 5.00 | **109.00** |
| 2 | 300.00 | 70.00 | 370.00 | 14.80 | 18.50 | **403.30** |
| 3 | 50.00 | 25.50 | 75.50 | 3.02 | 3.78 | **82.30** |
| 4 | 99.99 | 0.01 | 100.00 | 4.00 | 5.00 | **109.00** |

For each test:

1. `POST /bookings` returns `checkoutUrl`.
2. Open Stripe Checkout → **Total must match column "Stripe total"**.
3. Complete test payment → booking `totalAmount` equals same value.
4. GET booking list → customer app shows same `totalAmount`.

---

## 9. Checklist for backend developer

- [ ] Recalculate subtotal from service `discountedPrice` + variant prices in DB
- [ ] Add **4% service fee** on subtotal (same as app)
- [ ] Add **5% GST/tax** on subtotal (same as app)
- [ ] Create Stripe Checkout Session for **exact** `totalAmount`
- [ ] Persist breakdown fields on booking document
- [ ] Set `totalAmount` on booking = Stripe charged amount
- [ ] Webhook updates `paymentStatus` after successful payment
- [ ] Success/cancel URLs work with mobile WebView (`success` / `cancel` in URL)
- [ ] Return `pricing` object in create-booking response (recommended)
- [ ] Run QA matrix in section 8

---

## 10. Reference — mobile code locations

| Item | File |
|------|------|
| Confirm Booking total formula | `lib/features/customer/customerConfirmBookings/presentation/customer_confirm_bookings.dart` |
| Shared fee/tax rates | `lib/core/constants/app_constants.dart` (`serviceFeeRate`, `gstTaxRate`) |
| Subtotal (service + variants) | `lib/features/customer/serviceBookingScreen/presentation/controller/service_booking_details_controller.dart` |
| `POST /bookings` call | `lib/features/customer/customerServices/data/customer_service_book_service.dart` |
| Stripe WebView | `lib/core/widgets/payment/stripe_payment_webview.dart` |
| Booking list `totalAmount` display | `lib/features/customer/customerBookingList/data/customer_booking_list_response_model.dart` |
| Product checkout fee/tax | `lib/features/customer/checkOut/presentation/screen/check_out_screen.dart` |

**API base URL (production):** `https://server.thenoireplace.com/api/v1/`  
**Bookings endpoint:** `POST bookings`

---

## 11. Contact / alignment

If fee or tax rules change (e.g. fee becomes configurable per country), update:

1. Backend config
2. This document
3. Mobile app constants (or fetch from config API)

**Acceptance criterion:** For any booking, the amount on **Confirm Booking**, **Stripe Checkout**, and **booking.totalAmount** after payment are **identical**.

---

*Document version: 1.0 — Service booking Stripe alignment for TNP Beauty mobile app.*
