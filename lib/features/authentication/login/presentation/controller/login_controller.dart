import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../login/data/login_service.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final LoginService _loginService;
  LoginController(this._loginService);

  // --- Controllers ---
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool _controllersNeedRefresh = false;

  // Track if the controllers were recently disposed
  bool _emailControllerWasDisposed = false;
  bool _passwordControllerWasDisposed = false;

  TextEditingController get emailController {
    if (_emailController == null || _controllersNeedRefresh || _emailControllerWasDisposed) {
      _createEmailController();
      _emailControllerWasDisposed = false;
      _controllersNeedRefresh = false;
    }
    return _emailController!;
  }

  void _createEmailController() {
    if (_emailController != null) {
      try {
        _emailController!.dispose();
      } catch (e) {
        debugPrint('Email controller disposal error: $e');
      }
    }
    _emailController = TextEditingController();
  }

  TextEditingController get passwordController {
    if (_passwordController == null || _controllersNeedRefresh || _passwordControllerWasDisposed) {
      _createPasswordController();
      _passwordControllerWasDisposed = false;
      _controllersNeedRefresh = false;
    }
    return _passwordController!;
  }

  void _createPasswordController() {
    if (_passwordController != null) {
      try {
        _passwordController!.dispose();
      } catch (e) {
        debugPrint('Password controller disposal error: $e');
      }
    }
    _passwordController = TextEditingController();
  }

  // Method to handle controller disposal error and recreate controllers
  void handleControllerDisposalError() {
    _emailControllerWasDisposed = true;
    _passwordControllerWasDisposed = true;
  }

  // Method to mark controllers for refresh when the screen is shown again
  void markControllersForRefresh() {
    _controllersNeedRefresh = true;
  }

  // --- Observables ---
  var rememberMe = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedInStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 LoginController Initialized');
    // Mark controllers for refresh to ensure fresh ones on initialization
    markControllersForRefresh();
    checkLoginStatus();
  }


  @override
  void onClose() {
    debugPrint('🧹 LoginController disposing...');
    // Dispose controllers - wrap in try/catch to handle cases where they're already disposed
    try {
      _emailController?.dispose();
    } catch (e) {
      // Check if it's a disposed controller error
      if (e.toString().contains('TextEditingController was used after being disposed')) {
        // Mark controllers as disposed for recreation
        _emailControllerWasDisposed = true;
      } else {
        debugPrint('Email controller dispose error: $e');
      }
    }
    try {
      _passwordController?.dispose();
    } catch (e) {
      // Check if it's a disposed controller error
      if (e.toString().contains('TextEditingController was used after being disposed')) {
        // Mark controllers as disposed for recreation
        _passwordControllerWasDisposed = true;
      } else {
        debugPrint('Password controller dispose error: $e');
      }
    }
    super.onClose();
  }

  // --- Login Function ---
  Future<void> login() async {
    if (isClosed) return;

    // Get values from controllers - we'll handle errors gracefully
    String email, password;
    try {
      email = emailController.text.trim();
      password = passwordController.text.trim();
    } catch (e) {
      // Check if it's a disposed controller error
      if (e.toString().contains('TextEditingController was used after being disposed')) {
        // Handle disposed controller error
        handleControllerDisposalError();
        // Retry with fresh controllers
        try {
          email = emailController.text.trim();
          password = passwordController.text.trim();
        } catch (retryError) {
          AppSnackbar.error("Form is not ready. Please try again.");
          return;
        }
      } else {
        AppSnackbar.error("Form is not ready. Please try again.");
        return;
      }
    }

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

      final userRole = response.data.attributes.user.role.toLowerCase();

      // --- Delay frame to avoid disposed controller error ---
      await Future.delayed(const Duration(milliseconds: 50));

      // --- Navigate safely ---
      if (userRole.contains('vendor') || userRole.contains('beautician')) {
        Get.offAllNamed(
          RouteConstants.vendorMainContainer,
          arguments: {'role': userRole},
        );
      } else {
        Get.offAllNamed(RouteConstants.customerMainContainer);
      }

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
