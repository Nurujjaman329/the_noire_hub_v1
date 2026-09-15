# Customer promo — API: What has vs What need

Same pages as the UI doc. Sellers create APIs = OK (not listed below).

---

## 1) Deals & Promos (Profile list)

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
GET /promo-codes/all               Same API is enough
                                   (optional: return seller name,
                                    role, product/service label)

NO apply API needed here           Do NOT call /promo-codes/apply
                                   UI only: Copy code
```

**Human meaning:** User only browses. One list API is enough. No “use promo” API on this page.

---

## 2) Product checkout

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
GET /promo-codes/all
  ?createdBy={vendorId}            Keep — show this vendor’s codes

POST /product-orders
  + promoCode                      Keep — real apply at Pay

(missing)                          NEW:
                                   POST /promo-codes/validate
                                   → check code before Pay
                                   → show ✓ −$ or ✗ reason
                                   → does NOT use up the code
```

**Human meaning:** List + place order already work. Add one “check code” API so user sees if it’s valid before paying.

---

## 3) Service booking confirm

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
POST /bookings
  (can accept promoCode)           Flutter MUST send promoCode
                                   (UI exists, API field not sent)

(missing list on this page)        GET /promo-codes/all
                                   ?createdBy={beauticianId}
                                   &applicableFor=service

(missing)                          NEW:
                                   POST /promo-codes/validate
                                   → same as product checkout
```

**Human meaning:** Backend can take the code on booking. App must list that beautician’s codes, check code, then send it when user taps Pay.

---

## 4) Product details “offers”

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
Offers come with product API
(activePromoCodes)                 No new promo API

UI select does nothing             UI only: Copy code
                                   (use at checkout later)
```

**Human meaning:** No extra API. Just copy; real use happens at checkout.

---

## 5) After pay (success)

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
Stripe pay + webhook
(backend marks promo used)         No new Flutter API call

Success screen may hide promo      UI: show “Promo SAVE10 (−$10)”
                                   from booking/order response
```

**Human meaning:** Code is “taken” after successful pay (backend). App only needs to show it on the success screen.

---

## Whole journey — which API when

```
SEE (Deals list)
  → GET /promo-codes/all                 ✅ already has

PREVIEW (Checkout / Booking)
  → GET /promo-codes/all?createdBy=...   ✅ already has
  → POST /promo-codes/validate           ❌ NEED (new)

PAY
  → POST /product-orders + promoCode     ✅ already has
  → POST /bookings + promoCode           ✅ backend has / Flutter NEED send

DONE (after Stripe success)
  → webhook consumes promo               ✅ backend already
  → show promo on success UI             ❌ Flutter NEED show
```

---

## Short table (easy for humans)

| Page | Already has | Need |
|------|-------------|------|
| Deals list | `GET /promo-codes/all` | No new API (UI copy only) |
| Product checkout | List + `POST /product-orders` | **Validate** API |
| Service booking | `POST /bookings` can take code | List + **Validate** + **send** `promoCode` |
| Product details | Product payload offers | No new API |
| After pay | Webhook uses promo | Show on success UI |

---

## Do not use

`POST /promo-codes/apply` — looks like “use code” but burns usage too early.  
Use **validate** before pay instead.

---

## One line

**Already have:** list + create order/booking with `promoCode` + use after pay.  
**Need:** one new **validate** API, and Flutter must **send/show** promo on booking + success.
