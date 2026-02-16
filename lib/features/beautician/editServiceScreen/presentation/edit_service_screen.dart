import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
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
  // Controller and Data
  final controller = Get.find<BeauticiansUpdateServiceController>();
  late ServiceModel service;

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // Date & Time State
  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDates = {};
  final Set<DateTime> _originalDates = {}; // To track what was already there
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  // Image State
  List<String> existingImages = [];
  List<File> newImages = [];

  @override
  void initState() {
    super.initState();
    // Get the service object passed from the previous screen
    service = Get.arguments as ServiceModel;
    _initializeData();
  }

  void _initializeData() {
    nameController.text = service.name;
    priceController.text = service.price.toString();
    descController.text = service.description;
    existingImages = List.from(service.images);

    // 1. Convert string dates from backend to DateTime objects
    for (var dateStr in service.availableDates) {
      DateTime dt = DateTime.parse(dateStr);
      DateTime dayOnly = DateTime(dt.year, dt.month, dt.day);
      _selectedDates.add(dayOnly);
      _originalDates.add(dayOnly);
    }

    // 2. Initialize Time with AM/PM support
    String rawStart = service.workingHours.startTime; // e.g., "09:00 AM"
    String rawEnd = service.workingHours.endTime;     // e.g., "06:00 PM"

    startTime = _parseTimeString(rawStart);
    endTime = _parseTimeString(rawEnd);
  }

  /// Helper method to safely parse "HH:mm AM/PM" or "HH:mm" into TimeOfDay
  TimeOfDay _parseTimeString(String timeStr) {
    try {
      // 1. Extract digits only for splitting (removes AM/PM)
      // RegExp matches the numbers before and after the colon
      final timeMatch = RegExp(r'(\d+):(\d+)').firstMatch(timeStr);
      if (timeMatch == null) return const TimeOfDay(hour: 9, minute: 0);

      int hour = int.parse(timeMatch.group(1)!);
      int minute = int.parse(timeMatch.group(2)!);

      // 2. Handle AM/PM logic
      String period = timeStr.toUpperCase();
      if (period.contains("PM") && hour < 12) {
        hour += 12;
      } else if (period.contains("AM") && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint("Error parsing time '$timeStr': $e");
      return const TimeOfDay(hour: 9, minute: 0); // Fallback
    }
  }

  Future<void> _pickImage() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3826),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                child: Column(
                  children: [
                    CustomText(text: "Edit Services", fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
                    SizedBox(height: 20.h),

                    // Multi-Image Preview Section
                    _buildImageSection(),

                    SizedBox(height: 25.h),
                    _buildLabel("Services Name"),
                    _buildInputField(controller: nameController, hint: "Service Name"),

                    SizedBox(height: 15.h),
                    _buildLabel("Services Price"),
                    _buildInputField(controller: priceController, hint: "Price", isNumber: true),

                    SizedBox(height: 30.h),
                    _buildCalendarSection(),

                    SizedBox(height: 40.h),
                    Obx(() => CustomButton(
                      text: controller.isLoading.value ? "Updating..." : "Update Services",
                      onTap: controller.isLoading.value ? null : _handleUpdate,
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

  Widget _buildImageSection() {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add Button
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15.r)),
                  child: Icon(Icons.add_a_photo, color: const Color(0xFF1D3826)),
                ),
              ),
              // Existing Images from Server
              ...existingImages.map((img) => _imageThumbnail(img, isNetwork: true)),
              // New Selected Images
              ...newImages.map((file) => _imageThumbnail(file.path, isNetwork: false)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageThumbnail(String path, {required bool isNetwork}) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          margin: EdgeInsets.only(right: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: isNetwork
                ? CustomNetworkImage(imageUrl: "${ApiConstants.imageUrl}$path", fit: BoxFit.cover, height: 70, width: 70,)
                : Image.file(File(path), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 5, right: 15,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isNetwork ? existingImages.remove(path) : newImages.removeWhere((f) => f.path == path);
              });
            },
            child: CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget _buildCalendarSection() {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => _selectedDates.contains(DateTime(day.year, day.month, day.day)),
      calendarStyle: CalendarStyle(
        // Style for dates already in the database
        markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        selectedDecoration: const BoxDecoration(color: Color(0XFF1D3826), shape: BoxShape.circle),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        DateTime dayOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

        // 🔒 Lock Logic: If it was originally there, don't allow removing it
        if (_originalDates.contains(dayOnly)) {
          Get.snackbar("Notice", "Previous dates cannot be removed", snackPosition: SnackPosition.BOTTOM);
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
    );
  }

  void _handleUpdate() {
    // 1. Extract only the NEW dates
    List<String> newDatesOnly = _selectedDates
        .where((d) => !_originalDates.contains(d))
        .map((d) => d.toIso8601String())
        .toList();

    // 2. Build the Body
    final updateBody = BeauticianServiceUpdatePostBody(
      name: nameController.text.trim(),
      price: double.tryParse(priceController.text),
      description: descController.text.trim(),
      images: newImages,
      // Add this field to your PostBody class if you haven't yet
      // availableDates: newDatesOnly,
    );

    // 3. Call Controller
    controller.patchService(service.id, updateBody);
  }
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      backgroundColor: const Color(0xFF9BB575), // Moss Green header
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: CustomAppBar(title: "",showBackButton: true,bgColor: Colors.transparent,),

      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: CustomNetworkImage(
            imageUrl: AppAssets.appLogo, // Use your TNP logo
            height: 60.h,
            width: 140.w,
          ),
        ),
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller, // Add this
    bool isLarge = false,
    bool isNumber = false
  }) {
    return Container(
      height: isLarge ? 100.h : 45.h,
      decoration: BoxDecoration(
        color: const Color(0xFF9BB575).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: controller, // Use it here
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: isLarge ? 5 : 1,
        style: const TextStyle(color: Colors.white), // Ensure text is visible
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70, fontSize: 13.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: isLarge ? 10.h : 0),
        ),
      ),
    );
  }





  Widget _timeInputField(String value) {
    return Container(
      width: 50.w,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.geryColor.withValues(alpha:0.3)),
      ),
      child: CustomText(text: value, color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16.sp),
    );
  }


}