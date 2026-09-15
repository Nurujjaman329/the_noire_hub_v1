# Customer promo — API: What has vs What need

Same pages as the UI doc. Sellers create APIs = OK (not listed below).

### Flutter implementation status

| Flow | Status |
|------|--------|
| Product checkout promo | **DONE** (list → validate → `promoCode` on order) |
| Service booking promo | **DONE** (list → validate → `promoCode` on booking) |
| Cart remove (single + clear) | **DONE** — `docs/customer-cart-api-flow.md` |

---

## 1) Deals & Promos (Profile list)

```
HAS (already)                      NEED
─────────────────────────          ─────────────────────────
GET /promo-codes/all               Same API is enough
                                   (optional: return seller name,
                                    role, product/service label)

NO apply API needed here           Do NOT call /promo-codes/apply
                                   UI only: Copy code  ✅ DONE
```

**Human meaning:** User only browses. One list API is enough. No “use promo” API on this page.

---

## 2) Product checkout — **DONE (Flutter)**

```
HAS (already)                      STATUS
─────────────────────────          ─────────────────────────
GET /promo-codes/all
  ?createdBy={vendorId}            ✅ used

POST /product-orders
  + promoCode                      ✅ sent on Pay

POST /promo-codes/validate         ✅ called before Pay
                                   → show ✓ −$ or ✗ reason
                                   → does NOT use up the code
```

**Human meaning:** List + validate + place order with `promoCode` are wired.

---

## 3) Service booking confirm — **DONE (Flutter)**

```
HAS (already)                      STATUS
─────────────────────────          ─────────────────────────
POST /bookings
  + promoCode                      ✅ Flutter sends promoCode
                                   (+ tip when selected)

GET /promo-codes/all
  ?createdBy={beauticianId}
  &applicableFor=service           ✅ used on Add Promo

POST /promo-codes/validate         ✅ same as product checkout
```

**Human meaning:** App lists that beautician’s codes, validates, then sends `promoCode` when user taps Pay.

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

Success screen may hide promo      Optional: show “Promo SAVE10 (−$10)”
                                   from booking/order response
```

**Human meaning:** Code is “taken” after successful pay (backend). App can still polish success-line UI.

---

## Whole journey — which API when

```
SEE (Deals list)
  → GET /promo-codes/all                 ✅ already has / Flutter DONE

PREVIEW (Checkout / Booking)
  → GET /promo-codes/all?createdBy=...   ✅ DONE
  → POST /promo-codes/validate           ✅ DONE (Flutter)

PAY
  → POST /product-orders + promoCode     ✅ DONE
  → POST /bookings + promoCode           ✅ DONE (Flutter sends)

DONE (after Stripe success)
  → webhook consumes promo               ✅ backend already
  → show promo on success UI             ⬜ optional polish
```

---

## Short table (easy for humans)

| Page | Already has | Flutter status |
|------|-------------|----------------|
| Deals list | `GET /promo-codes/all` | **DONE** — Copy only |
| Product checkout | List + validate + `POST /product-orders` | **DONE** |
| Service booking | List + validate + `POST /bookings` + `promoCode` | **DONE** |
| Product details | Product payload offers | Copy / polish optional |
| After pay | Webhook uses promo | Success line optional |
| Cart | GET /cart, PATCH qty | **DONE** DELETE single + clear |

---

## Do not use

`POST /promo-codes/apply` — looks like “use code” but burns usage too early.  
Use **validate** before pay instead.

---

## One line

**Done (Flutter):** product + service promo (list → validate → `promoCode` on create) + cart DELETE.  
**Optional:** richer Deals labels + promo line on success screens.
