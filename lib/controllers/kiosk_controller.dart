import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/core/dio/dio_service.dart';
import 'package:kiosk/core/shared_preferences/shared_preference_manager.dart';
import 'package:kiosk/models/branch.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/queue.dart';
import 'package:kiosk/models/failure.dart';
import 'package:kiosk/services/printer_service.dart';
import 'package:kiosk/widgets/modal.dart';
import 'package:fpdart/fpdart.dart';

class KioskController extends GetxController {
  // Services screen state
  final services = <Service>[].obs;
  final isServicesLoading = true.obs;
  final hasServicesError = false.obs;
  
  // Print screen state
  final isQueueLoading = false.obs;
  final isPrinting = false.obs;
  final currentQueue = Rxn<Queue>();
  
  // Printer status variables
  final isPrinterReady = true.obs;
  final isPaperOut = false.obs;
  final printerStatusMessage = 'Checking printer...'.obs;
  final PrinterService _printerService = PrinterService();
  static KioskController instance = Get.find();

  final SharedPreferenceManager _storage = SharedPreferenceManager();
  final DioService _dio = DioService();

  var branchCode = ''.obs;
  Rxn<Branch> branch = Rxn<Branch>();
  var isLoading = false.obs;

  /// Load branch code from storage and validate it with the API
  /// This ensures we always have up-to-date branch data
  Future<void> loadBranchCode() async {
    final code = await _storage.getBranchCode();
    
    // If we have a stored branch code, validate it with the API
    if (code != null && code.isNotEmpty) {
      try {
        // First set the value from storage so middleware works
        branchCode.value = code;
        
        // Then validate with API and get fresh branch details
        final isValid = await checkBranch(code);
        
        if (!isValid) {
          // If branch code is no longer valid, clear it
          await clearBranchData();
          Get.offNamed('/branch-code');
        } else {
          // Get fresh branch details from API
          final branchResult = await getBranchDetails(code);
          branchResult.fold(
            (failure) async {
              // If API call fails, use cached data as fallback
              final branchMap = await _storage.getBranchModel();
              if (branchMap != null) {
                branch.value = Branch.fromMap(branchMap);
              }
            },
            (branchData) {
              // Update with fresh data from API
              branch.value = branchData;
              _storage.saveBranchModel(branchData.toMap());
            },
          );
        }
      } catch (e) {
        // If there's a network error, use cached data as fallback
        final branchMap = await _storage.getBranchModel();
        if (branchMap != null) {
          branch.value = Branch.fromMap(branchMap);
        } else {
          branch.value = null;
        }
      }
    } else {
      // No stored branch code
      branchCode.value = '';
      branch.value = null;
    }
  }


  Future<bool> checkBranch(String inputCode) async {
    final result = await _dio.request(
      path: "/check-branch",
      method: "POST",
      data: {"code": inputCode}, // Using 'code' as per API documentation
    );

    return result.fold(
      (failure) {
        Modal.error(message: failure.message);
        return false;
      },
      (response) async {
        final branchData = Branch.fromMap(response.data['data']);
        // Store both code + model
        await saveBranchCodeAndModel(inputCode, branchData);
        return true;
      },
    );
  }
  
  /// ✅ API: Get branch details by code
  /// Endpoint: GET /api/branch/{code}
  Future<Either<Failure, Branch>> getBranchDetails(String branchCode) async {
    final result = await _dio.request(
      path: "/branch/$branchCode",
      method: "GET",
    );
    
    return result.fold(
      (failure) => Left(failure),
      (response) {
        if (response.data['success'] == true && response.data['data'] != null) {
          final branchData = Branch.fromMap(response.data['data']);
          return Right(branchData);
        } else {
          return Left(Failure(
            message: response.data['message'] ?? 'Failed to get branch details',
          ));
        }
      },
    );
  }

  Future<void> saveBranchCodeAndModel(String code, Branch branchModel) async {
    await _storage.saveBranchCode(code);
    await _storage.saveBranchModel(branchModel.toMap());
    branchCode.value = code;
    branch.value = branchModel;
  }

  Future<void> clearBranchData() async {
    await _storage.removeBranchCode();
    await _storage.removeBranchModel();
    branchCode.value = '';
    branch.value = null;
  }
  
  /// Submit branch code and validate it
  /// If valid, navigate to services screen
  Future<void> submitBranchCode(String code) async {
    if (code.trim().isEmpty) return;
    
    isLoading.value = true;
    
    try {
      final success = await checkBranch(code.trim());
      
      if (success) {
        Get.offNamed('/services');
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<Either<Failure, List<Service>>> getServices(String branchCode) async {
    final result = await _dio.request(
      path: "/services/$branchCode",
      method: "GET",
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        if (response.data['success'] == true && response.data['data'] != null) {
          final List<dynamic> servicesJson = response.data['data'];
          final services = servicesJson.map((json) => Service.fromMap(json)).toList();
          return Right(services);
        } else {
          return Left(Failure(
            message: response.data['message'] ?? 'Failed to load services',
          ));
        }
      },
    );
  }

  /// Load services for a branch
  Future<void> loadServices() async {
    try {
      isServicesLoading.value = true;
      hasServicesError.value = false;
      
      final branchCode = this.branchCode.value;
      final result = await getServices(branchCode);
      
      result.fold(
        (failure) {
          hasServicesError.value = true;
          Modal.error(message: failure.message);
        },
        (servicesList) {
          services.assignAll(servicesList);
        },
      );
    } catch (e) {
      hasServicesError.value = true;
      Modal.error(message: 'Failed to load services. Please try again.');
    } finally {
      isServicesLoading.value = false;
    }
  }

  /// Select a service and navigate to print screen
  void selectService(Service service) {
    Get.toNamed('/print', arguments: service);
  }
  
  /// Get appropriate icon for a service based on its code
  IconData getIconForService(String? serviceCode) {
    if (serviceCode == null) return Icons.business;
    
    // Map service codes to appropriate icons
    switch (serviceCode.toUpperCase()) {
      case 'CS':
        return Icons.support_agent;
      case 'TS':
        return Icons.computer;
      case 'FIN':
        return Icons.attach_money;
      case 'HR':
        return Icons.people;
      default:
        return Icons.business_center;
    }
  }

  /// Create a queue ticket and handle printing
  Future<void> createQueueTicket(Service service) async {
    if (service.id == null) {
      Modal.error(message: 'Invalid service selected');
      Get.back();
      return;
    }

    isQueueLoading.value = true;

    final result = await createQueue(
      branchCode.value,
      service.id!,
    );

    isQueueLoading.value = false;

    result.fold(
      (failure) {
        Modal.error(message: failure.message);
        Get.back();
      },
      (queue) {
        currentQueue.value = queue;
        printTicket(queue);
      },
    );
  }

  /// Print a queue ticket
  Future<void> printTicket(Queue queue) async {
    try {
      isPrinting.value = true;
      
      // Initialize printer
      await _printerService.init();
      
      // Check printer status with detailed information
      final statusCheck = await _printerService.checkPrinterStatusDetailed();
      
      // If printer is not ready, show appropriate warning
      if (!statusCheck['canPrint']) {
        // Show specific warning based on status
        if (!statusCheck['hasPaper']) {
          // Paper out warning
          Modal.show(
            title: 'Printer Out of Paper',
            message: 'The printer is out of paper. Please refill the paper and try again.',
            icon: Icons.report_problem,
            iconColor: Colors.orange,
          );
        } else if (statusCheck['coverOpen']) {
          // Cover open warning
          Modal.show(
            title: 'Printer Cover Open',
            message: 'The printer cover is open. Please close it and try again.',
            icon: Icons.print_disabled,
            iconColor: Colors.red,
          );
        } else {
          // Generic printer error
          Modal.error(message: statusCheck['statusMessage'] ?? 'Printer not ready. Please check the printer.');
        }
        return;
      }
      
      // Print ticket
      final printResult = await _printerService.printTicket(queue);
      
      if (printResult) {
        Modal.success(
          title: 'Ticket Printed',
          message: 'Your ticket number is ${queue.ticketNumber}',
        );
      }
      // Note: If printing fails, the PrinterService will already show appropriate error messages
      
    } catch (e) {
      Modal.error(message: 'An error occurred while printing: $e');
    } finally {
      isPrinting.value = false;
    }
  }

  /// Get another ticket (return to services screen)
  void getNewTicket() {
    Get.back();
  }

  /// Change branch (go to branch code screen)
  void changeBranch() {
    Get.offAllNamed('/branch-code');
  }
  
  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  /// Format time for display
  String formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  /// Check printer status periodically
  Future<void> checkPrinterStatus() async {
    // Initial check
    await updatePrinterStatus();
    
    // Set up periodic check every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (Get.isRegistered<KioskController>()) {
        checkPrinterStatus();
      }
    });
  }
  
  /// Update printer status variables
  Future<void> updatePrinterStatus() async {
    try {
      final statusCheck = await _printerService.checkPrinterStatusDetailed();
      
      isPrinterReady.value = statusCheck['canPrint'] ?? false;
      isPaperOut.value = !(statusCheck['hasPaper'] ?? true);
      printerStatusMessage.value = statusCheck['statusMessage'] ?? 'Unknown printer status';
    } catch (e) {
      isPrinterReady.value = false;
      printerStatusMessage.value = 'Error connecting to printer';
    }
  }

  /// API: Create a queue ticket
  Future<Either<Failure, Queue>> createQueue(String branchCode, int serviceId) async {
    final result = await _dio.request(
      path: "/queue",
      method: "POST",
      data: {
        "branch_code": branchCode,
        "service_id": serviceId,
      },
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        if (response.data['success'] == true && response.data['data'] != null) {
          final queueData = Queue.fromMap(response.data['data']);
          return Right(queueData);
        } else {
          return Left(Failure(
            message: response.data['message'] ?? 'Failed to create queue ticket',
          ));
        }
      },
    );
  }
}
