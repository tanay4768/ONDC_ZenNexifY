import 'package:bazaar_to_go/view/on_boarding.dart';
import 'package:bazaar_to_go/view/product_upload/upload_product_screen.dart';
import 'package:bazaar_to_go/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Get the media query size
        final mediaQueryData = MediaQuery.of(context);
        final designSize =
            mediaQueryData.size.width > mediaQueryData.size.height
                ? const Size(800, 300)
                : const Size(300, 800);

        // Initialize ScreenUtil with the correct design size
        ScreenUtil.init(
          context,
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
        );

        return child!;
      },
    );
  }
}
