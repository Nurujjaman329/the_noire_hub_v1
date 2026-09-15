import 'package:get/get.dart';

import '../api/api_exception.dart';
import '../constants/route_constants.dart';

/// Whitelist for roles allowed to use this app.
class AuthRoleGuard {
  AuthRoleGuard._();

  static const _allowedRoles = {'user', 'customer', 'vendor', 'beautician'};

  static String normalize(String role) => role.trim().toLowerCase();

  static bool isAllowed(String role) => _allowedRoles.contains(normalize(role));

  static String displayName(String role) {
    switch (normalize(role)) {
      case 'user':
      case 'customer':
        return 'Customer';
      case 'vendor':
        return 'Vendor';
      case 'beautician':
        return 'Beautician';
      default:
        if (role.trim().isEmpty) return 'Unknown';
        final value = role.trim();
        return value[0].toUpperCase() + value.substring(1);
    }
  }

  static String blockedMessage(String role) {
    final name = displayName(role);
    return 'Your account type ($name) is not supported in this app. '
        'Only Customer, Vendor, and Beautician accounts can sign in. '
        'Please contact support if you need help.';
  }

  /// Throws [UnsupportedRoleException] when [role] is outside the whitelist.
  static void ensureAllowed(String role) {
    if (!isAllowed(role)) {
      throw UnsupportedRoleException(role);
    }
  }

  static void navigateToHomeForRole(String role) {
    ensureAllowed(role);
    final normalized = normalize(role);

    if (normalized == 'vendor' || normalized == 'beautician') {
      Get.offAllNamed(
        RouteConstants.vendorMainContainer,
        arguments: {'role': normalized},
      );
    } else {
      Get.offAllNamed(RouteConstants.customerMainContainer);
    }
  }
}

class UnsupportedRoleException extends AppException {
  final String role;

  UnsupportedRoleException(this.role) : super(AuthRoleGuard.blockedMessage(role));
}
