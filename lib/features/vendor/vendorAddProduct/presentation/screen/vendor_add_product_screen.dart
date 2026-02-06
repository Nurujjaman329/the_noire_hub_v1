import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../../vendorAddVariant/vendor_add_variant_sheet.dart';



class ProductEntry {
  String? subCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  ProductEntry({this.subCategory});
}

class VendorAddProductScreen extends StatefulWidget {
  const VendorAddProductScreen({super.key});

  @override
  State<VendorAddProductScreen> createState() => _VendorAddProductScreenState();
}

class _VendorAddProductScreenState extends State<VendorAddProductScreen> {
  String selectedCategory = "Hair";
  UserModel? user;

  final Map<String, List<String>> categoryData = {
    "Hair": ["Shampoo", "Extensions", "Wigs", "Conditioner", "Oils"],
    "Make Up": ["Lipstick", "Foundation", "Brushes", "Eyeliner"],
    "Nails": ["Polish", "Acrylic", "Gel", "Nail Art"],
  };

  String get businessName => user?.businessName ?? "Braids By Mia";

  @override
  void initState() {
    super.initState();
    user = LocalStorage.getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3826), // Dark Green Header
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: businessName,
                        fontSize: 28.sp,
                        color: const Color(0xFF1D3826).withValues(alpha:0.7),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    _buildSectionHeader("Product Category", "Select All types of Products you sell"),
                    _buildCategorySelection(),
                    SizedBox(height: 30.h),
                    _buildAddProductHeader(),
                    SizedBox(height: 15.h),
                    _buildPhotoUploader(),
                    SizedBox(height: 20.h),
                    _buildLabel("Select Subcategory"),
                    _buildDropdownField(["Shampoo", "Wigs", "Extensions"]),
                    SizedBox(height: 15.h),
                    _buildWeightRow(),
                    SizedBox(height: 15.h),
                    _buildLabel("Price"),
                    _buildPriceField(),
                    SizedBox(height: 15.h),
                    _buildLabel("Description (optional)"),
                    _buildDescriptionField(),
                    SizedBox(height: 30.h),
                    _buildSaveButton(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
        CustomText(text: sub, fontSize: 12.sp, color: const Color(0xFFB5B475)),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categoryData.keys.map((cat) {
        bool isSelected = selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = cat),
          child: Container(
            width: 105.w,
            height: 110.h,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFB7C591) : const Color(0xFFCADA9F).withValues(alpha:0.6),
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.category_outlined, // Placeholder for your custom icons
                  color: isSelected ? Colors.white : const Color(0xFF1D3826),
                  size: 28.sp,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: cat,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D3826),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Add Product", fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
            CustomText(text: "Category: $selectedCategory Care", fontSize: 12.sp, color: Colors.grey),
          ],
        ),
        TextButton(
          onPressed: () => Get.bottomSheet(
            const VendorAddVariantSheet(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          ),
          child: CustomText(
            text: "Add Variant",
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D3826),
            textDecoration: TextDecoration.underline,
          ),
        )
      ],
    );
  }

  Widget _buildPhotoUploader() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add_outlined, color: Color(0xFF1D3826)),
          SizedBox(height: 8.h),
          CustomText(text: "Tap to add photo", fontSize: 12.sp, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(text: text, fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D3826)),
    );
  }

  Widget _buildDropdownField(List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1D3826)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
      ),
    );
  }

  Widget _buildWeightRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Weight"),
        Row(
          children: [
            Expanded(flex: 3, child: _buildDropdownField(["Value e.g:gm"])),
            SizedBox(width: 10.w),
            Expanded(flex: 1, child: _buildDropdownField(["Unit"])),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.monetization_on_outlined, size: 20.sp, color: const Color(0xFF1D3826)),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: const TextField(
        maxLines: 3,
        decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D3826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onPressed: () {},
        child: CustomText(text: "Save", color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80.h,
      backgroundColor: const Color(0xFF1D3826),
      automaticallyImplyLeading: false,
      pinned: true,
    );
  }
}