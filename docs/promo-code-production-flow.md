# Promo Code — Production Flow Doc (Backend + Flutter)

**App:** The Noire Hub (production)  
**Goal:** Make promo work clearly for **product checkout** and **service booking**, without major breaking changes.

**Rule for production:** Prefer **add / fix wire-up**. Do **not** redesign seller CRUD, cart, Stripe Checkout, or wallet.

---

## 1. Target user flow (keep this)

```
See promo → Validate (before pay, no burn) → Attach on create order/booking
→ Pay Stripe → Consume promo only after payment success → Show on details
```

| Moment | Show promo? | Count as “used”? |
|--------|-------------|------------------|
| Browse / Deals list | Yes | No |
| Confirm checkout / booking | Yes + preview | No |
| Create order / booking | Attached on record | No |
| Stripe success (webhook) | Show on success | **Yes** |
| Stripe cancel / fail | Can retry | No |

---

## 2. What already works in production

### Backend (keep as-is)

| API | Status | Notes |
|-----|--------|-------|
| `POST /api/v1/promo-codes` | OK | Vendor/beautician create |
| `GET /api/v1/promo-codes` | OK | Own list (seller) |
| `PATCH /api/v1/promo-codes/:id` | OK | Update title/expiry/etc. |
| `DELETE /api/v1/promo-codes/:id` | OK | Soft delete |
| `GET /api/v1/promo-codes/all` | OK | Customer discover (can use `createdBy`) |
| `POST /api/v1/product-orders` + `promoCode` | OK | Inline apply at create |
| `POST /api/v1/bookings` + `promoCode` | OK / ready | Inline apply at create |
| Payment webhook consume usage | OK idea | Keep: usage after pay |

### Flutter (keep as-is where possible)

| Page / feature | Status |
|----------------|--------|
| Profile → **Add Promo Code** (`AddDealsPomosScreen`) | Works — seller CRUD |
| Product **Checkout** (`CheckOutScreen`) | Works — picks vendor promo, sends `promoCode` |
| Customer **Deals & Promos** screen | List UI exists (Apply is fake) |
| Booking confirm → **Add Promo** | UI exists but **not wired** |

---

## 3. Page → what happens → APIs (current vs needed)

### A) Vendor / Beautician — create promo

| Item | Detail |
|------|--------|
| **Flutter page** | Profile → Add Promo Code → `AddDealsPomosScreen` |
| **Route** | `addDealsPromos` |
| **What happens** | Create / list / edit / delete own promos |
| **APIs used now** | `GET/POST/PATCH/DELETE /promo-codes` |
| **Backend need** | **None** (do not change contract) |
| **Flutter need** | **None** (optional: rename “Stock” label → “Max uses”) |

`applicableFor` today: vendor → `product`, beautician → `service` (from app cache/role). Keep that.

---

### B) Customer — global Deals & Promos (browse only)

| Item | Detail |
|------|--------|
| **Flutter page** | Profile → Deals & Promos → `CustomerDealsPromosScreen` |
| **Route** | `dealsPromos` |
| **What happens now** | `GET /promo-codes/all` (no filter). Apply shows fake “applied to account” |
| **What should happen** | Browse only. Show **who** (store/beautician) + **product vs service**. Button = **Copy code** or **Use at checkout/booking** — not “applied to account” |
| **API call** | `GET /promo-codes/all` (optional filters later) |
| **Backend need (small, additive)** | Enrich each item with clear creator info (see §5). **Do not remove fields.** |
| **Flutter need** | Show `businessName` / role / `applicableFor`. Stop fake Apply dialog. |

**Production note:** This page must **not** call `/promo-codes/apply`.

---

### C) Customer — Product checkout (real apply path)

| Item | Detail |
|------|--------|
| **Flutter page** | Cart → Checkout → `CheckOutScreen` |
| **Route** | `checkOutScreen` |
| **What happens now** | Load promos for vendor → pick from list → local % discount UI → `POST /product-orders` with `promoCode` → Stripe WebView |
| **What should happen** | Same, plus optional validate before pay + optional paste code |
| **APIs** | 1) `GET /promo-codes/all?createdBy={vendorId}`  2) *(new)* `POST /promo-codes/validate`  3) `POST /product-orders` `{ ..., promoCode }` |
| **Backend need** | Add **validate** (new). Keep product-order create as-is. |
| **Flutter need** | Call validate when user selects/enters code. Keep sending `promoCode` on place order (already done). Fix copy “Select or enter” (add text field **or** remove “enter”). |

**Do not change:** Stripe Checkout URL flow, cart structure, multi-vendor one-order-per-vendor.

---

### D) Customer — Service booking (broken today — wire only)

| Item | Detail |
|------|--------|
| **Flutter pages** | Confirm booking → `CustomerConfirmBookings` → Add Promo → `AddPromoScreen` |
| **Routes** | confirm booking flow + `addPromoScreen` |
| **What happens now** | Promo UI exists; Redeem = empty; `POST /bookings` **does not send** `promoCode` |
| **What should happen** | Load that beautician’s codes → pick/paste → validate → show discount → create booking with `promoCode` → Stripe |
| **APIs** | 1) `GET /promo-codes/all?createdBy={beauticianId}&applicableFor=service`  2) *(new)* `POST /promo-codes/validate`  3) `POST /bookings` `{ ..., promoCode, tip? }` |
| **Backend need** | Confirm booking body accepts `promoCode` (+ `tip` if used). Add **validate**. No new booking payment redesign. |
| **Flutter need** | Wire Redeem; pass code back to confirm; include `promoCode` (and `tip`) in create booking body. |

**Do not change:** date/slot selection, Stripe WebView success/cancel URL handling (unless already broken).

---

### E) Product details — “offers” (optional / low priority)

| Item | Detail |
|------|--------|
| **Flutter page** | Product details |
| **What happens now** | Shows `activePromoCodes`; select is UI-only, not passed to cart |
| **Production-safe fix** | Either: **Copy code** only, or save selected code in memory and preselect on checkout. Do **not** invent new cart promo fields unless needed. |
| **Backend need** | **None** if product payload already returns `activePromoCodes` |
| **Flutter need** | Stop implying “applied”; Copy or carry code to checkout |

---

### F) Home “Deals & Promos” tile

| Item | Detail |
|------|--------|
| **What happens now** | Navigates to `serviceDealsPromos` — route commented out / broken |
| **Production-safe fix** | Point tile to existing `dealsPromos` route (same as Profile Deals) |
| **Backend need** | None |
| **Flutter need** | One-line route fix |

---

### G) Promo history

| Item | Detail |
|------|--------|
| **Flutter page** | `dealsPromosHistory` |
| **What happens now** | Mock data |
| **Production-safe suggestion** | Hide menu entry **or** leave as-is until a later “my used promos” API. **Do not** build new API in this phase unless required. |
| **Backend need** | Not required for phase 1 |

---

## 4. API map — who calls what

### Seller (vendor / beautician)

| Page | Method | Endpoint | When |
|------|--------|----------|------|
| Add Promo | `GET` | `/promo-codes` | Open screen |
| Add Promo | `POST` | `/promo-codes` | Create |
| Add Promo | `PATCH` | `/promo-codes/:id` | Edit |
| Add Promo | `DELETE` | `/promo-codes/:id` | Delete |

### Customer — product checkout

| Page | Method | Endpoint | When |
|------|--------|----------|------|
| Checkout | `GET` | `/promo-codes/all?createdBy={vendorId}` | Open promo sheet |
| Checkout | `POST` | `/promo-codes/validate` **(NEW)** | After select/enter code |
| Checkout | `POST` | `/product-orders` | Pay Now (body includes `promoCode`) |
| WebView | — | Stripe hosted URL | Pay |

### Customer — service booking

| Page | Method | Endpoint | When |
|------|--------|----------|------|
| Confirm / Add Promo | `GET` | `/promo-codes/all?createdBy={beauticianId}&applicableFor=service` | Open promo |
| Confirm / Add Promo | `POST` | `/promo-codes/validate` **(NEW)** | After select/enter |
| Confirm booking | `POST` | `/bookings` | Pay Now (body includes `promoCode`) |
| WebView | — | Stripe hosted URL | Pay |

### Customer — browse Deals

| Page | Method | Endpoint | When |
|------|--------|----------|------|
| Deals & Promos | `GET` | `/promo-codes/all` | Open list |

### Do NOT use in app (production)

| Endpoint | Why |
|----------|-----|
| `POST /promo-codes/apply` | Increments usage **before** pay — unsafe. Flutter should **not** call it. |

---

## 5. Backend work (minimal / production-safe)

### Must do

1. **Add** `POST /api/v1/promo-codes/validate`  
   - **Does not** change `currentUsageCount` / `usedBy`  
   - Body example:
     ```json
     {
       "code": "SAVE10",
       "subtotal": 100,
       "vendorId": "...",        // product checkout
       "beauticianId": "..."     // OR booking (prefer one context)
     }
     ```
     Alternative already close to old apply: `productId` **or** `serviceId` + `subtotal` + `code`.
   - Success example:
     ```json
     {
       "valid": true,
       "code": "SAVE10",
       "discountPercentage": 10,
       "discountAmount": 10,
       "finalAmount": 90,
       "applicableFor": "product",
       "createdBy": { "id": "...", "businessName": "...", "role": "vendor" }
     }
     ```
   - Fail: clear message (`expired`, `wrong seller`, `not for services`, `min purchase`, `already used`, `limit reached`).

2. **Keep** usage increment **only** in payment webhook (booking + product order).  
   - Create booking/order: attach promo, calculate discount, **do not** burn usage.

3. **Confirm** `POST /bookings` accepts optional `promoCode` (and `tip` if Flutter will send).  
   - Additive fields only — old clients without them still work.

### Should do (additive, non-breaking)

4. Enrich `GET /promo-codes/all` items (add fields, don’t remove):
   - `createdBy.role` (`vendor` | `beautician`)
   - `createdBy.businessName` / `fullName` (already partly there)
   - `applicableFor`, `minPurchaseAmount`, remaining uses if easy

5. When looking up promo at pay/webhook, prefer `{ code, createdBy }` with seller context — avoid `findOne({ code })` only (collision risk). Soft fix inside existing services.

### Avoid in this phase (major / risky)

- Do **not** redesign promo model
- Do **not** change Stripe Checkout / webhook mount
- Do **not** force global unique codes (breaks existing data)
- Do **not** make `/apply` required by Flutter
- Optional later: make `/apply` an alias of validate (stop increment). If anything still calls `/apply` in prod, fix carefully or leave unused.

---

## 6. Flutter work (minimal / production-safe)

### Must do

| Priority | Page | Change |
|----------|------|--------|
| P0 | Booking confirm + `AddPromoScreen` | Wire Redeem → validate → return code → send `promoCode` on `POST /bookings` |
| P0 | Booking confirm | Send `tip` if user selected tip (if backend supports) |
| P0 | Deals & Promos | Remove fake “applied to account”; use Copy / info only |
| P1 | Product checkout | Call **validate** before place order; keep existing `promoCode` on create |
| P1 | Product checkout | Fix “Select or enter” (add field or change copy) |
| P1 | Home Deals tile | Route to existing `dealsPromos` |

### Should do

| Priority | Page | Change |
|----------|------|--------|
| P2 | Deals list UI | Show business name + Product/Service badge from API fields |
| P2 | Product details offers | Copy code only (no fake select apply) |
| P2 | Success screens | Show “Promo X applied (−$Y)” if response has breakdown |

### Avoid

- Do not call `/promo-codes/apply`
- Do not rewrite cart or Stripe WebView
- Do not block release on promo history API
- Do not change seller create screen contract

---

## 7. Field names (contract both sides must match)

| Action | Field name |
|--------|------------|
| Validate (new) | `code` |
| Create product order | `promoCode` |
| Create booking | `promoCode` |
| List for seller’s checkout | query `createdBy` |
| Filter type | query `applicableFor` = `product` \| `service` \| `both` |

---

## 8. Suggested rollout (safe for production)

### Phase 1 — no breaking API change (can ship Flutter partly after backend validate)
1. Backend adds `/promo-codes/validate` (new route only).
2. Backend confirms booking accepts `promoCode` / `tip` (if not already live).
3. Flutter wires **booking** promo + stops fake Apply.
4. Flutter product checkout adds validate call (order create unchanged).

### Phase 2 — UX clarity (additive)
1. Backend enriches `/promo-codes/all` with role/labels.
2. Flutter shows seller + product/service on Deals list.
3. Fix home tile route + checkout “enter” copy.

### Phase 3 — cleanup (optional later)
1. Deprecate or sanitize `/apply`.
2. Promo history real API (if product wants it).
3. Webhook lookup by `{ code, createdBy }`.

---

## 9. Quick checklist for Backend vs Flutter

### Backend engineer
- [ ] Add `POST /promo-codes/validate` (no usage burn)
- [ ] Keep webhook as only place that increments usage / `usedBy`
- [ ] Confirm `POST /bookings` optional `promoCode` (+ `tip`)
- [ ] Enrich `GET /promo-codes/all` with creator role/name (additive)
- [ ] Do **not** break existing seller CRUD or product-order `promoCode`

### Flutter engineer
- [ ] Booking: send `promoCode` on create
- [ ] Booking: validate before pay
- [ ] Product checkout: validate before pay (keep create as-is)
- [ ] Deals page: no fake apply; show seller/type when API has fields
- [ ] Never call `/promo-codes/apply`
- [ ] Fix home Deals navigation to `dealsPromos`

---

## 10. One-sentence summary

**Backend:** add a safe validate API + clearer list fields; keep create-order/booking + pay-then-consume.  
**Flutter:** wire booking promo for real, validate before pay on both checkouts, and stop lying “Apply” buttons — without rewriting production payment flow.

---

*Doc location:* `docs/promo-code-production-flow.md`  
*Share this file with Backend + Flutter so both implement the same contract.*
