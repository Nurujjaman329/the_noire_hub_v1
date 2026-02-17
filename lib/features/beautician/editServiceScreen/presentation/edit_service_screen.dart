import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_noire_hub_v1/features/beautician/editServiceScreen/presentation/widgets/beautician_edit_variant_sheet.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../beauticanStoreScreen/data/beautician_store_response_model.dart';
import '../data/Beautician_service_update_post_body.dart';
import 'package:get/get.dart';

import 'controller/beauticians_update_service_controller.dart';

class EditServicesScreen extends StatefulWidget {
  const EditServicesScreen({super.key});

  @override
  State<EditServicesScreen> createState() => _EditServicesScreenState();
}

class _EditServicesScreenState extends State<EditServicesScreen> {
  final controller = Get.find<BeauticiansUpdateServiceController>();
  late ServiceModel service;

  // Controllers...
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final discountValueController = TextEditingController();
  final maxDiscountController = TextEditingController();

  String? selectedDiscountType;
  bool isHomeServiceAvailable = false;

  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDates = {};
  final Set<DateTime> _originalDates = {};

  List<String> existingImages = [];
  List<File> newImages = [];

  @override
  void initState() {
    super.initState();
    service = Get.arguments as ServiceModel;
    _initializeData();
  }

  void _initializeData() {
    nameController.text = service.name;
    priceController.text = service.price.toString();
    descController.text = service.description;

    _selectedDates.clear();
    _originalDates.clear();

    // Discount initialization
    if (service.discount.value > 0) discountValueController.text = service.discount.value.toString();
    if (service.discount.maxAmount > 0) maxDiscountController.text = service.discount.maxAmount.toString();
    selectedDiscountType = service.discount.type;

    isHomeServiceAvailable = service.homeService;
    existingImages = List.from(service.images);

    // ✅ MERGE DATES: Add all existing dates to the selection set
    for (var dateStr in service.availableDates) {
      try {
        DateTime dt = DateTime.parse(dateStr);
        DateTime dayOnly = DateTime(dt.year, dt.month, dt.day);

        _selectedDates.add(dayOnly);  // For the UI selection
        _originalDates.add(dayOnly);  // ✅ For the "already saved" check
      } catch (e) {
        debugPrint("Date Error: $e");
      }
    }

    // ✅ Map variants with IDs
    controller.selectedVariants.value = service.variants.map((v) {
      return ServiceVariantUpdateBody(
        id: v.id,
        variantName: v.variantName,
        description: v.description,
        subVariants: v.subVariants.map((sv) => ServiceSubVariantUpdateBody(
          name: sv.name,
          price: sv.price.toDouble(),
        )).toList(),
      );
    }).toList();
  }

  void _handleUpdate() {
    // Basic validation...
    double? dVal = double.tryParse(discountValueController.text);
    double? maxD = double.tryParse(maxDiscountController.text);

    String? finalType = (dVal == null || dVal == 0) ? null : selectedDiscountType;
    double? finalValue = (dVal == null || dVal == 0) ? null : dVal;

    // ✅ PASS PREVIOUS + NEW DATES: Send the entire _selectedDates set
    final updateBody = BeauticianServiceUpdatePostBody(
      name: nameController.text.trim(),
      price: double.tryParse(priceController.text.trim()),
      description: descController.text.trim(),
      images: newImages.isEmpty ? null : newImages,
      availableDates: _selectedDates.toList(), // Full list (Original + New)
      discountType: finalType,
      discountValue: finalValue,
      discountMaxAmount: maxD,
      variants: controller.selectedVariants.toList(),
    );

    controller.patchService(service.id, updateBody);
  }

  void _openVariantEditSheet() {
    Get.dialog(
      const BeauticiansEditVariantSheet(),
      barrierDismissible: false,
    );
  }

  // --- ADD VARIANT LOGIC (Matches your JSON requirements) ---
  void _addNewVariant() {
    String name = "";
    String desc = "";

    Get.defaultDialog(
        title: "Add Variant",
        content: Column(
          children: [
            TextField(onChanged: (v) => name = v, decoration: const InputDecoration(hintText: "Variant Name")),
            TextField(onChanged: (v) => desc = v, decoration: const InputDecoration(hintText: "Description")),
          ],
        ),
        onConfirm: () {
          if (name.isNotEmpty) {
            controller.selectedVariants.add(
              ServiceVariantUpdateBody(
                variantName: name,
                description: desc,
                subVariants: [], // You can then add sub-variants in a second step
              ),
            );
            Get.back();
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: CustomText(text: "Edit Service", fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.background)),
                    SizedBox(height: 30.h),

                    // --- CALENDAR SECTION (Matches Add Screen UI) ---
                    _buildSectionTitle("Update Availability", "Manage your booking dates"),
                    _buildCalendarCard(),

                    SizedBox(height: 30.h),

                    // --- SERVICE DETAILS FORM (Matches Add Screen UI) ---
                    _buildServiceForm(),
                    SizedBox(height: 20.h),
                    _buildVariantSection(),

                    SizedBox(height: 40.h),
                    Obx(() => CustomButton(
                      onTap: controller.isLoading.value ? null : _handleUpdate,
                      text: controller.isLoading.value ? "Updating..." : "Save Changes",
                    )),
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

  Widget _buildServiceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: "Service Details", fontSize: 18.sp, fontWeight: FontWeight.bold),
        SizedBox(height: 20.h),

        // Image Uploader Section
        _buildPhotoUploader(),

        SizedBox(height: 20.h),
        _buildLabel("Service Name"),
        _buildInputWrapper(child: TextField(controller: nameController, decoration: const InputDecoration(hintText: "e.g. Silk Press", border: InputBorder.none))),

        SizedBox(height: 20.h),
        _buildPriceAndDiscountRow(),

        SizedBox(height: 15.h),
        _buildLabel("Max Discount Amount (Optional)"),
        _buildInputWrapper(child: TextField(controller: maxDiscountController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Cap the discount", border: InputBorder.none))),

        SizedBox(height: 20.h),
        _buildHomeServiceToggle(),

        SizedBox(height: 15.h),
        _buildLabel("Description"),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildVariantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Service Variants"),
        Obx(() => Column(
          children: controller.selectedVariants.map((v) => _buildVariantTile(v)).toList(),
        )),
        SizedBox(height: 10.h),
        CustomButton(
          text: "Manage Variants",
          onTap: _openVariantEditSheet,
        ),
      ],
    );
  }

  Widget _buildVariantTile(ServiceVariantUpdateBody variant) {
    return ListTile(
      title: Text(variant.variantName),
      subtitle: Text("${variant.subVariants.length} sub-variants"),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => controller.selectedVariants.remove(variant),
      ),
    );
  }

  // --- CALENDAR CARD (With fix for scrolling) ---
  Widget _buildCalendarCard() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: GestureDetector(
        onVerticalDragUpdate: (_) {}, // Prevents page scroll when touching calendar
        child: TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: const Color(0xFF1D3826), size: 24.sp),
            rightChevronIcon: Icon(Icons.chevron_right, color: const Color(0xFF1D3826), size: 24.sp),
            titleTextStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
          ),
          selectedDayPredicate: (day) => _selectedDates.contains(DateTime(day.year, day.month, day.day)),
          onDaySelected: (selectedDay, focusedDay) {
            DateTime dayOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            if (_originalDates.contains(dayOnly)) {
              Get.snackbar("Notice", "Previously saved dates cannot be removed", snackPosition: SnackPosition.BOTTOM);
              return;
            }
            setState(() {
              _focusedDay = focusedDay;
              if (_selectedDates.contains(dayOnly)) {
                _selectedDates.remove(dayOnly);
              } else {
                _selectedDates.add(dayOnly);
              }
            });
          },
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(color: Color(0xFFCADA9F), shape: BoxShape.circle),
            selectedTextStyle: TextStyle(color: Color(0xFF1D3826), fontWeight: FontWeight.bold),
            todayDecoration: BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  // --- UI HELPERS (Directly from Add Screen) ---
  Widget _buildSectionTitle(String title, String sub) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CustomText(text: title, fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0XFF1D3826)), CustomText(text: sub, fontSize: 11.sp, color: const Color(0XFFB5B475)), SizedBox(height: 15.h)]);
  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: CustomText(text: text, fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D3826)));
  Widget _buildInputWrapper({required Widget child}) => Container(padding: EdgeInsets.symmetric(horizontal: 12.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: child);

  Widget _buildPriceAndDiscountRow() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Price"), _buildInputWrapper(child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "0.00", border: InputBorder.none, prefixText: "\$ ")))])),
    SizedBox(width: 10.w),
    Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Discount"), Row(children: [Expanded(child: _buildInputWrapper(child: TextField(controller: discountValueController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Val", border: InputBorder.none)))), SizedBox(width: 5.w), _buildDiscountTypeDropdown()])]))
  ]);

  Widget _buildDiscountTypeDropdown() => Container(padding: EdgeInsets.symmetric(horizontal: 8.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: selectedDiscountType, hint: Text("Type", style: TextStyle(fontSize: 11.sp)), items: ["flat", "%"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedDiscountType = v))));

  Widget _buildHomeServiceToggle() => Container(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFF1D3826).withOpacity(0.3))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.home_work_outlined, color: const Color(0xFF1D3826), size: 22.sp), SizedBox(width: 10.w), CustomText(text: "Home Service Available", fontSize: 14.sp, fontWeight: FontWeight.w600)]), Switch(value: isHomeServiceAvailable, activeColor: const Color(0xFF1D3826), onChanged: (v) => setState(() => isHomeServiceAvailable = v))]));

  Widget _buildDescriptionField() => Container(padding: EdgeInsets.symmetric(horizontal: 10.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(hintText: "Describe your service...", border: InputBorder.none)));

  Widget _buildSliverAppBar() => SliverAppBar(expandedHeight: 180.h, backgroundColor: AppColors.primaryDark, pinned: true, leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20.sp), onPressed: () => Get.back()), flexibleSpace: FlexibleSpaceBar(background: Center(child: CustomNetworkImage(imageUrl: AppAssets.appLogo, height: 60.h, width: 150.w, fit: BoxFit.contain))));

  // --- PHOTO UPLOADER (Updated for existing + new images) ---
  Widget _buildPhotoUploader() => GestureDetector(
    onTap: _pickImage,
    child: Container(
      width: double.infinity, height: 120.h,
      decoration: BoxDecoration(color: const Color(0XFFCADA9F).withOpacity(0.3), border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(15.r)),
      child: (existingImages.isEmpty && newImages.isEmpty)
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.add_a_photo_outlined, size: 30, color: Color(0xFF1D3826)), CustomText(text: "Tap to add service photos", fontSize: 11.sp, top: 8.h)])
          : ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10.w),
        children: [
          ...existingImages.map((img) => _imageTile(img, true)),
          ...newImages.map((file) => _imageTile(file.path, false)),
        ],
      ),
    ),
  );

  Widget _imageTile(String path, bool isNetwork) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(right: 10.w), width: 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            image: DecorationImage(
                image: isNetwork ? NetworkImage("${ApiConstants.imageUrl}$path") : FileImage(File(path)) as ImageProvider,
                fit: BoxFit.cover
            )
        ),
      ),
      Positioned(top: 0, right: 5.w, child: GestureDetector(
        onTap: () => setState(() => isNetwork ? existingImages.remove(path) : newImages.removeWhere((f) => f.path == path)),
        child: const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white)),
      ))
    ]);
  }

  Future<void> _pickImage() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() { newImages.addAll(pickedFiles.map((x) => File(x.path))); });
    }
  }
}