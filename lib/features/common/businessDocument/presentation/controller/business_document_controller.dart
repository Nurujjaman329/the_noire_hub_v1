import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/business_document_formData_body.dart';
import '../../data/business_document_service.dart';
import '../../data/get_business_documents_model_response_model.dart';
import 'package:flutter/material.dart';

class BusinessDocumentController extends GetxController {
  final BusinessDocumentService _service;
  BusinessDocumentController(this._service);

  final ImagePicker _imagePicker = ImagePicker();

  // Observables
  var isLoading = false.obs;
  var isFetching = false.obs;
  var storedDocuments = Rxn<BusinessDocument>();

  // Observable path lists for new uploads
  var governmentIdPaths = <String>[].obs;
  var registrationPaths = <String>[].obs;
  var addressPaths = <String>[].obs;
  var supportingPaths = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyDocuments();
  }

  /// Fetch existing documents from server
  Future<void> fetchMyDocuments() async {
    isFetching.value = true;
    try {
      final response = await _service.getMyDocuments();
      storedDocuments.value = response.data;
    } on AppException catch (e) {
      debugPrint("Info: ${e.message}");
    } finally {
      isFetching.value = false;
    }
  }

  /// Logic to pick documents (PDF/Image)
  Future<void> pickDocument(RxList<String> targetList, {required bool fromCamera}) async {
    try {
      if (fromCamera) {
        final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);
        if (photo != null) _processAndAddFile(photo.path, targetList);
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
          allowMultiple: true,
        );
        if (result != null) {
          for (var path in result.paths) {
            if (path != null) _processAndAddFile(path, targetList);
          }
        }
      }
    } catch (e) {
      AppSnackbar.error("Error picking file: $e");
    }
  }

  void _processAndAddFile(String path, RxList<String> targetList) {
    final file = File(path);
    if ((file.lengthSync() / (1024 * 1024)) > 2.0) {
      AppSnackbar.error("File is too large. Max 2MB allowed.");
      return;
    }
    if (!targetList.contains(path)) targetList.add(path);
  }

  void removeFile(RxList<String> targetList, int index) => targetList.removeAt(index);

  Future<void> submitVerification() async {
    if (governmentIdPaths.isEmpty && registrationPaths.isEmpty) {
      AppSnackbar.error("Please provide at least ID and Registration docs");
      return;
    }

    isLoading.value = true;
    try {
      final body = VerificationBody(
        governmentId: governmentIdPaths,
        businessRegistration: registrationPaths,
        proofOfBusinessAddress: addressPaths,
        supportingDocuments: supportingPaths,
      );

      await _service.uploadDocuments(body);
      AppSnackbar.success("Documents submitted successfully");
      fetchMyDocuments(); // Refresh the list after upload
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }
}