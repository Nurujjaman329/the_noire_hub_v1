import '../../../../core/constants/api_constants.dart';

/// Pure path + UX helpers for cart mutations (unit-testable without Dio).
///
/// DELETE contracts:
/// - Entire cart → `DELETE /cart`
/// - Single line  → `DELETE /cart/items/{id}`
class CartApiPaths {
  CartApiPaths._();

  /// DELETE /cart — clear entire cart
  static String clearCart() => ApiConstants.cart;

  /// DELETE /cart/items/{id} — remove one line item
  static String removeItem(String cartItemId) {
    final id = cartItemId.trim();
    if (id.isEmpty) {
      throw ArgumentError('cartItemId is required');
    }
    return '${ApiConstants.cartItems}/$id';
  }

  /// PATCH /cart/items/{id} — update quantity (unchanged contract)
  static String updateItem(String cartItemId) {
    final id = cartItemId.trim();
    if (id.isEmpty) {
      throw ArgumentError('cartItemId is required');
    }
    return '${ApiConstants.cartItems}/$id';
  }

  /// Minus at qty 1 → remove via DELETE; otherwise decrement via PATCH.
  static bool shouldRemoveOnDecrement(int currentQuantity) =>
      currentQuantity <= 1;

  static int nextQuantityAfterDecrement(int currentQuantity) =>
      currentQuantity - 1;
}
