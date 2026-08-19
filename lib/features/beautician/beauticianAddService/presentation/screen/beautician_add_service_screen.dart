// lib/features/beautician/beauticianAddService/presentation/screen/beautician_add_service_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/category_type_constants.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../common/category/presentation/controller/category_controller.dart';
import '../../../../common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../../../beauticiansVariantAdd/presentation/beauticians_add_variant_sheet.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/beauticians_create_service_post_body.dart';
import '../controller/beauticians_create_service_controller.dart';

class BeauticianAddServiceScreen extends StatefulWidget {
  const BeauticianAddServiceScreen({super.key});

  @override
  State<BeauticianAddServiceScreen> createState() => _BeauticianAddServiceScreenState();
}

class _BeauticianAddServiceScreenState extends State<BeauticianAddServiceScreen> {
  static const _loadMoreSubCategoryValue = '__load_more_subcategory__';

  // GetX Controllers
  final categoryController = Get.find<CategoryController>();
  final subCategoryController = Get.find<SubCategoryController>();
  final serviceController = Get.find<BeauticiansCreateServiceController>();

  // Text Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final discountValueController = TextEditingController();
  final maxDiscountController = TextEditingController();

  // Selection States
  String? selectedCategoryId;
  String? selectedSubCategoryId;
  String? selectedDiscountType;
  bool isHomeServiceAvailable = false;

  // Calendar & Time States
  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDates = {};
  bool isRecurring = false;
  bool applyToAllDates = false;

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  final Set<String> _selectedTimeSlots = {};

  @override
  void initState() {
    super.initState();
    // Initialize data using CacheService as per your instructions
    categoryController.loadCategories(userId: CacheService.userId);
  }


  void _handleSave() {
    // 1. Basic Validation
    if (selectedCategoryId == null || selectedSubCategoryId == null) {
      Get.snackbar("Error", "Please select category and subcategory",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }



    final String name = nameController.text.trim();
    final String priceStr = priceController.text.trim();
    final String discountValStr = discountValueController.text.trim();
    final String maxDiscountStr = maxDiscountController.text.trim();

    if (name.isEmpty || priceStr.isEmpty) {
      Get.snackbar("Error", "Service name and price are required",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (_selectedTimeSlots.isEmpty) {
      Get.snackbar("Error", "Please select at least one time slot",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }



    // 2. Complex Discount Validation
    double? discountValue = double.tryParse(discountValStr);
    double? maxDiscount = double.tryParse(maxDiscountStr);

    // Logic: If Max Discount exists OR if Discount Value exists -> Must have both Value and Type
    bool hasDiscountValue = discountValStr.isNotEmpty && discountValue != null;
    bool hasMaxDiscount = maxDiscountStr.isNotEmpty && maxDiscount != null;
    bool hasType = selectedDiscountType != null;

    if (hasDiscountValue || hasMaxDiscount) {
      if (!hasDiscountValue || !hasType) {
        Get.snackbar("Discount Error", "To apply a discount (or max limit), you must provide both Value and Type.",
            backgroundColor: Colors.orangeAccent, colorText: Colors.white);
        return;
      }
    }

    // 3. Data Preparation
    final List<String> formattedDates = _selectedDates.map((d) => DateFormat('yyyy-MM-dd').format(d)).toList();


    final List<WorkingSlot> slotsForApi = _selectedTimeSlots.map((slotString) {
      // slotString is "09:00 AM - 10:00 AM"
      final parts = slotString.split(" - ");
      return WorkingSlot(
        startTime: _convertTo24Hour(parts[0]), // Becomes "09:00"
        endTime: _convertTo24Hour(parts[1]),   // Becomes "10:00"
      );
    }).where((slot) => slot.startTime != "00:00").toList();


    final serviceData = BeauticiansCreateServicePostBody(
      images: serviceController.selectedImages.toList(),
      categoryId: selectedCategoryId!,
      subCategoryId: selectedSubCategoryId!,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0.0,
      homeService: isHomeServiceAvailable,
      availableDates: formattedDates,
      workingSlots: slotsForApi,
      discountType: selectedDiscountType,
      discountValue: double.tryParse(discountValueController.text),
      discountMaxAmount: double.tryParse(maxDiscountController.text),
      variants: serviceController.selectedVariants.toList(),
    );

    serviceController.addService(serviceData);
  }

  String _convertTo24Hour(String time12h) {
    try {
      // 1. Remove hidden characters and split by space: ["03:00", "PM"]
      final cleanTime = time12h.replaceAll(RegExp(r'[^\x00-\x7F]+'), ' ').trim();
      final parts = cleanTime.split(" ");
      if (parts.length < 2) return "00:00";

      final timeParts = parts[0].split(":"); // ["03", "00"]
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      String period = parts[1].toUpperCase();

      // 2. Logic to convert to 24h
      if (period == "PM" && hour != 12) hour += 12;
      if (period == "AM" && hour == 12) hour = 0;

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } catch (e) {
      debugPrint("Time Conversion Error: $e");
      return "00:00";
    }
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
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: CustomText(text: businessName, fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.background)),
                    SizedBox(height: 30.h),

                    // --- CATEGORY SECTION ---
                    _buildSectionTitle("Service Category", "Select the primary category for this service"),
                    Obx(() => categoryController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : _buildSpecialtiesList()),

                    SizedBox(height: 30.h),

                    // --- CALENDAR SECTION ---
                    _buildSectionTitle("Select Dates", "What days are you available for bookings"),
                    _buildCalendarCard(),
                    SizedBox(height: 15.h),
                    _buildDarkCheckbox(
                      value: isRecurring,
                      label: "Set selected days as recurring within the year",
                      onChanged: (v) => setState(() => isRecurring = v!),
                    ),

                    SizedBox(height: 30.h),

                    // --- WORKING HOURS SECTION ---
                    _buildSectionTitle("Working Hours", "Set your availability for the selected dates"),
                    _buildDarkCheckbox(
                      value: applyToAllDates,
                      label: "Apply to all selected dates",
                      onChanged: (v) => setState(() => applyToAllDates = v!),
                    ),
                    SizedBox(height: 20.h),
                    _buildTimePickerRow(),
                    SizedBox(height: 20.h),
                    _buildLabel("Generated Time Slots"),
                    _buildGeneratedSlotsGrid(),

                    SizedBox(height: 30.h),

                    // --- SERVICE DETAILS FORM ---
                    _buildServiceForm(),

                    SizedBox(height: 40.h),
                    Obx(() => CustomButton(
                      onTap: serviceController.isLoading.value ? null : _handleSave,
                      text: serviceController.isLoading.value ? "Saving..." : "Save & Continue",
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

  Widget _buildGeneratedSlotsGrid() {
    final allPossibleSlots = _generateTimeSlots();

    if (allPossibleSlots.isEmpty) {
      return CustomText(
          text: "End time must be at least 1 hour after start time",
          fontSize: 11.sp,
          color: Colors.redAccent
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha:0.2)),
      ),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: allPossibleSlots.map((slot) {
          bool isSelected = _selectedTimeSlots.contains(slot);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedTimeSlots.remove(slot);
                } else {
                  _selectedTimeSlots.add(slot);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1D3826) : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF1D3826),
                  width: 1,
                ),
              ),
              child: CustomText(
                  text: slot,
                  fontSize: 11.sp,
                  color: isSelected ? Colors.white : const Color(0xFF1D3826),
                  fontWeight: FontWeight.w500
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildServiceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "Service Details", fontSize: 18.sp, fontWeight: FontWeight.bold),
            // --- SUB CATEGORY DROPDOWN ---
            SizedBox(width: 140.w, child: _buildSubCategoryDropdown()),
          ],
        ),
        SizedBox(height: 20.h),
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
        SizedBox(height: 25.h),

        Obx(() => serviceController.selectedVariants.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Added Add-ons"),
            ...serviceController.selectedVariants.map((variant) => Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: const Color(0xFF1D3826).withValues(alpha:0.05),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.2))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: variant.variantName, fontWeight: FontWeight.bold),
                      CustomText(text: "${variant.subVariants.length} sub-options", fontSize: 11.sp),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => serviceController.selectedVariants.remove(variant),
                  )
                ],
              ),
            )),
            SizedBox(height: 10.h),
          ],
        )
            : const SizedBox.shrink()),
        _buildVariantLink(),
      ],
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildSpecialtiesList() {
    return Obx(() {
      final cats = categoryController.categories;
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
                    setState(() { selectedCategoryId = cat.id; selectedSubCategoryId = null; });
                    subCategoryController.fetchSubCategories(
                      categoryId: cat.id,
                      categoryType: CategoryTypeConstants.service,
                      id: CacheService.userId,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 100.w, height: 110.h, margin: EdgeInsets.only(right: 15.w),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondaryVariant : AppColors.primary.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(isSelected ? Icons.check_circle : Icons.spa_outlined, color: isSelected ? Colors.white : AppColors.background, size: 30.sp),
                      CustomText(text: cat.name, fontSize: 11.sp, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary, top: 8.h),
                    ]),
                  ),
                );
              }),
              if (categoryController.isMoreLoading.value)
                SizedBox(
                  width: 100.w,
                  height: 110.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
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
    return Obx(() {
      final subCats = subCategoryController.subCategories;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha:0.1), borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.primary)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: selectedSubCategoryId, isExpanded: true,
          hint: CustomText(text: subCategoryController.isLoading.value ? "..." : "Type", fontSize: 11.sp),
          items: [
            ...subCats.map((e) => DropdownMenuItem(value: e.id, child: CustomText(text: e.name, fontSize: 11.sp))),
            if (subCategoryController.hasMoreData.value)
              DropdownMenuItem(
                value: _loadMoreSubCategoryValue,
                enabled: !subCategoryController.isMoreLoading.value,
                child: CustomText(
                  text: subCategoryController.isMoreLoading.value ? "Loading..." : "Load more...",
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
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
        )),
      );
    });
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      // Fix: GestureDetector stops the parent ScrollView from scrolling when touching the calendar
      child: GestureDetector(
        onVerticalDragUpdate: (_) {},
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
          selectedDayPredicate: (day) => _selectedDates.contains(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
              if (_selectedDates.contains(selectedDay)) {
                _selectedDates.remove(selectedDay);
              } else {
                _selectedDates.add(selectedDay);
              }
            });
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(color: Color(0xFFCADA9F), shape: BoxShape.circle),
            selectedTextStyle: const TextStyle(color: Color(0xFF1D3826), fontWeight: FontWeight.bold),
            todayDecoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            todayTextStyle: const TextStyle(color: Colors.black),
            outsideDaysVisible: false,
          ),
        ),
      ),
    );
  }


  Widget _buildTimePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeDigitBox(startTime, (t) => setState(() => startTime = t)),
        CustomText(text: "to", fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
        _buildTimeDigitBox(endTime, (t) => setState(() => endTime = t)),
      ],
    );
  }

  Widget _buildTimeDigitBox(TimeOfDay time, Function(TimeOfDay) onPick) {
    final hour = time.hourOfPeriod == 0 ? "12" : time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final isAM = time.period == DayPeriod.am;

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFFCADA9F), onPrimary: Color(0xFF1D3826), onSurface: Color(0xFF1D3826)),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          onPick(picked);
          // Auto-fill all slots as selected by default when range changes
          setState(() {
            _selectedTimeSlots.clear();
            _selectedTimeSlots.addAll(_generateTimeSlots());
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _digitContainer(hour),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.w), child: CustomText(text: ":", fontSize: 18.sp, fontWeight: FontWeight.bold)),
          _digitContainer(minute),
          SizedBox(width: 8.w),
          Column(children: [
            _buildPeriodLabel("AM", isAM),
            SizedBox(height: 4.h),
            _buildPeriodLabel("PM", !isAM),
          ])
        ],
      ),
    );
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];

    // Convert TimeOfDay to minutes for easier calculation
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    // If end time is before start time (e.g., 10 PM to 2 AM),
    // you might want to handle it, but for now we assume same-day.
    if (endMinutes <= startMinutes) return [];

    int currentMinutes = startMinutes;

    while (currentMinutes + 60 <= endMinutes) {
      int nextMinutes = currentMinutes + 60;

      String startFormatted = _formatTo12Hour(currentMinutes);
      String endFormatted = _formatTo12Hour(nextMinutes);

      slots.add("$startFormatted - $endFormatted");
      currentMinutes = nextMinutes;
    }

    return slots;
  }

// Helper to format minutes into "10:00 AM"
  String _formatTo12Hour(int totalMinutes) {
    int hour = (totalMinutes ~/ 60);
    int minute = totalMinutes % 60;

    String period = hour >= 12 ? "PM" : "AM";
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;

    // Use a standard space ' ' instead of relying on DateFormat locales
    return "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  Widget _buildPeriodLabel(String text, bool isActive) => CustomText(text: text, fontSize: 10.sp, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF00E5CC) : Colors.grey.shade400);

  Widget _digitContainer(String value) => Container(
    width: 55.w, height: 45.h, alignment: Alignment.center,
    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10.r)),
    child: CustomText(text: value, fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
  );

  Widget _buildDarkCheckbox({required bool value, required String label, required ValueChanged<bool?> onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(color: const Color(0xFF1D3826), borderRadius: BorderRadius.circular(12.r)),
      child: Row(children: [
        Transform.scale(scale: 1.2, child: Checkbox(value: value, onChanged: onChanged, activeColor: const Color(0xFF1D3826), checkColor: Colors.white, side: const BorderSide(color: Colors.white, width: 2))),
        SizedBox(width: 10.w),
        Expanded(child: CustomText(text: label, fontSize: 13.sp, color: Colors.white)),
      ]),
    );
  }

  // --- Re-used existing methods ---
  String get businessName => CacheService.businessName.isNotEmpty ? CacheService.businessName : "My Studio";
  Widget _buildSectionTitle(String title, String sub) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CustomText(text: title, fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0XFF1D3826)), CustomText(text: sub, fontSize: 11.sp, color: const Color(0XFFB5B475)), SizedBox(height: 15.h)]);
  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: CustomText(text: text, fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D3826)));
  Widget _buildInputWrapper({required Widget child}) => Container(padding: EdgeInsets.symmetric(horizontal: 12.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: child);
  Widget _buildPriceAndDiscountRow() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Price"), _buildInputWrapper(child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "0.00", border: InputBorder.none, prefixText: "\$ ")))])), SizedBox(width: 10.w), Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Discount"), Row(children: [Expanded(child: _buildInputWrapper(child: TextField(controller: discountValueController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Val", border: InputBorder.none)))), SizedBox(width: 5.w), _buildDiscountTypeDropdown()])]))]);
  Widget _buildDiscountTypeDropdown() => Container(padding: EdgeInsets.symmetric(horizontal: 8.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: selectedDiscountType, hint: Text("Type", style: TextStyle(fontSize: 11.sp)), items: ["flat", "%"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedDiscountType = v))));
  Widget _buildHomeServiceToggle() => Container(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha:0.1), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.3))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.home_work_outlined, color: const Color(0xFF1D3826), size: 22.sp), SizedBox(width: 10.w), CustomText(text: "Home Service Available", fontSize: 14.sp, fontWeight: FontWeight.w600)]), Switch(value: isHomeServiceAvailable, activeThumbColor: const Color(0xFF1D3826), onChanged: (v) => setState(() => isHomeServiceAvailable = v))]));
  Widget _buildDescriptionField() => Container(padding: EdgeInsets.symmetric(horizontal: 10.w), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(8.r)), child: TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(hintText: "Describe your service...", border: InputBorder.none)));
  Widget _buildVariantLink() => GestureDetector(onTap: () => Get.dialog(const BeauticiansAddVariantSheet(), barrierDismissible: true), child: Container(padding: EdgeInsets.symmetric(vertical: 12.h), decoration: BoxDecoration(color: const Color(0xFF1D3826), borderRadius: BorderRadius.circular(15.r)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_circle_outline, color: Colors.white, size: 20.sp), SizedBox(width: 10.w), CustomText(text: "Add Service Add-ons (Variants)", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)])));
  Widget _buildSliverAppBar() => SliverAppBar(expandedHeight: 180.h, backgroundColor: AppColors.primaryDark, pinned: true, flexibleSpace: FlexibleSpaceBar(background: Center(child: CustomNetworkImage(imageUrl: AppAssets.appLogo, height: 60.h, width: 150.w, fit: BoxFit.contain))), leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20.sp), onPressed: () => Get.back()));
  Widget _buildPhotoUploader() => Obx(() => GestureDetector(onTap: () => _showImagePickerOptions(), child: Container(width: double.infinity, height: 120.h, decoration: BoxDecoration(color: const Color(0XFFCADA9F).withValues(alpha:0.3), border: Border.all(color: const Color(0xFF1D3826)), borderRadius: BorderRadius.circular(15.r)), child: serviceController.selectedImages.isEmpty ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.add_a_photo_outlined, size: 30, color: Color(0xFF1D3826)), CustomText(text: "Tap to add service photos", fontSize: 11.sp, top: 8.h)]) : ListView.builder(scrollDirection: Axis.horizontal, padding: EdgeInsets.all(10.w), itemCount: serviceController.selectedImages.length, itemBuilder: (context, index) => _imagePreviewTile(index)))));
  Widget _imagePreviewTile(int index) => Stack(children: [Container(margin: EdgeInsets.only(right: 10.w), width: 100.w, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), image: DecorationImage(image: FileImage(serviceController.selectedImages[index]), fit: BoxFit.cover))), Positioned(top: 0, right: 5.w, child: GestureDetector(onTap: () => serviceController.removeImage(index), child: const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white))))]);
  void _showImagePickerOptions() => Get.bottomSheet(Container(padding: EdgeInsets.all(20.w), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Camera"), onTap: () { Get.back(); serviceController.pickImage(ImageSource.camera); }), ListTile(leading: const Icon(Icons.photo_library), title: const Text("Gallery"), onTap: () { Get.back(); serviceController.pickImage(ImageSource.gallery); })])));
}
