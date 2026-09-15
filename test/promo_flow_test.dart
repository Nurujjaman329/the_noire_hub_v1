import 'package:flutter_test/flutter_test.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import 'package:the_noire_hub_v1/core/constants/app_constants.dart';
import 'package:the_noire_hub_v1/features/customer/customerServices/data/create_booking_response_model.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/promo_request_bodies.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/promo_validate_response_model.dart';

void main() {
  group('Promo API endpoints', () {
    test('validate + list + create endpoints are correct', () {
      expect(ApiConstants.promoCodeCustomer, 'promo-codes/all');
      expect(ApiConstants.promoCodeValidate, 'promo-codes/validate');
      expect(ApiConstants.productOrders, 'product-orders');
      expect(ApiConstants.customerBookings, 'bookings');
    });
  });

  group('Field name contract (no mix-up)', () {
    test('validate body uses code, not promoCode', () {
      final body = PromoRequestBodies.validate(
        code: 'SAVE10',
        subtotal: 100,
        vendorId: 'vendor_1',
      );

      expect(body.containsKey('code'), isTrue);
      expect(body.containsKey('promoCode'), isFalse);
      expect(body['code'], 'SAVE10');
      expect(body['subtotal'], 100.0);
      expect(body['vendorId'], 'vendor_1');
      expect(body.containsKey('beauticianId'), isFalse);
    });

    test('booking validate uses beauticianId context', () {
      final body = PromoRequestBodies.validate(
        code: 'HAIR15',
        subtotal: 80,
        beauticianId: 'beautician_1',
      );

      expect(body['code'], 'HAIR15');
      expect(body['beauticianId'], 'beautician_1');
      expect(body.containsKey('vendorId'), isFalse);
    });

    test('create booking uses promoCode, not code', () {
      final body = PromoRequestBodies.booking(
        serviceId: 'svc_1',
        appointmentDate: '2026-09-20',
        appointmentTime: '10:00 AM',
        tip: 5,
        promoCode: 'HAIR15',
      );

      expect(body.containsKey('promoCode'), isTrue);
      expect(body.containsKey('code'), isFalse);
      expect(body['promoCode'], 'HAIR15');
      expect(body['tip'], 5);
    });

    test('create product order uses promoCode, not code', () {
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
        tip: 3,
        promoCode: 'SAVE10',
      );

      expect(body['promoCode'], 'SAVE10');
      expect(body.containsKey('code'), isFalse);
      expect(body['tip'], 3);
      expect(body['deliveryMethod'], 'standard');
    });
  });

  group('Booking request body', () {
    test('simple booking omits empty tip / promo / items', () {
      final body = PromoRequestBodies.booking(
        serviceId: 'svc_1',
        appointmentDate: '2026-09-20',
        appointmentTime: '10:00 AM',
        tip: 0,
        promoCode: '   ',
      );

      expect(body.keys, containsAll(['serviceId', 'appointmentDate', 'appointmentTime']));
      expect(body.containsKey('tip'), isFalse);
      expect(body.containsKey('promoCode'), isFalse);
      expect(body.containsKey('bookingItems'), isFalse);
    });

    test('full booking includes variants + tip + promoCode', () {
      final body = PromoRequestBodies.booking(
        serviceId: 'svc_1',
        appointmentDate: '2026-09-20',
        appointmentTime: '10:00 AM',
        bookingItems: [
          {
            'variantId': 'v1',
            'subVariantIds': ['sv1'],
          }
        ],
        tip: 8,
        promoCode: ' HAIR15 ',
      );

      expect(body['bookingItems'], isNotEmpty);
      expect(body['tip'], 8);
      expect(body['promoCode'], 'HAIR15'); // trimmed
    });
  });

  group('Validate response parsing', () {
    test('parses success validate payload', () {
      final model = PromoValidateResponseModel.fromJson({
        'code': 200,
        'status': 'OK',
        'message': 'Promo code is valid',
        'data': {
          'attributes': {
            'valid': true,
            'code': 'SAVE10',
            'promoId': '64f',
            'discountPercentage': 10,
            'discountAmount': 10,
            'finalSubtotal': 90,
            'applicableFor': 'product',
            'minPurchaseAmount': 50,
          }
        }
      });

      expect(model.attributes?.valid, isTrue);
      expect(model.attributes?.code, 'SAVE10');
      expect(model.attributes?.discountAmount, 10);
      expect(model.attributes?.finalSubtotal, 90);

      final ui = AppliedPromoResult(
        code: model.attributes!.code,
        discountPercentage: model.attributes!.discountPercentage,
        discountAmount: model.attributes!.discountAmount,
        finalSubtotal: model.attributes!.finalSubtotal,
      );
      expect(ui.successLabel, '✓ SAVE10 · −\$10.00');
    });

    test('parses invalid validate payload with reason', () {
      final model = PromoValidateResponseModel.fromJson({
        'code': 400,
        'status': 'ERROR',
        'message': 'This promo code is not valid for this store',
        'data': {
          'attributes': {
            'valid': false,
            'reason': 'WRONG_SELLER',
          }
        }
      });

      expect(model.attributes?.valid, isFalse);
      expect(model.attributes?.reason, 'WRONG_SELLER');
      expect(model.message, contains('not valid'));
    });
  });

  group('Create booking response parsing', () {
    test('parses checkoutUrl + priceBreakdown with promo', () {
      final model = CreateBookingResponseModel.fromJson({
        'code': 201,
        'message': 'Booking created successfully. Proceed to payment.',
        'data': {
          'attributes': {
            'booking': {
              'id': 'booking_1',
              'serviceBasePrice': 1200,
              'variantsTotal': 500,
              'subtotal': 1700,
              'serviceFee': 68,
              'tax': 85,
              'tip': 5,
              'promoCode': 'HAIR15',
              'promoDiscount': 12,
              'totalAmount': 1846,
              'paymentStatus': 'pending',
            },
            'checkoutUrl': 'https://checkout.stripe.com/c/pay/cs_test',
            'sessionId': 'cs_test',
            'priceBreakdown': {
              'serviceBasePrice': 1200,
              'variantsTotal': 500,
              'serviceDiscount': 0,
              'subtotal': 1700,
              'serviceFee': 68,
              'tax': 85,
              'tip': 5,
              'promoCode': 'HAIR15',
              'promoDiscount': 12,
              'totalAmount': 1846,
            }
          }
        }
      });

      final attrs = model.data!.attributes!;
      expect(attrs.checkoutUrl, contains('checkout.stripe.com'));
      expect(attrs.sessionId, 'cs_test');
      expect(attrs.priceBreakdown?.promoCode, 'HAIR15');
      expect(attrs.priceBreakdown?.promoDiscount, 12);
      expect(attrs.priceBreakdown?.totalAmount, 1846);
      expect(attrs.booking?.promoCode, 'HAIR15');
    });
  });

  group('UI total preview with tip + promo (booking)', () {
    test('matches app formula: fees/tax on subtotal, then tip, minus promo', () {
      const subtotal = 100.0;
      const tip = 5.0;
      const promoDiscount = 10.0;

      final total = AppConstants.roundMoney(
        AppConstants.totalWithFeesAndTax(subtotal) + tip - promoDiscount,
      );

      // 100 + 4 + 5 + 5 - 10 = 104
      expect(AppConstants.serviceFeeFor(subtotal), 4.0);
      expect(AppConstants.gstTaxFor(subtotal), 5.0);
      expect(total, 104.0);
    });

    test('product-like total: subtotal + fee + tax + delivery + tip - promo', () {
      const subtotal = 100.0;
      const delivery = 10.0;
      const tip = 3.0;
      const promoDiscount = 10.0;

      final total = AppConstants.roundMoney(
        subtotal +
            AppConstants.serviceFeeFor(subtotal) +
            AppConstants.gstTaxFor(subtotal) +
            delivery +
            tip -
            promoDiscount,
      );

      // 100 + 4 + 5 + 10 + 3 - 10 = 112
      expect(total, 112.0);
    });
  });

  group('Promo list filter (client-side applicableFor)', () {
    test('keeps service + both, drops product-only', () {
      bool matches(String type, String wanted) {
        final t = type.trim().toLowerCase();
        if (t.isEmpty || t == 'both') return true;
        return t == wanted;
      }

      expect(matches('service', 'service'), isTrue);
      expect(matches('both', 'service'), isTrue);
      expect(matches('', 'service'), isTrue);
      expect(matches('product', 'service'), isFalse);
      expect(matches('product', 'product'), isTrue);
      expect(matches('service', 'product'), isFalse);
    });

    test('expired and inactive promos must not show', () {
      bool isUsable({
        required bool isActive,
        required String expiryDate,
        DateTime? now,
      }) {
        if (!isActive) return false;
        if (expiryDate.trim().isEmpty) return true;
        final expiry = DateTime.parse(expiryDate).toLocal();
        final end = DateTime(expiry.year, expiry.month, expiry.day, 23, 59, 59);
        return !(now ?? DateTime.now()).isAfter(end);
      }

      final now = DateTime(2026, 9, 15, 12);
      expect(
        isUsable(isActive: true, expiryDate: '2026-12-31', now: now),
        isTrue,
      );
      expect(
        isUsable(isActive: true, expiryDate: '2026-09-01', now: now),
        isFalse,
      );
      expect(
        isUsable(isActive: false, expiryDate: '2026-12-31', now: now),
        isFalse,
      );
    });
  });
}
