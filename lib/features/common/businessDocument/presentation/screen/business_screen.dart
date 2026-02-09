import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/business_document_controller.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

  final controller = Get.find<BusinessDocumentController>();

  // Local state for the category dropdown
  String selectedDocType = "Government Issued ID";
  final List<String> docCategories = [
    "Government Issued ID",
    "Business Registration Proof",
    "Proof of Business Address",
    "Supporting Documents"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: "",showBackButton: true,),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Business",
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                left: 20.w,
                top: 20.h,
                bottom: 15.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.divider.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: AppColors.transparent,
                  indicator: BoxDecoration(
                    color: Color(0XFFCADA9F),
                    // color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  // labelColor: AppColors.white,
                  labelColor: Color(0XFF000000),
                  unselectedLabelColor: AppColors.geryColor,

                  labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600,color: Color(0x4D000000),),
                  tabs: const [
                    Tab(text: "Info"),
                    Tab(text: "Earnings"),
                    Tab(text: "Documents"),

                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildInfoTab(),
                    _buildEarningsTab(),
                    _buildDocumentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Earnings Tab with fl_chart
  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          CustomButton(
            onTap: () {},
            text: "Withdraw Funds",
            color: Color(0XFF627E4C),
            // color: AppColors.primaryDark,
            height: 50.h,
          ),
          SizedBox(height: 25.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard("Available", "\$255.50"),
              _buildStatCard("Pending", "\$125.50"),
              _buildStatCard("This Month", "\$890.50"),
              _buildStatCard("Total Earned", "\$5125.85"),
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Earnings", fontSize: 16.sp, fontWeight: FontWeight.bold),
              _buildSmallDropdown("Weekly"),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            height: 200.h,
            padding: EdgeInsets.only(top: 20.h, right: 20.w),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                        return CustomText(text: days[val.toInt()], fontSize: 10.sp, color: AppColors.geryColor);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(0, 45), _makeGroupData(1, 60), _makeGroupData(2, 85),
                  _makeGroupData(3, 70), _makeGroupData(4, 55), _makeGroupData(5, 90), _makeGroupData(6, 75),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Documents Tab
// MARK: - Documents Tab
  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Dropdown Selection
          _buildFullDropdown(docCategories),

          SizedBox(height: 20.h),

          // 2. Functional Upload Box
          GestureDetector(
            onTap: () => _showPickerOptions(),
            child: _buildUploadBox(),
          ),

          SizedBox(height: 25.h),

          // 3. Submit Button
          Obx(() => CustomButton(
            onTap: controller.isLoading.value ? null : () => controller.submitVerification(),
            text: controller.isLoading.value ? "Uploading..." : "Submit All Documents",
            color: const Color(0XFF627E4C),
            height: 48.h,
            loading: controller.isLoading.value,
          )),

          SizedBox(height: 30.h),
          const Divider(),
          CustomText(
              text: "Document Status",
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              top: 10.h,
              bottom: 20.h
          ),

          // 4. Grouped List Sections
          Obx(() {
            final stored = controller.storedDocuments.value;

            return Column(
              children: [
                _buildDocumentCategorySection(
                  "Government Issued ID",
                  controller.governmentIdPaths,
                  stored?.governmentId ?? [],
                ),
                _buildDocumentCategorySection(
                  "Business Registration Proof",
                  controller.registrationPaths,
                  stored?.businessRegistration ?? [],
                ),
                _buildDocumentCategorySection(
                  "Proof of Business Address",
                  controller.addressPaths,
                  stored?.proofOfBusinessAddress ?? [],
                ),
                _buildDocumentCategorySection(
                  "Supporting Documents",
                  controller.supportingPaths,
                  stored?.supportingDocuments ?? [], // Assumes supportingDocuments exists in your model
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // New Helper: Builds a header and the list of files for each specific category
  Widget _buildDocumentCategorySection(String title, RxList<String> localPaths, List<String> serverUrls) {
    if (localPaths.isEmpty && serverUrls.isEmpty) return const SizedBox.shrink();

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
        // Local Files
        ...localPaths.asMap().entries.map((entry) => _buildDocumentTile(
          entry.value.split('/').last,
          "Pending Upload",
          1.0,
          isDone: true,
          onDelete: () => localPaths.removeAt(entry.key),
        )),
        // Server Files
        ...serverUrls.map((url) => _buildDocumentTile(
            url.split('/').last.split('?').first, // Clean filename from URL
            "Verified & Stored",
            1.0,
            isDone: true,
            isServer: true
        )),
        SizedBox(height: 15.h),
      ],
    );
  }

  RxList<String> _getTargetList() {
    if (selectedDocType == "Government Issued ID") return controller.governmentIdPaths;
    if (selectedDocType == "Business Registration Proof") return controller.registrationPaths;
    if (selectedDocType == "Proof of Business Address") return controller.addressPaths;
    return controller.supportingPaths;
  }

  // Helper: Build tiles for local paths
  List<Widget> _buildSectionList(RxList<String> list, String label) {
    return list.asMap().entries.map((entry) {
      return _buildDocumentTile(
        "$label: ${entry.value.split('/').last}",
        "Ready to upload",
        1.0,
        isDone: true,
        onDelete: () => list.removeAt(entry.key),
      );
    }).toList();
  }

  void _showPickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(text: "Select Source for $selectedDocType", fontWeight: FontWeight.bold, bottom: 15.h),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0XFF627E4C)),
              title: const Text("Camera"),
              onTap: () { Get.back(); controller.pickDocument(_getTargetList(), fromCamera: true); },
            ),
            ListTile(
              leading: const Icon(Icons.file_present, color: Color(0XFF627E4C)),
              title: const Text("Gallery / Files"),
              onTap: () { Get.back(); controller.pickDocument(_getTargetList(), fromCamera: false); },
            ),
          ],
        ),
      ),
    );
  }


  // MARK: - Helper Widgets
  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Color(0XFFE3E6DB),
        // color: AppColors.divider.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: label, fontSize: 12.sp, color: AppColors.geryColor),
          CustomText(text: value, fontSize: 18.sp, fontWeight: FontWeight.bold, top: 5.h),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData( // Changed from BarRodData
          toY: y,
          color: AppColors.divider,
          width: 25.w,
          borderRadius: BorderRadius.circular(8.r),
          backDrawRodData: BackgroundBarChartRodData( // Changed from BackgroundBarRodData
              show: true,
              toY: 100,
              color: AppColors.white
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentTile(String title, String subtitle, double progress, {bool isDone = false, bool isServer = false, VoidCallback? onDelete}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isServer ? const Color(0XFFCADA9F).withOpacity(0.1) : AppColors.divider.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isServer ? const Color(0XFF627E4C) : AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(isServer ? Icons.cloud_done : Icons.picture_as_pdf, color: const Color(0XFF1D3826)),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: title, fontSize: 12.sp, fontWeight: FontWeight.w600, maxLines: 1),
                CustomText(text: subtitle, fontSize: 10.sp, color: Colors.black54, top: 2.h),
              ],
            ),
          ),
          if (isDone && !isServer)
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.cancel, color: Colors.redAccent),
            ),
          if (isServer)
            const Icon(Icons.check_circle, color: Color(0XFF627E4C), size: 18),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.geryColor, style: BorderStyle.none), // Should be dashed in production
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 40.sp, color: AppColors.geryColor),
          CustomText(text: "Tap to choose a file", top: 10.h, color: AppColors.geryColor),
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
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: CustomText(text: value, color: Colors.white, fontSize: 13.sp));
          }).toList(),
          onChanged: (val) => setState(() => selectedDocType = val!),
        ),
      ),
    );
  }


  Widget _buildSmallDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration( color: Color(0XFF99A86F), borderRadius: BorderRadius.circular(5.r)),
      child: Row(
        children: [
          CustomText(text: value, color: AppColors.white, fontSize: 10.sp),
          Icon(Icons.arrow_drop_down, color: AppColors.white, size: 15.sp),
        ],
      ),
    );
  }

  // Mark: - Info Tab (Simple Placeholder)
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // 1. Profile Header Card
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Color(0XFF627E4C),
                // color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
            ),
            child: Row(
              children: [
                CustomNetworkImage(
                    imageUrl: "https://images.pexels.com/photos/3762882/pexels-photo-3762882.jpeg",
                    height: 60.r,
                    width: 60.r,
                    boxShape: BoxShape.circle
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Ada's Body Shop", color : Color(0XFFF1F0B2), fontWeight: FontWeight.bold, fontSize: 16.sp),
                      CustomText(text: "4.8 ★ Rating", color : Color(0XFFF1F0B2), fontSize: 12.sp, top: 4.h),

                      SizedBox(height: 10.h,),

                      Container(
                        width: 75.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0XFF1D3826),
                          borderRadius: BorderRadius.circular(5.r), // Smaller radius for small height
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Verify Account",
                            fontSize: 8.sp, // Reduced font size to fit H 20
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFF1F0B2),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Icon(Icons.edit_outlined,color : Color(0XFF000000), size: 20.sp),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 2. Address & Phone Cards
          _buildContactTile(Icons.location_on, "Address", "17 Binder Lane, NW, Block 52.\nEdmonton, AB. T21 0Z5"),
          _buildContactTile(Icons.phone, "Phone", "+1-500-587-8789"),

          // 3. Categories & Subcategories
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Categories"),
                SizedBox(height: 10.h),
                Wrap(spacing: 8.w, children: [_buildTag("Hair Care"), _buildTag("Skin Care")]),

                SizedBox(height: 20.h),

                _buildSectionHeader("Subcategories"),
                SizedBox(height: 10.h),
                Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildTag("Shampoo"), _buildTag("Hair Gels"), _buildTag("Edge Control"),
                      _buildTag("Leave-in Conditioner"), _buildTag("Hair Growth Oils"),
                      _buildTag("Face Cleansers"), _buildTag("Face Moisturizers"), _buildTag("Serums"),
                    ]
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 4. Bio Section
          _buildContactTile(Icons.article, "Your Bio", "We make homemade all-natural products that are specifically made for black hair and skin."),

          // 5. Quick Facts Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Quick Facts", fontWeight: FontWeight.bold, fontSize: 16.sp, bottom: 15.h,color : Color(0XFF000000),),
                _buildFactRow("Date Joined", "01/15/2019"),
                _buildFactRow("Annual Verification Due", "01/27/2026", valueColor: AppColors.primaryLight),
                _buildFactRow("No of Products Listed", "34"),
                _buildFactRow("Most Popular Item", "Product ID 000381", isSmall: true),
                _buildFactRow("Least Popular Item", "Product ID 000561", isSmall: true),
                _buildFactRow("Completed Orders", "296", hideDivider: true),
              ],
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

// --- Helper UI Components ---

  Widget _buildContactTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black, size: 22.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp,color : Color(0XFF000000),),
                CustomText(text: value, color: Color(0xB2000000), fontSize: 12.sp, top: 4.h),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color : Color(0XFF000000), size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp,color : Color(0XFF000000),),
        SizedBox(width: 8.w),
        Icon(Icons.add_circle, color: AppColors.primaryLight, size: 20.sp),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Color(0XFF9BB575),
        // color: AppColors.primaryLight.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(text: label, color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildFactRow(String label, String value, {Color? valueColor, bool hideDivider = false, bool isSmall = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: label, color : Color(0XFF000000), fontSize: 12.sp),
              CustomText(
                  text: value,
                  color: valueColor ?? Color(0x80000000),
                  fontSize: isSmall ? 10.sp : 12.sp,
                  fontWeight: FontWeight.w500
              ),
            ],
          ),
        ),
        if (!hideDivider) Divider(color: AppColors.divider, thickness: 1),
      ],
    );
  }
}