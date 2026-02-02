import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/accountController/initialBindings.dart';
import 'core/constants/app_pages.dart';
import 'core/utils/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Matching your UI layout
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(),
          title: 'Noire Hub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Use your AppColors here for consistency
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primaryDark,
            textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
          ),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}