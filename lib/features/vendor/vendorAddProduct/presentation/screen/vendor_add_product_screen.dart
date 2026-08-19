// lib/features/vendor/vendorAddProduct/presentation/screen/vendor_add_product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_noire_hub_v1/core/widgets/custom_app_bar.dart';
import '../../../../../core/constants/category_type_constants.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../common/category/presentation/controller/category_controller.dart';
import '../../../../common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../../../../common/subCategories/data/sub_categories_response_model.dart';
import '../../../vendorEditProduct/presentation/widgets/vendor_manage_variants_sheet.dart';
import '../../data/vendor_add_product_post_body.dart';
import '../controller/vendor_add_product_controller.dart';


class VendorAddProductScreen extends StatefulWidget {
  const VendorAddProductScreen({super.key});

  @override
  State<VendorAddProductScreen> createState() => _VendorAddProductScreenState();
}

class _VendorAddProductScreenState extends State<VendorAddProductScreen> {
  static const _loadMoreSubCategoryValue = '__load_more_subcategory__';

  final categoryController = Get.find<CategoryController>();
  final subCategoryController = Get.find<SubCategoryController>();
  final productController = Get.find<VendorAddProductController>();

  // Text Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final weightValueController = TextEditingController();
  final stockController = TextEditingController();
  final discountValueController = TextEditingController();
  final maxDiscountController = TextEditingController();
  String? selectedDiscountType;

  String selectedWeightUnit = "g";
  String? selectedCategoryId;
  String? selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    categoryController.loadCategories(userId: CacheService.userId);
  }



  void _handleSave() {
    if (selectedCategoryId == null || selectedSubCategoryId == null) {
      Get.snackbar("Error", "Please select category and subcategory");
      return;
    }

    // Validation: title & price
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter product name and price",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }



    final String discountValRaw = discountValueController.text.trim();
    final double discountAmount = double.tryParse(discountValRaw) ?? 0.0;
    final double maxAmount = double.tryParse(maxDiscountController.text.trim()) ?? 0.0;

    if (discountAmount > 0 && selectedDiscountType == null) {
      Get.snackbar("Error", "Please select a discount type (Flat or %)");
      return;
    }

    // If user sets a max amount, they MUST have a type and a discount value
    if (maxAmount > 0 && (selectedDiscountType == null || discountAmount <= 0)) {
      Get.snackbar("Error", "Max Amount requires a Discount Value and Type");
      return;
    }

    final bool hasDiscount = discountAmount > 0;

    final productData = VendorAddProductPostBody(
      images: productController.selectedImages,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0.0,
      categoryId: selectedCategoryId!,
      subCategoryId: selectedSubCategoryId!,
      weightValue: double.tryParse(weightValueController.text) ?? 0.0,
      weightUnit: selectedWeightUnit,
      stock: int.tryParse(stockController.text),
      variants: productController.selectedVariants,

      // Pass null if no discount, so the toJson() can skip them
      discountType: hasDiscount ? selectedDiscountType : null,
      discountValue: hasDiscount ? discountAmount : null,
      discountMaxAmount: (hasDiscount && maxAmount > 0) ? maxAmount : null,
    );

    productController.addProduct(productData);
  }


  String get businessName => CacheService.businessName.isNotEmpty
      ? CacheService.businessName
      : "Braids By Mia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3826),
      appBar: CustomAppBar(title: "", showBackButton: true, bgColor: Colors.transparent, arrowColor: Colors.white),
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
                        color: const Color(0xFF1D3826).withValues(alpha: 0.7),
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
                    _buildLabel("Product Title"),
                    _buildNameField(), // New Name/Title Field

                    SizedBox(height: 15.h),
                    _buildLabel("Select Subcategory"),
                    _buildSubCategoryDropdown(),

                    SizedBox(height: 15.h),
                    _buildWeightRow(),

                    // SizedBox(height: 15.h),
                    // _buildLabel("Price"),
                    // _buildPriceField(),

                    SizedBox(height: 15.h),
                    _buildPriceAndDiscountRow(),

                    SizedBox(height: 15.h),
                    _buildLabel("Max Discount Amount (Optional)"),
                    _buildInputWrapper(
                      child: TextField(
                        controller: maxDiscountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "e.g. 50.0 (Cap the discount)",
                            border: InputBorder.none,
                            icon: Icon(Icons.gavel, size: 20, color: Color(0xFF1D3826))
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),
                    _buildLabel("Stock Quantity"),
                    _buildStockField(),

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

  // --- NEW NAME FIELD WIDGET ---
  Widget _buildNameField() {
    return _buildInputWrapper(
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            hintText: "Enter product name",
            border: InputBorder.none,
            icon: Icon(Icons.title, size: 20, color: Color(0xFF1D3826))
        ),
      ),
    );
  }

  Widget _buildStockField() {
    return _buildInputWrapper(
      child: TextField(
        controller: stockController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: "Enter available stock",
            border: InputBorder.none,
            icon: Icon(Icons.inventory_2_outlined, size: 20, color: Color(0xFF1D3826))
        ),
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
    return Obx(() {
      if (categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final cats = categoryController.categories;
      if (cats.isEmpty) return const Text("No categories found");

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 80) {
            categoryController.loadMoreCategories();
          }
          return false;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...cats.map((cat) {
                bool isSelected = selectedCategoryId == cat.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryId = cat.id;
                      selectedSubCategoryId = null; // Reset subcat on category change
                    });
                    // Fetch subcategories for this specific category
                    subCategoryController.fetchSubCategories(
                      categoryId: cat.id,
                      categoryType: CategoryTypeConstants.product,
                      id: CacheService.userId,
                    );
                  },
                  child: Container(
                    width: 105.w,
                    height: 110.h,
                    margin: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFB7C591) : const Color(0xFFCADA9F).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Use network image if available, else icon
                        const Icon(Icons.category_outlined, color: Color(0xFF1D3826)),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: cat.name,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D3826),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (categoryController.isMoreLoading.value)
                SizedBox(
                  width: 105.w,
                  height: 110.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1D3826),
                      strokeWidth: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }


  Widget _buildSubCategoryDropdown() {
    if (selectedCategoryId == null) {
      return _buildInputWrapper(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          child: Text(
            'Select a category first',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
        ),
      );
    }

    final activeCategoryId = selectedCategoryId!;

    return Obx(() {
      subCategoryController.subCategories.length;
      subCategoryController.isLoading.value;
      subCategoryController.isMoreLoading.value;
      subCategoryController.hasMoreData.value;

      final isActiveCategory =
          subCategoryController.selectedCategoryId.value == activeCategoryId;
      final subCats = isActiveCategory
          ? subCategoryController.subCategories.toList()
          : const <SubCategoryItem>[];

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1D3826)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              subCategoryController.isLoading.value && isActiveCategory
                  ? "Loading..."
                  : "Select Subcategory",
            ),
            value: selectedSubCategoryId,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1D3826)),
            items: [
              ...subCats.map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  )),
              if (isActiveCategory && subCategoryController.hasMoreData.value)
                DropdownMenuItem(
                  value: _loadMoreSubCategoryValue,
                  enabled: !subCategoryController.isMoreLoading.value,
                  child: Text(
                    subCategoryController.isMoreLoading.value
                        ? "Loading..."
                        : "Load more...",
                    style: const TextStyle(
                      color: Color(0xFF1D3826),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
            onChanged: (v) {
              if (v == _loadMoreSubCategoryValue) {
                subCategoryController.loadMore();
                return;
              }
              setState(() => selectedSubCategoryId = v);
            },
          ),
        ),
      );
    });
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
           // CustomText(text: "Category: $selectedCategory Care", fontSize: 12.sp, color: Colors.grey),
          ],
        ),
        TextButton(
          onPressed: () => Get.bottomSheet(
            const VendorManageVariantsSheet(isEditMode: false),
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
    return Obx(() => GestureDetector(
      onTap: () => _showImageSourceOptions(), // Updated to show options
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1D3826)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: productController.selectedImages.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: Color(0xFF1D3826)),
            SizedBox(height: 8.h),
            CustomText(text: "Tap to add photos", fontSize: 12.sp, color: Colors.grey),
          ],
        )
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productController.selectedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      productController.selectedImages[index],
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => productController.removeImage(index),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    ));
  }

// The Selection Sheet
  void _showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(text: "Upload From", fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sourceTile(Icons.camera_alt, "Camera", ImageSource.camera),
                _sourceTile(Icons.photo_library, "Gallery", ImageSource.gallery),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _sourceTile(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () {
        Get.back();
        productController.pickImage(source);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: const Color(0xFF1D3826).withValues(alpha: 0.1),
            child: Icon(icon, color: const Color(0xFF1D3826), size: 30.sp),
          ),
          SizedBox(height: 8.h),
          CustomText(text: label, fontSize: 14.sp),
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


  Widget _buildWeightRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Weight"),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildInputWrapper(
                child: TextField(
                  controller: weightValueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter value",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: _buildInputWrapper(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedWeightUnit, // This value MUST be in the items below
                    items: ["g", "kg", "ml", "liter"].map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => selectedWeightUnit = v);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildInputWrapper({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child,
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: descController, // <--- Add this line
        maxLines: 3,
        decoration: const InputDecoration(
            hintText: "Enter product description",
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10)
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D3826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onPressed: productController.isLoading.value ? null : _handleSave,
        child: productController.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : CustomText(text: "Save", color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    ));
  }


  Widget _buildPriceAndDiscountRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Price Field ---
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Price"),
              _buildInputWrapper(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "0.0",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.attach_money, size: 18),
                    prefixIconConstraints: BoxConstraints(minWidth: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),

        // --- Discount Section ---
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Discount"),
              Row(
                children: [
                  Expanded(
                    child: _buildInputWrapper(
                      child: TextField(
                        controller: discountValueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Val",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  // --- Updated Dropdown with Hint ---
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        // Visual feedback: border turns red if value exists but type is missing
                        color: (double.tryParse(discountValueController.text) ?? 0) > 0
                            && selectedDiscountType == null
                            ? Colors.red
                            : const Color(0xFF1D3826),
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDiscountType,
                        hint: Text("Type", style: TextStyle(fontSize: 12.sp)), // Initial Hint
                        items: [
                          const DropdownMenuItem(value: "flat", child: Text("Flat")),
                          const DropdownMenuItem(value: "%", child: Text("%")),
                        ],
                        onChanged: (v) {
                          setState(() => selectedDiscountType = v);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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