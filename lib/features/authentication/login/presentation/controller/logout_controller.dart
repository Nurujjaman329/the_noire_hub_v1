import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/controllers/profile_controller.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/login_service.dart';

class LogoutController extends GetxController {
  final LoginService _loginService;

  LogoutController(this._loginService);

  Future<void> logout() async {
    try {
      await _loginService.logout();

      // Clear stale profile data from memory
      Get.find<ProfileController>().refreshProfile();

      // Navigate to login screen
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      AppSnackbar.error("Logout failed");
    }
  }
}
