import 'package:the_noire_hub_v1/features/vendor/vendorStoreScreen/data/vendor_products_response_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class VendorProductList {
  final ApiClient _apiClient;
  VendorProductList(this._apiClient);

  Future<VendorProductsResponseModel> getVendorProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vendorProductList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return VendorProductsResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}