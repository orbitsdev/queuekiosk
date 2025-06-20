import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Modal {
  /// ✅ Show success modal with animation
  static void success({
    String title = "Success",
    String message = "Operation completed successfully",
    String okLabel = "OK",
    VoidCallback? onOk,
  }) {
    Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: okLabel,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        if (onOk != null) onOk();
      },
    );
  }

  /// ✅ Show error modal with animation
  static void error({
    String title = "Error",
    String message = "Operation failed",
    String okLabel = "OK",
    VoidCallback? onOk,
  }) {
    Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/error.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: okLabel,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        if (onOk != null) onOk();
      },
    );
  }

  /// ✅ Show confirm modal with animation
  static void confirm({
    String title = "Confirm",
    String message = "Are you sure you want to perform this action?",
    String okLabel = "OK",
    String cancelLabel = "Cancel",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/questionmark.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: okLabel,
      textCancel: cancelLabel,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        if (onConfirm != null) onConfirm();
      },
      onCancel: () {
        if (onCancel != null) onCancel();
      },
    );
  }

  /// Show a custom modal dialog with icon and custom actions
  static void show({
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    List<Widget>? actions,
    VoidCallback? onClose,
  }) {
    Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 80,
              color: iconColor ?? Colors.blue,
            ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: actions,
      onWillPop: () async {
        if (onClose != null) onClose();
        return true;
      },
    );
  }
}
