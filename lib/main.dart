import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/middleware/branch_middleware.dart';
import 'package:kiosk/screens/branch_code_screen.dart';
import 'package:kiosk/screens/not_authorize_screen.dart';
import 'package:kiosk/screens/print_screen.dart';
import 'package:kiosk/screens/services_screen.dart';
import 'package:kiosk/middleware/no_branch_middleware.dart';
import 'package:kiosk/core/getx/app_binding.dart';
import 'package:kiosk/screens/test_screen.dart';
import 'package:kiosk/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppBinding().dependencies();

  final kioskController = KioskController.instance;

  // Load branch code and wait for it to complete
  await kioskController.loadBranchCode();
  
  // Debug output to verify branch code state
  print('MAIN: Branch code loaded');
  print('MAIN: Branch code value: ${kioskController.branchCode.value}');
  print('MAIN: Branch code empty: ${kioskController.branchCode.value.isEmpty}');

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
    final kioskController = KioskController.instance;
    final bool hasBranchCode = kioskController.branchCode.value.isNotEmpty;
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      title: "Kiosk",
      getPages: [
        GetPage(
          name: '/branch-code',
          page: () => BranchCodeScreen(),
          middlewares: [
            // NoBranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/not-authorize',
          page: () => const NotAuthrizeScreen(),
          middlewares: [
            // BranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/services',
          page: () => const ServicesScreen(),
          middlewares: [
            // BranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/print',
          page: () => const PrintScreen(),
          middlewares: [
            // BranchMiddleware(),
          ],
        ),
        GetPage(
          name: '/test-page',
          page: () => const TestScreen(),
          middlewares: [
          
          ],
        ),
      ],
      
      initialRoute: '/test-page',
      // Don't use home when using initialRoute
      // home: BranchCodeScreen(),
    );
  }
}