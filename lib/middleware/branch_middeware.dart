import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';

class BranchMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final kioskController = KioskController.instance;

    // If NO branchCode, redirect to /branch-code
    if (kioskController.branchCode.value.isEmpty) {
      // return const RouteSettings(name: '/branch-code');
      return const RouteSettings(name: '/test-page');
    }

    // Otherwise allow
    return null;
  }
}
