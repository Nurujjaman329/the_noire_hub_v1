import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../data/delete_account_service.dart';

class DeleteAccountController extends GetxController {
  final DeleteAccountService _deleteAccountService;
  DeleteAccountController(this._deleteAccountService);

  var isLoading = false.obs;
  var passwordObscure = true.obs;
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    passwordObscure.value = !passwordObscure.value;
  }

  Future<void> deleteAccount() async {
    if (!formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    try {
      await _deleteAccountService.deleteAccount(passwordController.text.trim());
      if (isClosed) return;

      AppSnackbar.success("Account deleted successfully");
      Get.offAllNamed(RouteConstants.login);

    } on AppException catch (e) {
      if (isClosed) return;
      AppSnackbar.error(e.message);

    } catch (_) {
      if (isClosed) return;
      AppSnackbar.error("Failed to delete account. Please try again.");

    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
