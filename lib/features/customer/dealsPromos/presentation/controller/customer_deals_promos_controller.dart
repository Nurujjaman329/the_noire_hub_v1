import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/customer_deals_promos_response_model.dart';
import '../../data/customer_deals_promos_service.dart';
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
        // Client-side filters: type + hide expired/inactive.
        promoList.value = _filterUsablePromos(results, this.applicableFor);
        debugPrint(
          "✅ Loaded ${promoList.length} promos"
          "${this.applicableFor != null ? ' (filtered: ${this.applicableFor})' : ''}",
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

  List<CustomerPromoCodeModel> _filterUsablePromos(
    List<CustomerPromoCodeModel> list,
    String? applicableFor,
  ) {
    return list.where((p) {
      if (!_isPromoCurrentlyValid(p)) return false;
      if (applicableFor == null || applicableFor.trim().isEmpty) return true;
      final type = p.applicableFor.trim().toLowerCase();
      final wanted = applicableFor.trim().toLowerCase();
      if (type.isEmpty || type == 'both') return true;
      return type == wanted;
    }).toList();
  }

  /// Hide inactive or expired codes from customer lists.
  bool _isPromoCurrentlyValid(CustomerPromoCodeModel promo) {
    if (!promo.isActive) return false;
    if (promo.expiryDate.trim().isEmpty) return true;
    try {
      final expiry = DateTime.parse(promo.expiryDate).toLocal();
      final endOfExpiryDay = DateTime(expiry.year, expiry.month, expiry.day, 23, 59, 59);
      return !DateTime.now().isAfter(endOfExpiryDay);
    } catch (_) {
      // If date is unreadable, keep it and let validate API decide.
      return true;
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
