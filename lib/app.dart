import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/bindings/initialBindings.dart';
import 'core/constants/app_colors.dart';
import 'core/routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. Optimized ScreenUtil setup
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'TNP Beauty',
          debugShowCheckedModeBanner: false,

          // 5. Global Bindings (Injects ApiClient, LocalStorage, etc.)
          initialBinding: InitialBinding(),

          theme: ThemeData(
            useMaterial3: true, // Recommended for modern Flutter apps
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primaryDark,
            // Consistency check: Ensure you use the same font throughout
            textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
          ),

          initialRoute: AppPages.initial,
          getPages: AppPages.routes,

          // 6. Default Transitions (Optional but makes app feel premium)
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}