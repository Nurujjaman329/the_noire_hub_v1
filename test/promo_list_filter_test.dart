import 'package:flutter_test/flutter_test.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/customer_deals_promos_response_model.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/data/promo_list_filter.dart';

CustomerPromoCodeModel _promo({
  String code = 'SAVE10',
  String applicableFor = 'product',
  bool isActive = true,
  String expiryDate = '2026-12-31',
  int maxUsageCount = 100,
  int currentUsageCount = 0,
  String? createdById,
  List<String> usedBy = const [],
}) {
  return CustomerPromoCodeModel(
    createdBy: createdById == null
        ? null
        : CreatedByModel(
            fullName: '',
            businessName: '',
            phoneNumber: '',
            id: createdById,
          ),
    usedBy: usedBy,
    code: code,
    title: code,
    discountPercentage: 10,
    description: '',
    expiryDate: expiryDate,
    applicableFor: applicableFor,
    minPurchaseAmount: 0,
    maxUsageCount: maxUsageCount,
    currentUsageCount: currentUsageCount,
    isActive: isActive,
    createdAt: '',
    id: code,
  );
}

void main() {
  final now = DateTime(2026, 9, 15, 12);

  group('PromoListFilter — hide unusable codes', () {
    test('keeps active, not expired, under usage limit', () {
      final list = [
        _promo(code: 'OK1'),
        _promo(code: 'OK2', applicableFor: 'both'),
      ];

      final usable = PromoListFilter.usableOnly(
        list,
        applicableFor: 'product',
        now: now,
      );

      expect(usable.map((e) => e.code), ['OK1', 'OK2']);
    });

    test('hides inactive', () {
      final list = [_promo(code: 'DEAD', isActive: false)];
      expect(
        PromoListFilter.usableOnly(list, now: now),
        isEmpty,
      );
    });

    test('hides expired', () {
      final list = [_promo(code: 'OLD', expiryDate: '2026-09-01')];
      expect(
        PromoListFilter.usableOnly(list, now: now),
        isEmpty,
      );
    });

    test('hides when usage limit reached', () {
      final list = [
        _promo(
          code: 'LIMIT',
          maxUsageCount: 100,
          currentUsageCount: 100,
        ),
        _promo(
          code: 'OVER',
          maxUsageCount: 50,
          currentUsageCount: 51,
        ),
        _promo(
          code: 'OK',
          maxUsageCount: 100,
          currentUsageCount: 99,
        ),
      ];

      final usable = PromoListFilter.usableOnly(list, now: now);
      expect(usable.map((e) => e.code), ['OK']);
    });

    test('unlimited when maxUsageCount is 0', () {
      final list = [
        _promo(
          code: 'UNLIMITED',
          maxUsageCount: 0,
          currentUsageCount: 999,
        ),
      ];
      expect(
        PromoListFilter.usableOnly(list, now: now).single.code,
        'UNLIMITED',
      );
    });

    test('product list drops service-only codes', () {
      final list = [
        _promo(code: 'P1', applicableFor: 'product'),
        _promo(code: 'S1', applicableFor: 'service'),
        _promo(code: 'B1', applicableFor: 'both'),
      ];

      final usable = PromoListFilter.usableOnly(
        list,
        applicableFor: 'product',
        now: now,
      );
      expect(usable.map((e) => e.code), ['P1', 'B1']);
    });

    test('checkout drops other vendor codes', () {
      final list = [
        _promo(code: 'MINE', createdById: 'vendor_a'),
        _promo(code: 'OTHER', createdById: 'vendor_b'),
        _promo(code: 'NO_SELLER'),
      ];

      final usable = PromoListFilter.usableOnly(
        list,
        createdById: 'vendor_a',
        now: now,
      );
      expect(usable.map((e) => e.code), ['MINE']);
    });

    test('hides codes already used by this user', () {
      final list = [
        _promo(code: 'USED', usedBy: const ['user_1', 'user_2']),
        _promo(code: 'FREE', usedBy: const ['user_2']),
      ];

      final usable = PromoListFilter.usableOnly(
        list,
        currentUserId: 'user_1',
        now: now,
      );
      expect(usable.map((e) => e.code), ['FREE']);
    });

    test('permanent validate failures hide from list', () {
      expect(
        PromoListFilter.isPermanentlyUnusableFailure(
          message: "This promo code is not valid for this vendor's products",
        ),
        isTrue,
      );
      expect(
        PromoListFilter.isPermanentlyUnusableFailure(reason: 'WRONG_SELLER'),
        isTrue,
      );
      expect(
        PromoListFilter.isPermanentlyUnusableFailure(
          message: 'Minimum purchase amount not met',
          reason: 'MIN_PURCHASE',
        ),
        isFalse,
      );
    });
  });
}
