import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/middleware/branch_middeware.dart';
import 'package:kiosk/screens/branch_code_screen.dart';
import 'package:kiosk/screens/not_authorize_screen.dart';
import 'package:kiosk/screens/print_screen.dart';
import 'package:kiosk/screens/services_screen.dart';
import 'package:kiosk/middleware/no_branch_middleware.dart';
import 'package:kiosk/core/getx/app_binding.dart';
import 'package:kiosk/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppBinding().dependencies();

  final kioscontroller = KioskController.instance;

  await kioscontroller.loadBranchCode();

  runApp(const KioskApp());
}

class KioskApp extends StatefulWidget {
  const KioskApp({ Key? key }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<KioskApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: "Kiosk",
      getPages: [
        GetPage(
          name: '/branch-code',
          page: () => const BranchCodeScreen(),
          middlewares: [
            NoBranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/not-authrize',
          page: () => const NotAuthrizeScreen(),
          middlewares: [
            BranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/services',
          page: () => const ServicesScreen(),
          middlewares: [
            BranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/print',
          page: () => const PrintScreen(),
          middlewares: [
            BranchMiddleware(),
          ],
        ),
      ],
      home: const BranchCodeScreen(),
    );
  }
}