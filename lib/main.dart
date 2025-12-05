import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/core/routing/app_router.dart';
import 'package:wimo/core/di/injection_container.dart' as di;
import 'package:wimo/core/services/websocket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Initialize WebSocket connection
  final webSocketService = di.sl<WebSocketService>();
  await webSocketService.connect();

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
