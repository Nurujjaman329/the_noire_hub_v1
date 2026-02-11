
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'business_document_formData_body.dart';
import 'get_business_documents_model_response_model.dart';

class BusinessDocumentService {
  final ApiClient _apiClient;
  BusinessDocumentService(this._apiClient);

  // GET: Fetch existing documents
  Future<GetBusinessDocumentsModelResponseModel> getMyDocuments() async {
    try {
      final response = await _apiClient.get(ApiConstants.getBusinessDocuments);
      return GetBusinessDocumentsModelResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // POST: Upload new documents
  Future<Response> uploadDocuments(VerificationBody body) async {
    try {
      final formData = await body.toFormData();
      return await _apiClient.postFormData(
        ApiConstants.addBusinessDocuments.trim(),
        data: formData,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}