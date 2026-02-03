import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/services/cache_service.dart';
import 'app.dart';
import 'core/storage/local_storage.dart';

void main() async {
  // Ensure Flutter is ready before calling native code (SystemChrome/Storage)
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Storage/Cache first (Critical for Interceptors)
  await CacheService().init();
  await LocalStorage.init();

  // 2. Font Management
  GoogleFonts.config.allowRuntimeFetching = true;
  _preCacheFonts();

  // 3. UI Configuration
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );

  runApp(const MyApp());
}

// Separate font logic to keep main clean
Future<void> _preCacheFonts() async {
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.roboto(),
      GoogleFonts.outfit(), // You used Outfit in your theme below!
    ]);
  } catch (e) {
    debugPrint('Font pre-caching failed: $e');
  }
}

