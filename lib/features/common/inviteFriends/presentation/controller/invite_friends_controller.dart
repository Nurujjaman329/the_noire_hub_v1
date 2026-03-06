

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import '../../data/invite_friends_response_model.dart';
import '../../data/invite_friends_service.dart';

class InviteController extends GetxController {
  final InviteFriendsService _inviteService;
  InviteController(this._inviteService);

  var isLoading = false.obs;
  // Rxn allows the value to be null initially
  final inviteData = Rxn<AppLinkData>();

  @override
  void onInit() {
    super.onInit();
    // Pre-fetch the link so it's ready when the user clicks share
    getInviteLink();
  }


  Future<void> copyToClipboard() async {
    if (inviteData.value != null && inviteData.value!.appUrl.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: inviteData.value!.appUrl));
      Get.snackbar(
        "Copied",
        "Link copied to clipboard!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0XFF9BB575),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar("Error", "No link available to copy.");
    }
  }

  Future<void> getInviteLink() async {
    try {
      isLoading.value = true;
      final response = await _inviteService.fetchInviteLink();

      if (response.success && response.data != null) {
        inviteData.value = response.data;
      }
    } catch (e) {
      debugPrint("Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Triggers the native OS share sheet
  Future<void> shareInvite() async {
    if (inviteData.value != null) {
      await Share.share(inviteData.value!.shareMessage);
    } else {
      await getInviteLink();
      if (inviteData.value != null) {
        await Share.share(inviteData.value!.shareMessage);
      }
    }
  }
}