import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/customer_deals_promos_response_model.dart';
import '../../data/customer_deals_promos_service.dart';
import '../../data/promo_list_filter.dart';
import '../../data/promo_validate_response_model.dart';

class CustomerDealsPromosController extends GetxController {
  final CustomerDealsPromosService _service;
  CustomerDealsPromosController(this._service);

  var promoList = <CustomerPromoCodeModel>[].obs;
  var isListLoading = false.obs;
  var isValidating = false.obs;

  String? createdBy;
  String? applicableFor;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchPromos({
    String? createdBy,
    String? applicableFor,
    bool clearFilters = false,
  }) async {
    try {
      isListLoading.value = true;
      if (clearFilters) {
        this.createdBy = null;
        this.applicableFor = null;
      } else {
        if (createdBy != null) this.createdBy = createdBy;
        if (applicableFor != null) this.applicableFor = applicableFor;
      }

      final response = await _service.fetchPromos(
        createdBy: this.createdBy,
      );

      if (response.data?.attributes != null) {
        final results = response.data!.attributes!.results;
        // Hide expired / inactive / usage-limit / wrong seller / already used.
        var usable = PromoListFilter.usableOnly(
          results,
          applicableFor: this.applicableFor,
          createdById: this.createdBy,
          currentUserId: CacheService.userId,
        );

        // List API can still return codes that validate rejects (e.g. code
        // collision / wrong seller). Drop those before showing checkout list.
        if (this.createdBy != null && this.createdBy!.trim().isNotEmpty) {
          usable = await _dropCodesInvalidForSeller(usable);
        }

        promoList.value = usable;
        debugPrint(
          "✅ Loaded ${promoList.length} usable promos"
          "${this.applicableFor != null ? ' (filtered: ${this.applicableFor})' : ''}"
          "${this.createdBy != null ? ' (seller: ${this.createdBy})' : ''}"
          " from ${results.length} raw"
          " → [${promoList.map((e) => e.code).join(', ')}]",
        );
      } else {
        promoList.clear();
      }
    } catch (e) {
      promoList.clear();
      debugPrint("❌ PromoCodeController fetchPromos error: $e");
    } finally {
      isListLoading.value = false;
    }
  }

  void loadByCreator(String id, {String? applicableFor}) {
    createdBy = id;
    this.applicableFor = applicableFor;
    fetchPromos(createdBy: id, applicableFor: applicableFor);
  }

  /// Validates without burning usage. Returns null on failure (shows snackbar).
  Future<AppliedPromoResult?> validatePromoCode({
    required String code,
    required double subtotal,
    String? vendorId,
    String? beauticianId,
    bool showSuccessSnack = true,
  }) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      AppSnackbar.error('Please enter a promo code', title: 'Promo');
      return null;
    }

    isValidating.value = true;
    try {
      final response = await _service.validatePromo(
        code: trimmed,
        subtotal: subtotal,
        vendorId: vendorId,
        beauticianId: beauticianId,
      );

      final attrs = response.attributes;
      if (attrs == null || !attrs.valid) {
        final msg = response.message.isNotEmpty
            ? response.message
            : _friendlyReason(attrs?.reason);
        _hideIfPermanentlyUnusable(trimmed, message: msg, reason: attrs?.reason);
        AppSnackbar.error(msg, title: 'Promo not valid');
        return null;
      }

      final result = AppliedPromoResult(
        code: attrs.code.isNotEmpty ? attrs.code : trimmed,
        discountPercentage: attrs.discountPercentage,
        discountAmount: attrs.discountAmount > 0
            ? attrs.discountAmount
            : _fallbackDiscount(subtotal, attrs.discountPercentage),
        finalSubtotal: attrs.finalSubtotal > 0
            ? attrs.finalSubtotal
            : (subtotal -
                (attrs.discountAmount > 0
                    ? attrs.discountAmount
                    : _fallbackDiscount(subtotal, attrs.discountPercentage))),
      );

      if (showSuccessSnack) {
        AppSnackbar.success(
          '${result.code} applied — you save \$${result.discountAmount.toStringAsFixed(2)}',
          title: 'Promo applied',
        );
      }
      return result;
    } on AppException catch (e) {
      _hideIfPermanentlyUnusable(trimmed, message: e.message);
      AppSnackbar.error(e.message, title: 'Promo not valid');
      return null;
    } catch (e) {
      AppSnackbar.error(
        'Could not check this promo. Please try again.',
        title: 'Promo',
      );
      return null;
    } finally {
      isValidating.value = false;
    }
  }

  /// Quiet validate pass so checkout/booking lists only show codes that work
  /// for this seller. Skips MIN_PURCHASE failures (cart may still qualify).
  Future<List<CustomerPromoCodeModel>> _dropCodesInvalidForSeller(
    List<CustomerPromoCodeModel> list,
  ) async {
    final sellerId = createdBy?.trim() ?? '';
    if (sellerId.isEmpty || list.isEmpty) return list;

    final forService =
        (applicableFor ?? '').trim().toLowerCase() == 'service';

    final checked = await Future.wait(list.map((promo) async {
      try {
        final probeSubtotal =
            promo.minPurchaseAmount > 0 ? promo.minPurchaseAmount * 10.0 : 99999.0;
        final response = await _service.validatePromo(
          code: promo.code,
          subtotal: probeSubtotal < 1 ? 99999.0 : probeSubtotal,
          vendorId: forService ? null : sellerId,
          beauticianId: forService ? sellerId : null,
        );
        final attrs = response.attributes;
        if (attrs != null && attrs.valid) return promo;
        final msg = response.message;
        final reason = attrs?.reason;
        if (PromoListFilter.isPermanentlyUnusableFailure(
          message: msg,
          reason: reason,
        )) {
          debugPrint('🚫 Dropping promo ${promo.code} from list: $msg');
          return null;
        }
        // e.g. MIN_PURCHASE — still show; apply-time will check cart total.
        return promo;
      } on AppException catch (e) {
        if (PromoListFilter.isPermanentlyUnusableFailure(message: e.message)) {
          debugPrint('🚫 Dropping promo ${promo.code} from list: ${e.message}');
          return null;
        }
        return promo;
      } catch (_) {
        // Network/parse — keep and let user try.
        return promo;
      }
    }));

    return checked.whereType<CustomerPromoCodeModel>().toList();
  }

  void _hideIfPermanentlyUnusable(
    String code, {
    String? message,
    String? reason,
  }) {
    if (!PromoListFilter.isPermanentlyUnusableFailure(
      message: message,
      reason: reason,
    )) {
      return;
    }
    final before = promoList.length;
    promoList.removeWhere(
      (p) => p.code.toUpperCase() == code.trim().toUpperCase(),
    );
    if (promoList.length != before) {
      debugPrint('🚫 Removed $code from promo list after validate failure');
    }
  }

  double _fallbackDiscount(double subtotal, double percentage) {
    if (percentage <= 0) return 0;
    return double.parse(((subtotal * percentage) / 100).toStringAsFixed(2));
  }

  String _friendlyReason(String? reason) {
    switch (reason) {
      case 'NOT_FOUND':
        return 'Invalid promo code';
      case 'EXPIRED':
        return 'This promo code has expired';
      case 'INACTIVE':
        return 'This promo code is not active';
      case 'WRONG_SELLER':
        return 'This promo is not valid for this store or beautician';
      case 'WRONG_TYPE':
        return 'This promo cannot be used for this purchase type';
      case 'MIN_PURCHASE':
        return 'Minimum purchase amount not met';
      case 'USAGE_LIMIT':
        return 'Promo usage limit has been reached';
      case 'ALREADY_USED':
        return 'You have already used this promo';
      case 'REQUIRED_CONTEXT':
        return 'Missing store or beautician context';
      default:
        return 'This promo code is not valid';
    }
  }

  void removePromo(String id) {
    promoList.removeWhere((promo) => promo.id == id);
  }
}
