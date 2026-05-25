// lib/features/common/walletScreen/data/withdraw_response_model.dart

class WithdrawResponseModel {
  final int code;
  final String message;
  final String? onboardingUrl;

  WithdrawResponseModel({
    this.code = 0,
    this.message = '',
    this.onboardingUrl,
  });

  bool get needsStripeSetup =>
      onboardingUrl != null && onboardingUrl!.trim().isNotEmpty;

  factory WithdrawResponseModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['data']?['attributes'] as Map<String, dynamic>?;
    return WithdrawResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      onboardingUrl: attributes?['onboardingUrl'] as String?,
    );
  }
}
