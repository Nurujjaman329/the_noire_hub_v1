import 'package:flutter_test/flutter_test.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import 'package:the_noire_hub_v1/features/customer/multiVendorCartScreen/data/cart_api_paths.dart';

/// Documents the cart DELETE contracts used by UI + service.
///
/// - Single item → DELETE /cart/items/{id}
/// - Entire cart → DELETE /cart
void main() {
  group('Cart DELETE API paths', () {
    test('entire cart uses DELETE /cart', () {
      expect(CartApiPaths.clearCart(), ApiConstants.cart);
      expect(CartApiPaths.clearCart(), 'cart');
    });

    test('single item uses DELETE /cart/items/{id}', () {
      expect(
        CartApiPaths.removeItem('item_42'),
        '${ApiConstants.cartItems}/item_42',
      );
      expect(CartApiPaths.removeItem('item_42'), 'cart/items/item_42');
    });

    test('remove path is distinct from clear path', () {
      expect(CartApiPaths.removeItem('x'), isNot(CartApiPaths.clearCart()));
      expect(CartApiPaths.removeItem('x').startsWith('cart/items/'), isTrue);
      expect(CartApiPaths.clearCart(), 'cart');
    });

    test('trims cart item id before building path', () {
      expect(CartApiPaths.removeItem('  id99  '), 'cart/items/id99');
    });

    test('rejects empty cart item id for single remove', () {
      expect(() => CartApiPaths.removeItem(''), throwsArgumentError);
      expect(() => CartApiPaths.removeItem('   '), throwsArgumentError);
    });
  });

  group('Cart PATCH path stays unchanged', () {
    test('update item still uses /cart/items/{id}', () {
      expect(CartApiPaths.updateItem('abc123'), 'cart/items/abc123');
    });

    test('rejects empty id for update', () {
      expect(() => CartApiPaths.updateItem(''), throwsArgumentError);
      expect(() => CartApiPaths.updateItem('  '), throwsArgumentError);
    });
  });

  group('Minus button → remove vs decrement', () {
    test('qty 1 (or less) triggers single-item DELETE', () {
      expect(CartApiPaths.shouldRemoveOnDecrement(1), isTrue);
      expect(CartApiPaths.shouldRemoveOnDecrement(0), isTrue);
    });

    test('qty > 1 keeps PATCH decrement (no DELETE)', () {
      expect(CartApiPaths.shouldRemoveOnDecrement(2), isFalse);
      expect(CartApiPaths.shouldRemoveOnDecrement(5), isFalse);
    });

    test('next quantity after decrement', () {
      expect(CartApiPaths.nextQuantityAfterDecrement(3), 2);
      expect(CartApiPaths.nextQuantityAfterDecrement(1), 0);
    });

    test('UI flow: qty1 remove path matches DELETE contract', () {
      const qty = 1;
      const cartItemId = 'line_abc';

      final shouldDelete = CartApiPaths.shouldRemoveOnDecrement(qty);
      expect(shouldDelete, isTrue);

      final path = CartApiPaths.removeItem(cartItemId);
      expect(path, 'cart/items/line_abc');
    });

    test('UI flow: qty2 uses update path not clear-cart', () {
      const qty = 2;
      const cartItemId = 'line_abc';

      final shouldDelete = CartApiPaths.shouldRemoveOnDecrement(qty);
      expect(shouldDelete, isFalse);

      final nextQty = CartApiPaths.nextQuantityAfterDecrement(qty);
      expect(nextQty, 1);
      expect(CartApiPaths.updateItem(cartItemId), 'cart/items/line_abc');
      expect(CartApiPaths.clearCart(), isNot(CartApiPaths.updateItem(cartItemId)));
    });
  });

  group('Entire clear vs single remove (user intent)', () {
    test('Clear all must hit /cart only', () {
      expect(CartApiPaths.clearCart(), 'cart');
      expect(CartApiPaths.clearCart().contains('/items'), isFalse);
    });

    test('Clear all must never use an item id in the path', () {
      final clear = CartApiPaths.clearCart();
      final single = CartApiPaths.removeItem('any-id');
      expect(clear, isNot(single));
      expect(single.endsWith('/any-id'), isTrue);
    });
  });
}
