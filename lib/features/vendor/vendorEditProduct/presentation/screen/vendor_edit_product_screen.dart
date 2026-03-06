import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../widgets/vendor_manage_variants_sheet.dart';
import '../../data/vendor_edit_product_form_body.dart';
import '../controller/vendor_edit_product_controller.dart';
import '../../../vendorStoreScreen/data/vendor_products_response_model.dart';



class VendorEditProductScreen extends StatefulWidget {
  final Product product;
  const VendorEditProductScreen({super.key, required this.product});

  @override
  State<VendorEditProductScreen> createState() => _VendorEditProductScreenState();
}

class _VendorEditProductScreenState extends State<VendorEditProductScreen> {
  // Use the new Edit controller
  final editController = Get.find<VendorEditProductController>();
  List<EditProductVariantBody> _initialVariants = [];

  // Text Controllers pre-filled with existing product data
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descController;
  late TextEditingController weightValueController;
  late TextEditingController stockController;
  late TextEditingController discountValueController;
  late TextEditingController maxDiscountController;

  String selectedWeightUnit = "g";
  String? selectedDiscountType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price.toString());
    descController = TextEditingController(text: widget.product.description);
    weightValueController = TextEditingController(text: widget.product.weight.value.toString());
    stockController = TextEditingController(text: widget.product.stock.toString());
    selectedWeightUnit = widget.product.weight.unit;

    final initialDiscountValue = widget.product.discount.value;
    final initialMaxAmount = widget.product.discount.maxAmount;

    discountValueController = TextEditingController(
        text: initialDiscountValue > 0 ? initialDiscountValue.toString() : ""
    );

    maxDiscountController = TextEditingController(
        text: (initialMaxAmount != null && initialMaxAmount > 0) ? initialMaxAmount.toString() : ""
    );

    if (initialDiscountValue > 0 &&
        (widget.product.discount.type == "%" || widget.product.discount.type == "flat")) {
      selectedDiscountType = widget.product.discount.type;
    } else {
      selectedDiscountType = null; // Forces "Select Type" hint to show
    }

    editController.selectedVariants.clear();
    for (var variant in widget.product.variants) {
      editController.selectedVariants.add(
        EditProductVariantBody(
          id: variant.id, // Include the ID for existing variants
          color: variant.color,
          price: variant.price,
          weightValue: variant.weight.value,
          weightUnit: variant.weight.unit,
        ),
      );
    }

    _initialVariants = widget.product.variants.map((variant) =>
        EditProductVariantBody(
          id: variant.id, // Include the ID for existing variants
          color: variant.color,
          price: variant.price,
          weightValue: variant.weight.value,
          weightUnit: variant.weight.unit,
        )
    ).toList();

    editController.selectedVariants.clear();
    editController.selectedVariants.addAll(_initialVariants);
    }

  bool _haveVariantsChanged() {
    // 1. If length is different, something definitely changed (added or removed)
    if (editController.selectedVariants.length != _initialVariants.length) {
      return true;
    }

    // 2. If length is same, check if any property inside has changed
    for (int i = 0; i < editController.selectedVariants.length; i++) {
      var current = editController.selectedVariants[i];
      var original = _initialVariants[i];

      if (current.color != original.color ||
          current.price != original.price ||
          current.weightValue != original.weightValue ||
          current.weightUnit != original.weightUnit) {
        return true;
      }
    }

    // 3. If we got here, they are identical
    return false;
  }

  void _handleUpdate() {
    final String name = nameController.text.trim();
    final String priceRaw = priceController.text.trim();
    final String discountValRaw = discountValueController.text.trim();
    final String maxAmountRaw = maxDiscountController.text.trim();

    // Basic Validation
    if (name.isEmpty || priceRaw.isEmpty) {
      Get.snackbar("Required", "Please enter product name and price",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final double discountAmount = double.tryParse(discountValRaw) ?? 0.0;
    final double maxAmount = double.tryParse(maxAmountRaw) ?? 0.0;

    // Rule: If discount value > 0, Type is MUST
    if (discountAmount > 0 && selectedDiscountType == null) {
      Get.snackbar("Required", "Please select a discount type",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    // Rule: If Max Amount is set, Value and Type are MUST
    if (maxAmount > 0 && (discountAmount <= 0 || selectedDiscountType == null)) {
      Get.snackbar("Error", "Max Amount requires a Discount Value and Type",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    bool variantsChanged = _haveVariantsChanged();
    final bool hasValidDiscount = discountAmount > 0;

    final updateBody = VendorUpdateProductFormBody(
      name: name,
      price: double.tryParse(priceRaw),
      description: descController.text.trim(),
      weightValue: double.tryParse(weightValueController.text),
      weightUnit: selectedWeightUnit,

      // Pass values ONLY if they satisfy the discount requirements
      discountValue: hasValidDiscount ? discountAmount : null,
      discountType: hasValidDiscount ? selectedDiscountType : null,
      discountMaxAmount: (hasValidDiscount && maxAmount > 0) ? maxAmount : null,

      stock: int.tryParse(stockController.text),
      newImages: editController.selectedImages,
      variants: variantsChanged ? editController.selectedVariants : null,
      isActive: true,
    );

    editController.updateProduct(widget.product.id, updateBody);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3826),
      appBar: CustomAppBar(
          title: "Edit Product",
          tittleColor: Colors.white,
          showBackButton: true,
          bgColor: Colors.transparent,
          arrowColor: Colors.white
      ),
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
                    _buildHeaderSection(),
                    SizedBox(height: 25.h),

                    _buildPhotoUploader(),
                    SizedBox(height: 25.h),

                    _buildLabel("Product Title"),
                    _buildInputWrapper(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: "Enter name", border: InputBorder.none, icon: Icon(Icons.title, color: Color(0xFF1D3826))),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    _buildWeightRow(),

                    SizedBox(height: 20.h),
                    _buildLabel("Price"),
                    _buildInputWrapper(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: InputBorder.none, icon: Icon(Icons.attach_money, color: Color(0xFF1D3826))),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    _buildDiscountRow(),

                    SizedBox(height: 20.h),
                    _buildLabel("Stock Quantity"),
                    _buildInputWrapper(
                      child: TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: InputBorder.none, icon: Icon(Icons.inventory_2_outlined, color: Color(0xFF1D3826))),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    _buildLabel("Description"),
                    _buildDescriptionField(),

                    SizedBox(height: 35.h),
                    _buildSaveButton(),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildDiscountRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Discount"),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildInputWrapper(
                child: TextField(
                  controller: discountValueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "Value",
                      border: InputBorder.none,
                      icon: Icon(Icons.money_off, size: 18, color: Color(0xFF1D3826))
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 3,
              child: _buildInputWrapper(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDiscountType,
                    hint: CustomText(text: "Select Type", fontSize: 12.sp, color: Colors.grey),
                    items: ["%", "flat"].map((u) => DropdownMenuItem(
                        value: u,
                        child: Text(u == "%" ? "Percentage (%)" : "Flat Amount")
                    )).toList(),
                    onChanged: (v) => setState(() => selectedDiscountType = v),
                  ),
                ),
              ),
            ),
          ],
        ),
        // ✅ Added Max Amount Field
        SizedBox(height: 15.h),
        _buildLabel("Max Discount Amount (Optional Cap)"),
        _buildInputWrapper(
          child: TextField(
            controller: maxDiscountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "Enter max cap amount",
                border: InputBorder.none,
                icon: Icon(Icons.gavel, size: 18, color: Color(0xFF1D3826))
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: "Edit Details", fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
        TextButton(
          onPressed: () => Get.bottomSheet(
            VendorManageVariantsSheet(
              initialVariants: widget.product.variants,
              isEditMode: true,
            ),
            isScrollControlled: true,
          ),
          child: CustomText(
            text: "Manage Variants",
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D3826),
            textDecoration: TextDecoration.underline,
          ),
        )
      ],
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
                  decoration: const InputDecoration(hintText: "Value", border: InputBorder.none),
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
                    value: selectedWeightUnit,
                    items: ["g", "kg", "ml", "liter"].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) => setState(() => selectedWeightUnit = v!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploader() {
    return Obx(() => Container(
      width: double.infinity,
      height: 110.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.3)),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: editController.selectedImages.isEmpty
          ? InkWell(
        onTap: () => editController.pickImage(ImageSource.gallery),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: Color(0xFF1D3826)),
            CustomText(text: "Add new images", fontSize: 12.sp, color: Colors.grey),
          ],
        ),
      )
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: editController.selectedImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(editController.selectedImages[index], width: 80.w, height: 80.h, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 0, right: 0,
                  child: GestureDetector(
                    onTap: () => editController.removeImage(index),
                    child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(10.r)),
      child: TextField(
        controller: descController,
        maxLines: 4,
        decoration: const InputDecoration(hintText: "Product description...", border: InputBorder.none),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D3826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        onPressed: editController.isLoading.value ? null : _handleUpdate,
        child: editController.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : CustomText(text: "Update Product", color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: CustomText(text: text, fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D3826)),
  );

  Widget _buildInputWrapper({required Widget child}) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.5)), borderRadius: BorderRadius.circular(10.r)),
    child: child,
  );

  Widget _buildSliverAppBar() => SliverAppBar(expandedHeight: 60.h, backgroundColor: const Color(0xFF1D3826), pinned: true, automaticallyImplyLeading: false);
}