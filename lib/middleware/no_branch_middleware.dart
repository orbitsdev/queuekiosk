import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';

class NoBranchMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final kioskController = KioskController.instance;

    // If branchCode EXISTS, skip /branch-code and redirect to /services
    if (kioskController.branchCode.value.isNotEmpty) {
      return const RouteSettings(name: '/services');
    }

    // Otherwise allow
    return null;
  }
}
