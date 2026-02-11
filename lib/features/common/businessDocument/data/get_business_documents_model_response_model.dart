class GetBusinessDocumentsModelResponseModel {
  final int code;
  final String message;
  final BusinessDocument data;

  GetBusinessDocumentsModelResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetBusinessDocumentsModelResponseModel.fromJson(Map<String, dynamic> json) {
    return GetBusinessDocumentsModelResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: BusinessDocument.fromJson(
        json['data']?['attributes'] ?? {},
      ),
    );
  }
}
class BusinessDocument {
  final String id;
  final String user;
  final List<String> governmentId;
  final List<String> businessRegistration;
  final List<String> proofOfBusinessAddress;
  final List<String> supportingDocuments;
  final String status;
  final DateTime? createdAt;

  BusinessDocument({
    required this.id,
    required this.user,
    required this.governmentId,
    required this.businessRegistration,
    required this.proofOfBusinessAddress,
    required this.supportingDocuments,
    required this.status,
    required this.createdAt,
  });

  factory BusinessDocument.fromJson(Map<String, dynamic> json) {
    return BusinessDocument(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      governmentId: List<String>.from(json['governmentId'] ?? []),
      businessRegistration:
      List<String>.from(json['businessRegistration'] ?? []),
      proofOfBusinessAddress:
      List<String>.from(json['proofOfBusinessAddress'] ?? []),
      supportingDocuments:
      List<String>.from(json['supportingDocuments'] ?? []),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
