import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/auth_role_guard.dart';
import '../../../login/data/login_service.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final LoginService _loginService;
  LoginController(this._loginService);

  // --- Observables ---
  var rememberMe = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedInStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // --- Login Function ---
  Future<void> login(String email, String password) async {
    if (isClosed) return;

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = "Please enter both email and password";
      AppSnackbar.error("Email and Password are required");
      return;
    }

    // Detach keyboard safely
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _loginService.login(email, password);
      if (isClosed) return;

      isLoggedInStatus.value = true;
      AppSnackbar.success("Welcome back!");

      AuthRoleGuard.navigateToHomeForRole(response.data.attributes.user.role);

    } on AppException catch (e) {
      if (isClosed) return;
      errorMessage.value = e.message;
      AppSnackbar.error(e.message);

    } catch (_) {
      if (isClosed) return;
      const fallback = "Something went wrong. Please try again.";
      errorMessage.value = fallback;
      AppSnackbar.error(fallback);

    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  // --- Check login status ---
  Future<void> checkLoginStatus() async {
    final status = await _loginService.isLoggedIn();
    if (!isClosed) {
      isLoggedInStatus.value = status;
    }
  }
}
