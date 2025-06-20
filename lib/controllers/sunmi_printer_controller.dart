import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Controller for Sunmi printer operations
/// 
/// This controller manages printing operations for the Sunmi thermal printer
/// used in the kiosk application for printing guest receipts and test prints.
class SunmiPrinterController extends GetxController {
  static SunmiPrinterController instance = Get.find();

  // Receipt data
  final RxMap<String, dynamic> guest = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> roomNumber = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> roomType = <String, dynamic>{}.obs;
  final RxInt floorNumber = 0.obs;

  /// Print a kiosk receipt with guest check-in information
  Future<void> printGuestReceipt() async {
    try {
      // Initialize printer
      await _initPrinter();
      
      // Print logo
      await _printLogo();
      
      // Print header
      await _printHeader();
      
      // Print guest information
      await _printGuestInfo();
      
      // Print QR code
      await _printQRCode();
      
      // Print footer
      await _printFooter();
      
      // Finish printing
      await _finishPrinting();
    } catch (e) {
      print('Error printing receipt: $e');
    }
  }
  
  /// Print a test receipt to check printer functionality
  Future<void> testPrint() async {
    try {
      // Initialize printer
      await _initPrinter();
      
      // Print test content
      await _printTestContent();
      
      // Finish printing
      await _finishPrinting();
    } catch (e) {
      print('Error printing test receipt: $e');
    }
  }
  
  /// Initialize the printer
  Future<void> _initPrinter() async {
    // Implementation will depend on the actual Sunmi printer SDK
    print('Initializing printer...');
  }
  
  /// Print the logo
  Future<void> _printLogo() async {
    try {
      ByteData bytes = await rootBundle.load('assets/images/app_logo.png');
      // Using imageBytes in actual implementation
      Uint8List imageBytes = bytes.buffer.asUint8List();
      print('Printing logo with size: ${imageBytes.length} bytes');
    } catch (e) {
      print('Error loading logo: $e');
    }
  }
  
  /// Print receipt header
  Future<void> _printHeader() async {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    print('Printing header with date: $dateStr');
  }
  
  /// Print guest information
  Future<void> _printGuestInfo() async {
    print('Printing guest info:');
    print('Guest: ${guest['name']?.toString().toUpperCase() ?? 'N/A'}');
    print('Room: #${roomNumber['number'] ?? 'N/A'}');
    print('Floor: ${_getFloorLabel(floorNumber.value)}');
    print('Type: ${roomType['name']?.toString() ?? 'Standard'}');
    
    if (guest['check_in_date'] != null) {
      print('Check-in: ${guest['check_in_date']}');
    }
    
    if (guest['check_out_date'] != null) {
      print('Check-out: ${guest['check_out_date']}');
    }
  }
  
  /// Print QR code
  Future<void> _printQRCode() async {
    if (guest['qr_code'] != null) {
      print('Printing QR code: ${guest['qr_code']}');
    }
  }
  
  /// Print footer
  Future<void> _printFooter() async {
    print('Printing footer...');
  }
  
  /// Print test content
  Future<void> _printTestContent() async {
    print('Printing test content...');
    print('Date: ${DateTime.now().toString()}');
  }
  
  /// Finish printing
  Future<void> _finishPrinting() async {
    print('Finishing print job...');
  }

  /// Convert floor number to ordinal label (1st, 2nd, 3rd, etc.)
  String _getFloorLabel(int floor) {
    if (floor == 1) {
      return '1st';
    } else if (floor == 2) {
      return '2nd';
    } else if (floor == 3) {
      return '3rd';
    } else {
      return '${floor}th';
    }
  }
  
  /// Set guest information for printing
  void setGuestInfo({
    required Map<String, dynamic> guestData,
    required Map<String, dynamic> roomNumberData,
    required Map<String, dynamic> roomTypeData,
    required int floor,
  }) {
    guest.value = guestData;
    roomNumber.value = roomNumberData;
    roomType.value = roomTypeData;
    floorNumber.value = floor;
  }
}
