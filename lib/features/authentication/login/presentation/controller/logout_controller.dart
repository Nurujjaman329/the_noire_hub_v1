import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/login_service.dart';

class LogoutController extends GetxController {
  final LoginService _loginService;

  LogoutController(this._loginService);

  Future<void> logout() async {
    try {
      await _loginService.logout();

      // Navigate to login screen
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      AppSnackbar.error("Logout failed");
    }
  }
}
