import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../login/data/login_service.dart';

class LoginController extends GetxController {
  final LoginService _loginService;
  
  LoginController(this._loginService);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedInStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final response = await _loginService.login(email, password);
      
      if (response.code == 200 || response.code == 201) {
        isLoggedInStatus.value = true;
        Get.offAllNamed(RouteConstants.customerMainContainer);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _loginService.logout();
      isLoggedInStatus.value = false;
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> checkLoginStatus() async {
    isLoggedInStatus.value = await _loginService.isLoggedIn();
  }

  String? getStoredAccessToken() {
    return LocalStorage.getAccessToken();
  }

  String? getStoredRefreshToken() {
    return LocalStorage.getRefreshToken();
  }

  Map<String, dynamic>? getStoredUserData() {
    return LocalStorage.getUserData();
  }
}