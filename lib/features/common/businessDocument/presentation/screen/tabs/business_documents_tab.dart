import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../controller/business_document_controller.dart';

class BusinessDocumentsTab extends StatefulWidget {
  const BusinessDocumentsTab({super.key});

  @override
  State<BusinessDocumentsTab> createState() =>
      _BusinessDocumentsTabState();
}

class _BusinessDocumentsTabState extends State<BusinessDocumentsTab> {

  final docController = Get.find<BusinessDocumentController>();

  String selectedDocType = "Government Issued ID";

  final List<String> docCategories = [
    "Government Issued ID",
    "Business Registration Proof",
    "Proof of Business Address",
    "Supporting Documents"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 1️⃣ Dropdown
          _buildFullDropdown(docCategories),

          SizedBox(height: 20.h),

          /// 2️⃣ Upload Box
          GestureDetector(
            onTap: _showPickerOptions,
            child: _buildUploadBox(),
          ),

          SizedBox(height: 25.h),

          /// 3️⃣ Submit Button
          Obx(() => CustomButton(
            onTap: docController.isLoading.value
                ? null
                : () => docController.submitVerification(),
            text: docController.isLoading.value
                ? "Uploading..."
                : "Submit All Documents",
            color: const Color(0XFF627E4C),
            height: 48.h,
            loading: docController.isLoading.value,
          )),

          SizedBox(height: 30.h),
          const Divider(),

          CustomText(
            text: "Document Status",
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            top: 10.h,
            bottom: 20.h,
          ),

          /// 4️⃣ Status Sections
          Obx(() {
            final stored = docController.storedDocuments.value;

            return Column(
              children: [
                _buildDocumentCategorySection(
                  "Government Issued ID",
                  docController.governmentIdPaths,
                  stored?.governmentId ?? [],
                ),
                _buildDocumentCategorySection(
                  "Business Registration Proof",
                  docController.registrationPaths,
                  stored?.businessRegistration ?? [],
                ),
                _buildDocumentCategorySection(
                  "Proof of Business Address",
                  docController.addressPaths,
                  stored?.proofOfBusinessAddress ?? [],
                ),
                _buildDocumentCategorySection(
                  "Supporting Documents",
                  docController.supportingPaths,
                  stored?.supportingDocuments ?? [],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =========================================================
  // CATEGORY SECTION
  // =========================================================

  Widget _buildDocumentCategorySection(
      String title,
      RxList<String> localPaths,
      List<String> serverUrls,
      ) {

    if (localPaths.isEmpty && serverUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CustomText(
          text: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0XFF627E4C),
          bottom: 10.h,
        ),

        /// Local Files (Not Uploaded Yet)
        ...localPaths.asMap().entries.map((entry) =>
            _buildDocumentTile(
              entry.value.split('/').last,
              "Pending Upload",
              isServer: false,
              onDelete: () => localPaths.removeAt(entry.key),
            )
        ),

        /// Server Files (Verified)
        ...serverUrls.map((url) =>
            _buildDocumentTile(
              url.split('/').last.split('?').first,
              "Verified & Stored",
              isServer: true,
            )
        ),

        SizedBox(height: 15.h),
      ],
    );
  }

  // =========================================================
  // DOCUMENT TILE
  // =========================================================

  Widget _buildDocumentTile(
      String title,
      String subtitle, {
        bool isServer = false,
        VoidCallback? onDelete,
      }) {

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isServer
            ? const Color(0XFFCADA9F).withValues(alpha:0.1)
            : AppColors.divider.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isServer
              ? const Color(0XFF627E4C)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [

          Icon(
            isServer ? Icons.cloud_done : Icons.picture_as_pdf,
            color: const Color(0XFF1D3826),
          ),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                CustomText(
                  text: subtitle,
                  fontSize: 10.sp,
                  color: Colors.black54,
                  top: 2.h,
                ),
              ],
            ),
          ),

          if (!isServer)
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.cancel, color: Colors.redAccent),
            ),

          if (isServer)
            const Icon(Icons.check_circle,
                color: Color(0XFF627E4C), size: 18),
        ],
      ),
    );
  }

  // =========================================================
  // PICKER
  // =========================================================

  void _showPickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomText(
              text: "Select Source for $selectedDocType",
              fontWeight: FontWeight.bold,
              bottom: 15.h,
            ),

            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: Color(0XFF627E4C)),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                docController.pickDocument(
                    _getTargetList(),
                    fromCamera: true);
              },
            ),

            ListTile(
              leading: const Icon(Icons.file_present,
                  color: Color(0XFF627E4C)),
              title: const Text("Gallery / Files"),
              onTap: () {
                Get.back();
                docController.pickDocument(
                    _getTargetList(),
                    fromCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  RxList<String> _getTargetList() {
    if (selectedDocType == "Government Issued ID") {
      return docController.governmentIdPaths;
    }
    if (selectedDocType == "Business Registration Proof") {
      return docController.registrationPaths;
    }
    if (selectedDocType == "Proof of Business Address") {
      return docController.addressPaths;
    }
    return docController.supportingPaths;
  }

  // =========================================================
  // UI HELPERS
  // =========================================================

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: AppColors.geryColor,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined,
              size: 40.sp,
              color: AppColors.geryColor),
          CustomText(
            text: "Tap to choose a file",
            top: 10.h,
            color: AppColors.geryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFullDropdown(List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF1D3826),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDocType,
          dropdownColor: const Color(0XFF1D3826),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Colors.white),
          items: items.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(
                text: value,
                color: Colors.white,
                fontSize: 13.sp,
              ),
            );
          }).toList(),
          onChanged: (val) =>
              setState(() => selectedDocType = val!),
        ),
      ),
    );
  }
}

