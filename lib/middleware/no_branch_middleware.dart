import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';

class NoBranchMiddleware extends GetMiddleware {
  @override
  int? priority = 2; // Lower priority than BranchMiddleware
  
  @override
  RouteSettings? redirect(String? route) {
    final kioskController = KioskController.instance;
    print('NO BRANCH MIDDLEWARE for route: $route');
    print('Branch code empty: ${kioskController.branchCode.value.isEmpty}');
    print('Branch code value: ${kioskController.branchCode.value}');
    
    // If branchCode EXISTS, skip /branch-code and redirect to /services
    if (kioskController.branchCode.value.isNotEmpty) {
      print('Redirecting to /services from $route');
      return const RouteSettings(name: '/test-page');
      // return const RouteSettings(name: '/services');
    }

    // Otherwise allow
    print('Allowing route: $route');
    return null;
  }
}
