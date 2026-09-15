import 'customer_deals_promos_response_model.dart';

/// Client-side filters for customer promo lists (checkout / booking / deals).
class PromoListFilter {
  PromoListFilter._();

  static List<CustomerPromoCodeModel> usableOnly(
    List<CustomerPromoCodeModel> list, {
    String? applicableFor,
    String? createdById,
    String? currentUserId,
    DateTime? now,
  }) {
    return list.where((p) {
      if (!isCurrentlyUsable(p, now: now, currentUserId: currentUserId)) {
        return false;
      }
      if (!matchesApplicableFor(p, applicableFor)) return false;
      if (!matchesCreatedBy(p, createdById)) return false;
      return true;
    }).toList();
  }

  static bool matchesApplicableFor(
    CustomerPromoCodeModel promo,
    String? applicableFor,
  ) {
    if (applicableFor == null || applicableFor.trim().isEmpty) return true;
    final type = promo.applicableFor.trim().toLowerCase();
    final wanted = applicableFor.trim().toLowerCase();
    if (type.isEmpty || type == 'both') return true;
    return type == wanted;
  }

  /// Checkout/booking: only that seller's codes (API `createdBy` can leak others).
  static bool matchesCreatedBy(
    CustomerPromoCodeModel promo,
    String? createdById,
  ) {
    if (createdById == null || createdById.trim().isEmpty) return true;
    final sellerId = promo.createdBy?.id.trim() ?? '';
    if (sellerId.isEmpty) return false;
    return sellerId == createdById.trim();
  }

  /// Hide inactive, expired, usage-limit, or already-used-by-this-user codes.
  static bool isCurrentlyUsable(
    CustomerPromoCodeModel promo, {
    String? currentUserId,
    DateTime? now,
  }) {
    if (!promo.isActive) return false;
    if (_isUsageLimitReached(promo)) return false;
    if (_isExpired(promo, now: now)) return false;
    if (_alreadyUsedByUser(promo, currentUserId)) return false;
    return true;
  }

  /// True when validate failed for a reason that means "never show in this list".
  /// Keeps MIN_PURCHASE (cart total may still qualify).
  static bool isPermanentlyUnusableFailure({
    String? message,
    String? reason,
  }) {
    final r = (reason ?? '').trim().toUpperCase();
    const permanentReasons = {
      'WRONG_SELLER',
      'EXPIRED',
      'INACTIVE',
      'USAGE_LIMIT',
      'ALREADY_USED',
      'WRONG_TYPE',
      'NOT_FOUND',
    };
    if (permanentReasons.contains(r)) return true;

    final m = (message ?? '').toLowerCase();
    if (m.isEmpty) return false;
    if (m.contains('minimum purchase') || m.contains('min purchase')) {
      return false;
    }
    return m.contains('not valid for this vendor') ||
        m.contains('not valid for this store') ||
        m.contains('not valid for this beautician') ||
        m.contains('usage limit') ||
        m.contains('has expired') ||
        m.contains('already used') ||
        m.contains('not active') ||
        m.contains('cannot be used for this purchase');
  }

  static bool _isUsageLimitReached(CustomerPromoCodeModel promo) {
    // maxUsageCount <= 0 means unlimited / not set.
    if (promo.maxUsageCount <= 0) return false;
    return promo.currentUsageCount >= promo.maxUsageCount;
  }

  static bool _alreadyUsedByUser(
    CustomerPromoCodeModel promo,
    String? currentUserId,
  ) {
    final uid = currentUserId?.trim() ?? '';
    if (uid.isEmpty || promo.usedBy.isEmpty) return false;
    return promo.usedBy.any((id) => id.trim() == uid);
  }

  static bool _isExpired(
    CustomerPromoCodeModel promo, {
    DateTime? now,
  }) {
    if (promo.expiryDate.trim().isEmpty) return false;
    try {
      final expiry = DateTime.parse(promo.expiryDate).toLocal();
      final endOfDay =
          DateTime(expiry.year, expiry.month, expiry.day, 23, 59, 59);
      return (now ?? DateTime.now()).isAfter(endOfDay);
    } catch (_) {
      // Unreadable date → keep and let validate API decide.
      return false;
    }
  }
}
