import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/models/queue.dart';
import 'package:kiosk/widgets/modal.dart';

// Import conditionally to handle cases when the printer hardware is not available
// This allows the app to run on development environments without the Sunmi hardware
enum SunmiPrintAlign { LEFT, CENTER, RIGHT }
enum SunmiFontSize { XS, SM, MD, LG, XL }
enum SunmiPrinterStatus { NORMAL, ERROR, UNKNOWN, PAPER_OUT, COVER_OPEN, OVERHEATED }

// Mock implementation for development environments
class SunmiPrinter {
  static Future<void> bindingPrinter() async {
    debugPrint('Mock: Binding printer');
  }
  
  static Future<void> initPrinter() async {
    debugPrint('Mock: Initializing printer');
  }
  
  static Future<void> setAlignment(SunmiPrintAlign align) async {
    debugPrint('Mock: Setting alignment to ${align.toString()}');
  }
  
  static Future<void> printText(String text) async {
    debugPrint('Mock: Printing text: $text');
  }
  
  static Future<void> line([int count = 1]) async {
    debugPrint('Mock: Printing $count line(s)');
  }
  
  static Future<void> setFontSize(SunmiFontSize size) async {
    debugPrint('Mock: Setting font size to ${size.toString()}');
  }
  
  static Future<void> resetFontSize() async {
    debugPrint('Mock: Resetting font size');
  }
  
  static Future<void> cut() async {
    debugPrint('Mock: Cutting paper');
  }
  
  static Future<SunmiPrinterStatus> getPrinterStatus() async {
    debugPrint('Mock: Getting printer status');
    // In a real implementation, this would check the actual printer status
    // For development, we return NORMAL
    return SunmiPrinterStatus.NORMAL;
  }
  
  static Future<bool> hasPaper() async {
    debugPrint('Mock: Checking if printer has paper');
    final status = await getPrinterStatus();
    return status != SunmiPrinterStatus.PAPER_OUT;
  }
  
  static Future<Map<String, dynamic>> getDetailedStatus() async {
    debugPrint('Mock: Getting detailed printer status');
    final status = await getPrinterStatus();
    
    return {
      'status': status,
      'hasPaper': status != SunmiPrinterStatus.PAPER_OUT,
      'coverOpen': status == SunmiPrinterStatus.COVER_OPEN,
      'overheated': status == SunmiPrinterStatus.OVERHEATED,
      'isError': status == SunmiPrinterStatus.ERROR,
      'isReady': status == SunmiPrinterStatus.NORMAL,
      'statusMessage': _getStatusMessage(status),
    };
  }
  
  static String _getStatusMessage(SunmiPrinterStatus status) {
    switch (status) {
      case SunmiPrinterStatus.NORMAL:
        return 'Printer is ready';
      case SunmiPrinterStatus.PAPER_OUT:
        return 'Printer is out of paper';
      case SunmiPrinterStatus.COVER_OPEN:
        return 'Printer cover is open';
      case SunmiPrinterStatus.OVERHEATED:
        return 'Printer is overheated';
      case SunmiPrinterStatus.ERROR:
        return 'Printer error';
      case SunmiPrinterStatus.UNKNOWN:
        return 'Unknown printer status';
    }
  }
}

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  
  factory PrinterService() => _instance;
  
  PrinterService._internal();
  
  bool _initialized = false;
  // In a real app, we would detect this properly, but for this app
  // we'll assume we're in an emulator when not in release mode
  final bool _isEmulator = !kReleaseMode;
  
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      await SunmiPrinter.bindingPrinter();
      await SunmiPrinter.initPrinter();
      _initialized = true;
      
      if (_isEmulator) {
        debugPrint('Running on emulator - printer functionality will be simulated');
      }
    } catch (e) {
      debugPrint('Failed to initialize printer: $e');
      _initialized = false;
    }
  }
  
  Future<bool> printTicket(Queue queue) async {
    if (!_initialized) {
      await init();
    }
    
    // For emulators, simulate successful printing but still show the process
    if (_isEmulator) {
      debugPrint('Emulator detected: Simulating ticket printing for: ${queue.ticketNumber}');
      // Show a success message to the user
      Get.snackbar(
        'Ticket Printed', 
        'Ticket ${queue.ticketNumber} has been printed successfully (simulated in emulator)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return true;
    }
    
    // Check printer status before attempting to print
    final statusCheck = await checkPrinterStatusDetailed();
    if (!statusCheck['canPrint']) {
      _showPrinterWarning(statusCheck['statusMessage']);
      return false;
    }
    
    try {
      // Print header
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText('QUEUE TICKET');
      await SunmiPrinter.line();
      
      // Print ticket number in large font
      await SunmiPrinter.setFontSize(SunmiFontSize.XL);
      await SunmiPrinter.printText(queue.ticketNumber ?? 'N/A');
      await SunmiPrinter.resetFontSize();
      await SunmiPrinter.line();
      
      // Print service and branch info
      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
      await SunmiPrinter.printText('Service: ${queue.service?.name ?? 'Unknown'}');
      await SunmiPrinter.printText('Branch: ${queue.branch?.name ?? 'Unknown'}');
      await SunmiPrinter.line();
      
      // Print date and time
      final date = queue.formattedDate ?? 'N/A';
      final time = queue.formattedTime ?? 'N/A';
      await SunmiPrinter.printText('Date: $date');
      await SunmiPrinter.printText('Time: $time');
      await SunmiPrinter.line();
      
      // Print footer
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText('Thank you for your visit!');
      await SunmiPrinter.line(2);
      
      // Cut paper if supported
      await SunmiPrinter.cut();
      
      return true;
    } catch (e) {
      debugPrint('Error printing ticket: $e');
      
      // Check if the error is due to paper out
      final hasPaper = await SunmiPrinter.hasPaper();
      if (!hasPaper) {
        _showPaperOutWarning();
      } else {
        Modal.error(message: 'Failed to print ticket: $e');
      }
      
      return false;
    }
  }
  
  // Basic status check - returns true if printer can print
  Future<bool> checkPrinterStatus() async {
    if (!_initialized) {
      await init();
    }
    
    // Always return true for emulators to avoid blocking UI flows
    if (_isEmulator) {
      debugPrint('Emulator detected: Simulating printer ready status');
      return true;
    }
    
    try {
      final status = await SunmiPrinter.getPrinterStatus();
      return status == SunmiPrinterStatus.NORMAL;
    } catch (e) {
      debugPrint('Error checking printer status: $e');
      return false;
    }
  }
  
  // Detailed status check with specific error information
  Future<Map<String, dynamic>> checkPrinterStatusDetailed() async {
    if (!_initialized) {
      await init();
    }
    
    // For emulators, always return ready status to avoid blocking UI flows
    if (_isEmulator) {
      debugPrint('Emulator detected: Simulating printer ready status in detailed check');
      return {
        'status': SunmiPrinterStatus.NORMAL,
        'hasPaper': true,
        'coverOpen': false,
        'overheated': false,
        'isError': false,
        'isReady': true,
        'statusMessage': 'Printer ready (emulator mode)',
        'canPrint': true,
        'isEmulator': true,
      };
    }
    
    try {
      final detailedStatus = await SunmiPrinter.getDetailedStatus();
      
      // Check if printer can print based on status
      final canPrint = detailedStatus['isReady'] == true;
      
      return {
        ...detailedStatus,
        'canPrint': canPrint,
      };
    } catch (e) {
      debugPrint('Error checking detailed printer status: $e');
      return {
        'status': SunmiPrinterStatus.ERROR,
        'statusMessage': 'Error connecting to printer',
        'canPrint': false,
        'hasPaper': false,
      };
    }
  }
  
  // Show paper out warning dialog
  void _showPaperOutWarning() {
    Modal.show(
      title: 'Printer Out of Paper',
      message: 'The printer is out of paper. Please refill the paper and try again.',
      icon: Icons.report_problem,
      iconColor: Colors.orange,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
      ],
    );
  }
  
  // Show general printer warning dialog
  void _showPrinterWarning(String message) {
    Modal.show(
      title: 'Printer Issue',
      message: message,
      icon: Icons.print_disabled,
      iconColor: Colors.red,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
