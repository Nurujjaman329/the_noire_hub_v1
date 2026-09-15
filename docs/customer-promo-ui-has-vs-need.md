# Customer promo UI — What has vs What need

Sellers create = OK. Below is only what the user should see.

---

## 1) Deals & Promos (Profile list)

```
HAS (now)                         NEED (UI)
─────────────────────────         ─────────────────────────
[ 10% Discounts ]                 [ 10% OFF · SAVE10 ]
  SAVE10                            🏪 Glow Store · Products
  Exp: 12/31/2026                   Min $50 · Exp 12/31/2026
[ Apply ]  → fake “applied!”      [ Copy code ]
                                  (no “applied to account”)
```

---

## 2) Product checkout

```
HAS                               NEED
─────────────────────────         ─────────────────────────
“Select or enter promo”           “Select promo”  OR  real Enter box
 ↓ list pick only                  ↓ pick OR paste
Shows −$ locally                   After select:
                                   ✓ SAVE10 · −$10
                                   (or red: “Not valid for this store”)
Pay → sends promoCode ✅           Same + optional Validate preview
```

---

## 3) Service booking confirm

```
HAS                               NEED
─────────────────────────         ─────────────────────────
[ Add Promo Code ]                [ Add Promo Code ]
  → text field                      → pick beautician codes
  → Redeem = nothing ❌               OR paste code
Total: no promo line                ✓ CODE · −$X on breakdown
Pay: no promoCode sent ❌           Pay: include promoCode ✅
```

---

## 4) Product details “offers”

```
HAS                               NEED
─────────────────────────         ─────────────────────────
Tap offer → looks selected          Tap → [ Copy ] only
(not used at checkout) ❌           “Use this code at checkout”
```

---

## 5) After pay (booking / order success)

```
HAS                               NEED
─────────────────────────         ─────────────────────────
Success, maybe no promo line        Paid $90
                                    Promo SAVE10 (−$10)
```

---

## One picture of the whole user journey

```
SEE          →    PREVIEW         →    PAY           →    DONE
Deals list        Checkout/           Stripe              Success
(copy only)       Booking confirm     (discounted $)      “Promo used”
                  ✓ / ✗ message
```

---

## Do / Don’t for UI

| Do | Don’t |
|----|--------|
| Show store/beautician + Products/Services | Say “applied to your account” on browse |
| Show discount on confirm before pay | Empty Redeem button |
| Copy code from list | Fake Apply dialog |
| Clear error if code wrong | Hide that promo failed |

---

## UI-only summary

Browse = info + copy  
Checkout / booking = select/paste + green/red preview  
Success = show promo used
