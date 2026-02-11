import 'package:dio/dio.dart';

class VerificationBody {
  final List<String> governmentId;
  final List<String> businessRegistration;
  final List<String> proofOfBusinessAddress;
  final List<String> supportingDocuments;

  VerificationBody({
    this.governmentId = const [],
    this.businessRegistration = const [],
    this.proofOfBusinessAddress = const [],
    this.supportingDocuments = const [],
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    for (final path in governmentId) {
      formData.files.add(
        MapEntry(
          'governmentId',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    for (final path in businessRegistration) {
      formData.files.add(
        MapEntry(
          'businessRegistration',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    for (final path in proofOfBusinessAddress) {
      formData.files.add(
        MapEntry(
          'proofOfBusinessAddress',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    for (final path in supportingDocuments) {
      formData.files.add(
        MapEntry(
          'supportingDocuments',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    return formData;
  }
}
