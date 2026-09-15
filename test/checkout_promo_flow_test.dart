import 'package:flutter_test/flutter_test.dart';
import 'package:the_noire_hub_v1/core/constants/app_constants.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/promo_request_bodies.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/promo_validate_response_model.dart';

/// Mirrors CheckOutController promo resolve logic (unit-testable, no Dio/GetX).
String? resolveCheckoutPromoCode({
  String? promoCodeArg,
  AppliedPromoResult? appliedPromo,
}) {
  if (promoCodeArg != null && promoCodeArg.trim().isNotEmpty) {
    return promoCodeArg.trim();
  }
  return appliedPromo?.code;
}

double? resolveCheckoutTip(double? tip) {
  if (tip != null && tip > 0) return tip;
  return null;
}

void main() {
  group('Product checkout — validate before pay', () {
    test('validate uses code + vendorId (product context)', () {
      final body = PromoRequestBodies.validate(
        code: ' SAVE10 ',
        subtotal: 120.5,
        vendorId: 'vendor_abc',
      );

      expect(body['code'], 'SAVE10');
      expect(body['subtotal'], 120.5);
      expect(body['vendorId'], 'vendor_abc');
      expect(body.containsKey('beauticianId'), isFalse);
      expect(body.containsKey('promoCode'), isFalse);
    });

    test('validate success UI label matches booking style', () {
      final result = AppliedPromoResult(
        code: 'SAVE10',
        discountPercentage: 10,
        discountAmount: 12,
        finalSubtotal: 108,
      );

      expect(result.successLabel, '✓ SAVE10 · −\$12.00');
    });
  });

  group('Product checkout — place order body', () {
    test('sends promoCode after validate (not code)', () {
      const validated = AppliedPromoResult(
        code: 'SAVE10',
        discountPercentage: 10,
        discountAmount: 10,
        finalSubtotal: 90,
      );

      final code = resolveCheckoutPromoCode(appliedPromo: validated);
      final body = PromoRequestBodies.productOrder(
        vendorId: 'vendor_1',
        items: [
          {'productId': 'p1', 'quantity': 2},
        ],
        deliveryMethod: 'standard',
        deliveryAddress: {
          'street': '123 Main',
          'city': 'Dhaka',
          'state': 'Dhaka',
          'country': 'Bangladesh',
        },
        tip: 5,
        promoCode: code,
      );

      expect(body['promoCode'], 'SAVE10');
      expect(body.containsKey('code'), isFalse);
      expect(body['tip'], 5);
    });

    test('omits tip and promo when not selected', () {
      final body = PromoRequestBodies.productOrder(
        vendorId: 'vendor_1',
        items: [
          {'productId': 'p1', 'quantity': 1},
        ],
        deliveryMethod: 'pickup',
        deliveryAddress: {
          'street': 'Store',
          'city': 'Dhaka',
          'state': 'Dhaka',
          'country': 'Bangladesh',
        },
        tip: resolveCheckoutTip(0),
        promoCode: resolveCheckoutPromoCode(),
      );

      expect(body.containsKey('tip'), isFalse);
      expect(body.containsKey('promoCode'), isFalse);
    });

    test('explicit promoCode arg wins over stored appliedPromo', () {
      const stored = AppliedPromoResult(
        code: 'OLD10',
        discountPercentage: 10,
        discountAmount: 10,
        finalSubtotal: 90,
      );

      expect(
        resolveCheckoutPromoCode(
          promoCodeArg: 'NEW15',
          appliedPromo: stored,
        ),
        'NEW15',
      );
      expect(
        resolveCheckoutPromoCode(appliedPromo: stored),
        'OLD10',
      );
    });
  });

  group('Product checkout — total with validated promo', () {
    test('subtotal + fee + tax + delivery + tip - promoDiscount', () {
      const subtotal = 100.0;
      const delivery = 10.0;
      const tip = 5.0;
      const promoDiscount = 10.0;

      final total = AppConstants.roundMoney(
        subtotal +
            AppConstants.serviceFeeFor(subtotal) +
            AppConstants.gstTaxFor(subtotal) +
            delivery +
            tip -
            promoDiscount,
      );

      // 100 + 4 + 5 + 10 + 5 - 10 = 114
      expect(total, 114.0);
    });

    test('without promo, tip still optional', () {
      const subtotal = 100.0;
      const tip = 0.0;

      final total = AppConstants.roundMoney(
        subtotal +
            AppConstants.serviceFeeFor(subtotal) +
            AppConstants.gstTaxFor(subtotal) +
            tip,
      );

      expect(total, 109.0);
      expect(resolveCheckoutTip(tip), isNull);
    });
  });
}
