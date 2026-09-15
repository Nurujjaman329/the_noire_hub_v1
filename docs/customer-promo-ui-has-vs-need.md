# Customer promo UI — What has vs What need

Sellers create = OK. Below is only what the user should see.

### Flutter status

| Screen | Status |
|--------|--------|
| Product checkout promo | **DONE** |
| Service booking promo | **DONE** |
| Deals & Promos (Copy) | **DONE** |
| Cart delete / clear | **DONE** — see `docs/customer-cart-api-flow.md` |

---

## 1) Deals & Promos (Profile list) — **DONE**

```
HAS (now)                         STATUS
─────────────────────────         ─────────────────────────
Browse list + Copy code           ✅ DONE
Hint: use at checkout/booking     ✅ DONE
No “applied to account” fake      ✅ DONE
```

Optional polish: show store/beautician + Products/Services badge when API fields exist.

---

## 2) Product checkout — **DONE**

```
HAS                               STATUS
─────────────────────────         ─────────────────────────
Select / enter promo              ✅ wired
Validate preview                  ✅ ✓ CODE · −$X  or red error
Pay → sends promoCode             ✅ DONE
```

---

## 3) Service booking confirm — **DONE**

```
HAS                               STATUS
─────────────────────────         ─────────────────────────
[ Add Promo Code ]                ✅ pick / paste
Validate + breakdown line         ✅ DONE
Pay: include promoCode            ✅ DONE
```

---

## 4) Product details “offers”

```
HAS                               NEED
─────────────────────────         ─────────────────────────
Tap offer → looks selected          Tap → [ Copy ] only
(not used at checkout)              “Use this code at checkout”
```

Optional polish — real apply still only at checkout.

---

## 5) After pay (booking / order success)

```
HAS                               NEED
─────────────────────────         ─────────────────────────
Success                           Optional polish:
                                  Promo SAVE10 (−$10)
```

---

## One picture of the whole user journey

```
SEE          →    PREVIEW         →    PAY           →    DONE
Deals list        Checkout/           Stripe              Success
(copy only) ✅    Booking confirm ✅  (discounted $)      “Promo used”
                  ✓ / ✗ message ✅                        (optional UI)
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

Browse = info + copy ✅  
Checkout / booking = select/paste + green/red preview ✅  
Success = show promo used (optional polish)
