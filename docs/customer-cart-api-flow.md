# Customer cart — API flow (Flutter)

**Status:** **DONE** (Flutter)  
**Related:** Promo product + service checkout also **DONE** — see `docs/promo-code-production-flow.md`

---

## What we implemented

| User action | HTTP | Path | Flutter |
|-------------|------|------|---------|
| Load cart | `GET` | `/cart` | Already had |
| Change quantity | `PATCH` | `/cart/items/{id}` | Already had (`quantity`) |
| Remove **one** line | `DELETE` | `/cart/items/{id}` | **DONE** |
| Clear **entire** cart | `DELETE` | `/cart` | **DONE** |

Constants: `ApiConstants.cart` → `cart`, `ApiConstants.cartItems` → `cart/items`.

---

## UX wiring

### Single item remove
- **Where:** My Cart (`CartScreen`) quantity control
- **When qty > 1:** minus → `PATCH` decrement (unchanged)
- **When qty ≤ 1:** trash icon → `DELETE /cart/items/{id}` then refresh cart
- **Feedback:** success / error snackbar; empty state if vendor has no items left
- **Guard:** ignore taps while `isUpdating`

### Entire cart clear
- **Where:** All Cart (`MultiVendorCartScreen`) app bar **Clear**
- **Confirm:** “Clear cart?” dialog (Cancel / Clear)
- **API:** `DELETE /cart` then refresh
- **Feedback:** success / error snackbar; empty cart UI

---

## Code map

| Layer | File |
|-------|------|
| Paths | `lib/features/customer/multiVendorCartScreen/data/cart_api_paths.dart` |
| Service | `lib/features/customer/multiVendorCartScreen/data/multi_vendor_cart_service.dart` → `removeItem`, `clearCart` |
| Controller | `.../controller/multi_vendor_cart_controller.dart` → `removeCartItem`, `clearEntireCart` |
| UI single | `lib/features/customer/cart/presentation/screen/cart_screen.dart` |
| UI clear | `.../multi_vendor_cart_screen.dart` Clear action |
| Tests | `test/cart_remove_flow_test.dart` |

---

## Tests

```bash
# Prefer FVM SDK for this repo
./.fvm/flutter_sdk/bin/flutter test test/cart_remove_flow_test.dart
```

Covers:
- clear path = `cart` (not `/cart/items/...`)
- single remove path = `cart/items/{id}`
- empty id rejected
- qty 1 → remove; qty > 1 → decrement

---

## Do / Don’t

| Do | Don’t |
|----|--------|
| Refresh cart after DELETE | Optimistic-only remove without API |
| Confirm before clear all | Call clear when cart already empty |
| Use item id for single DELETE | Call `DELETE /cart` for one line |

---

## One line

**Single trash → `DELETE /cart/items/{id}`; Clear all → `DELETE /cart`; qty change stays `PATCH`.**

---

*File:* `docs/customer-cart-api-flow.md`
