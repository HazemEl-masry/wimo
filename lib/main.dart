import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/core/routing/app_router.dart';
import 'package:wimo/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: "Wimo",
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
