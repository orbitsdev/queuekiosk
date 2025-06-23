import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/models/queue.dart';
import 'package:kiosk/widgets/modal.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

/// Service to handle Sunmi printer operations
class PrinterService {
  // Singleton pattern implementation
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();
  
  // State variables
  bool _initialized = false;
  // In a real app, we would detect this properly, but for this app
  // we'll assume we're in an emulator when not in release mode
  final bool _isEmulator = !kReleaseMode;
  
  /// Initialize the printer
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      if (_isEmulator) {
        debugPrint('Running on emulator - printer functionality will be simulated');
        _initialized = true;
        return;
      }
      
      await SunmiPrinter.bindingPrinter();
      await SunmiPrinter.initPrinter();
      
      // Set default alignment to center for all printing operations
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      
      _initialized = true;
      debugPrint('Printer initialized successfully with center alignment');
    } catch (e) {
      debugPrint('Failed to initialize printer: $e');
      _initialized = false;
    }
  }
  
  /// Print a queue ticket
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
      _showPrinterWarning(statusCheck['statusMessage'] as String);
      return false;
    }
    
    try {
      // Reset printer settings to ensure clean state
      await SunmiPrinter.initPrinter();
      
      // Start transaction print - this is important for Sunmi printers
      await SunmiPrinter.startTransactionPrint(true);
      
      // Force center alignment for all content
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      
      // Add a small blank space at the top
      await SunmiPrinter.lineWrap(1);
      
      // Print header
      await SunmiPrinter.printText('YOUR NUMBER',
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.LG));
      
      // Print ticket number in extra large font
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setFontSize(SunmiFontSize.XL);
      await SunmiPrinter.printText('${queue.number ?? 'N/A'}',
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.XL));
      await SunmiPrinter.resetFontSize();
      
      // Print a note about the number
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.printText('Please wait for this number',
          style: SunmiStyle(bold: false, fontSize: SunmiFontSize.MD));
      
      // Print service and branch info
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Reinforce center alignment
      await SunmiPrinter.printText('${queue.service?.name ?? 'Unknown Service'}',
          style: SunmiStyle(bold: true));
      await SunmiPrinter.printText('${queue.branch?.name ?? 'Unknown Branch'}');
      
      // Print Ticket ID in smaller text
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Reinforce center alignment
      await SunmiPrinter.printText('ID: ${queue.ticketNumber ?? 'N/A'}',
          style: SunmiStyle(fontSize: SunmiFontSize.SM));
      
      // Print date and time
      await SunmiPrinter.lineWrap(1);
      final date = queue.formattedDate ?? formatDate(queue.createdDateTime);
      final time = queue.formattedTime ?? formatTime(queue.createdDateTime);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Reinforce center alignment
      await SunmiPrinter.printText('$date  $time');
      
      // Print QR code
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Critical for QR code centering
      // Use a smaller QR code size for better centering
      await SunmiPrinter.printQRCode('https://queue.ticket/${queue.ticketNumber}', 
          size: 5, // Smaller size for better centering
          errorLevel: SunmiQrcodeLevel.LEVEL_H);
      
      // Print footer
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Reinforce center alignment
      await SunmiPrinter.printText('Thank you for your visit!',
          style: SunmiStyle(bold: false, fontSize: SunmiFontSize.MD));
      
      // Add a small blank space at the bottom before cutting
      await SunmiPrinter.lineWrap(1);
      
      // Cut paper if supported
      await SunmiPrinter.cut();
      
      // End transaction print
      await SunmiPrinter.exitTransactionPrint(true);
      
      return true;
    } catch (e) {
      debugPrint('Error printing ticket: $e');
      
      // Check if the error is due to paper out
      final paperSize = await SunmiPrinter.paperSize();
      if (paperSize <= 0) {
        _showPaperOutWarning();
      } else {
        Modal.error(message: 'Failed to print ticket: $e');
      }
      
      return false;
    }
  }
  
  /// Format date from DateTime
  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  
  /// Format time from DateTime
  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// Basic status check - returns true if printer can print
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
      return status == PrinterStatus.NORMAL;
    } catch (e) {
      debugPrint('Error checking printer status: $e');
      return false;
    }
  }
  
  /// Detailed status check with specific error information
  Future<Map<String, dynamic>> checkPrinterStatusDetailed() async {
    if (!_initialized) {
      await init();
    }
    
    // For emulators, always return ready status to avoid blocking UI flows
    if (_isEmulator) {
      debugPrint('Emulator detected: Simulating printer ready status in detailed check');
      return {
        'status': PrinterStatus.NORMAL,
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
      final status = await SunmiPrinter.getPrinterStatus();
      final paperSize = await SunmiPrinter.paperSize();
      final hasPaper = paperSize > 0;
      
      // Check if printer can print based on status
      final isReady = status == PrinterStatus.NORMAL;
      final canPrint = isReady && hasPaper;
      
      String statusMessage = 'Printer ready';
      bool coverOpen = false;
      bool overheated = false;
      bool isError = false;
      
      switch (status) {
        case PrinterStatus.ERROR:
          statusMessage = 'Printer error';
          isError = true;
          break;
        case PrinterStatus.ABNORMAL_COMMUNICATION:
          statusMessage = 'Printer communication error';
          isError = true;
          break;
        case PrinterStatus.OUT_OF_PAPER:
          statusMessage = 'Printer out of paper';
          break;
        case PrinterStatus.PREPARING:
          statusMessage = 'Printer preparing';
          break;
        case PrinterStatus.OVERHEATED:
          statusMessage = 'Printer overheated';
          overheated = true;
          break;
        case PrinterStatus.OPEN_THE_LID:
          statusMessage = 'Printer cover open';
          coverOpen = true;
          break;
        case PrinterStatus.PAPER_CUTTER_ABNORMAL:
          statusMessage = 'Paper cutter abnormal';
          isError = true;
          break;
        case PrinterStatus.PAPER_CUTTER_RECOVERED:
          statusMessage = 'Paper cutter recovered';
          break;
        case PrinterStatus.NO_BLACK_MARK:
          statusMessage = 'No black mark detected';
          break;
        case PrinterStatus.NO_PRINTER_DETECTED:
          statusMessage = 'No printer detected';
          isError = true;
          break;
        case PrinterStatus.FAILED_TO_UPGRADE_FIRMWARE:
          statusMessage = 'Failed to upgrade firmware';
          isError = true;
          break;
        case PrinterStatus.EXCEPTION:
          statusMessage = 'Printer exception';
          isError = true;
          break;
        case PrinterStatus.UNKNOWN:
          statusMessage = 'Unknown printer status';
          isError = true;
          break;
        case PrinterStatus.NORMAL:
          statusMessage = 'Printer ready';
          break;
      }
      
      if (!hasPaper) {
        statusMessage = 'Printer out of paper';
      }
      
      return {
        'status': status,
        'hasPaper': hasPaper,
        'coverOpen': coverOpen,
        'overheated': overheated,
        'isError': isError,
        'isReady': isReady,
        'statusMessage': statusMessage,
        'canPrint': canPrint,
      };
    } catch (e) {
      debugPrint('Error checking detailed printer status: $e');
      return {
        'status': PrinterStatus.UNKNOWN,
        'hasPaper': false,
        'coverOpen': false,
        'overheated': false,
        'isError': true,
        'isReady': false,
        'statusMessage': 'Failed to check printer: $e',
        'canPrint': false,
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
