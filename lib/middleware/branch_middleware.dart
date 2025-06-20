import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';

class BranchMiddleware extends GetMiddleware {
  @override
  int? priority = 1; // Higher priority executes first
  
  @override
  RouteSettings? redirect(String? route) {
    final kioskController = KioskController.instance;

    print('BRANCH MIDDLEWARE for route: $route');
    print('Branch code empty: ${kioskController.branchCode.value.isEmpty}');
    print('Branch code value: ${kioskController.branchCode.value}');

    // If NO branchCode, redirect to /branch-code
    if (kioskController.branchCode.value.isEmpty) {
      print('Redirecting to /branch-code from $route');
      return const RouteSettings(name: '/branch-code');
    }

    // Otherwise allow
    print('Allowing route: $route');
    return null;
  }
}
