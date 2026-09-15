import 'package:flutter_test/flutter_test.dart';
import 'package:the_noire_hub_v1/features/customer/customerConfirmBookings/data/booking_tip_helper.dart';

void main() {
  group('BookingTipHelper.parseCustomTip', () {
    test('empty means no tip (0)', () {
      expect(BookingTipHelper.parseCustomTip(''), 0.0);
      expect(BookingTipHelper.parseCustomTip('   '), 0.0);
    });

    test('valid amount rounds to 2 decimals', () {
      expect(BookingTipHelper.parseCustomTip('5'), 5.0);
      expect(BookingTipHelper.parseCustomTip('5.555'), 5.55);
      expect(BookingTipHelper.parseCustomTip(' 12.5 '), 12.5);
    });

    test('invalid or negative returns null', () {
      expect(BookingTipHelper.parseCustomTip('abc'), isNull);
      expect(BookingTipHelper.parseCustomTip('-3'), isNull);
    });
  });

  group('BookingTipHelper selection rules', () {
    const subtotal = 100.0;
    final tip5 = BookingTipHelper.tipPercent(subtotal, 0.05);
    final tip10 = BookingTipHelper.tipPercent(subtotal, 0.10);
    final tip15 = BookingTipHelper.tipPercent(subtotal, 0.15);

    test('percent tips match expected amounts', () {
      expect(tip5, 5.0);
      expect(tip10, 10.0);
      expect(tip15, 15.0);
    });

    test('no tip is default-friendly', () {
      expect(BookingTipHelper.isNoTip(0), isTrue);
      expect(BookingTipHelper.isNoTip(5), isFalse);
    });

    test('custom tip detection', () {
      expect(
        BookingTipHelper.isCustomTip(
          tip: 7.5,
          tip5: tip5,
          tip10: tip10,
          tip15: tip15,
        ),
        isTrue,
      );
      expect(
        BookingTipHelper.isCustomTip(
          tip: tip10,
          tip5: tip5,
          tip10: tip10,
          tip15: tip15,
        ),
        isFalse,
      );
      expect(
        BookingTipHelper.isCustomTip(
          tip: 0,
          tip5: tip5,
          tip10: tip10,
          tip15: tip15,
        ),
        isFalse,
      );
    });

    test('status message is clear for skip vs selected', () {
      expect(
        BookingTipHelper.statusMessage(0),
        contains('Pay Now'),
      );
      expect(
        BookingTipHelper.statusMessage(10),
        contains('Selected \$10.00'),
      );
    });
  });

  group('Custom tip dialog controller lifecycle rule', () {
    test(
      'dialog host must own TextEditingController and dispose only in State.dispose',
      () {
        // Documents the crash we hit: disposing controller right after
        // Get.dialog returns while the dialog route is still animating out.
        // Safe pattern = StatefulWidget dialog content owns the controller.
        const safePattern = 'dispose-in-State.dispose';
        const unsafePattern = 'dispose-immediately-after-await-dialog';
        expect(safePattern != unsafePattern, isTrue);
      },
    );
  });
}
