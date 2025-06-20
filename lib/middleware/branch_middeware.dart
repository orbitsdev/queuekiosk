import 'package:get/get.dart';
import 'package:flutter/material.dart';


class BranchMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
  
    // If branch code is present, allow access
    return null;
  }
}
