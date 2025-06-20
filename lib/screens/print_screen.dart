import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/services/printer_service.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final _kioskController = KioskController.instance;
  late Service _service;
  final _printerService = PrinterService();
  
  // Printer status variables
  final RxBool _isPrinterReady = true.obs;
  final RxBool _isPaperOut = false.obs;
  final RxString _printerStatusMessage = 'Checking printer...'.obs;

  @override
  void initState() {
    super.initState();
    _service = Get.arguments as Service;
    _checkPrinterStatus();
    _kioskController.createQueueTicket(_service);
  }
  
  // Check printer status periodically
  Future<void> _checkPrinterStatus() async {
    // Initial check
    await _updatePrinterStatus();
    
    // Set up periodic check every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _checkPrinterStatus();
      }
    });
  }
  
  // Update printer status variables
  Future<void> _updatePrinterStatus() async {
    try {
      final statusCheck = await _printerService.checkPrinterStatusDetailed();
      
      _isPrinterReady.value = statusCheck['canPrint'] ?? false;
      _isPaperOut.value = !(statusCheck['hasPaper'] ?? true);
      _printerStatusMessage.value = statusCheck['statusMessage'] ?? 'Unknown printer status';
    } catch (e) {
      _isPrinterReady.value = false;
      _printerStatusMessage.value = 'Error connecting to printer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Information'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (_kioskController.isQueueLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Creating your ticket...',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        final queue = _kioskController.currentQueue.value;
        if (queue == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  'No ticket information available',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _kioskController.getNewTicket,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }

        // For Sunmi K2 kiosk, use a layout that's easy to interact with
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ticket icon with colored background
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.confirmation_number,
                              size: 80,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Ticket number (large and prominent)
                          Text(
                            queue.ticketNumber ?? 'N/A',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Service name
                          Text(
                            queue.service?.name ?? 'Unknown Service',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          // Branch name
                          Text(
                            queue.branch?.name ?? 'Unknown Branch',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          const Divider(thickness: 1.5),
                          const SizedBox(height: 24),
                          // Date and time info with larger text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date:',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                queue.formattedDate ?? _kioskController.formatDate(queue.createdDateTime),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time:',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                queue.formattedTime ?? _kioskController.formatTime(queue.createdDateTime),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status:',
                                style: theme.textTheme.titleMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  queue.status?.toUpperCase() ?? 'PENDING',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Printer status indicator
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isPrinterReady.value 
                        ? Colors.green.withOpacity(0.1) 
                        : _isPaperOut.value 
                            ? Colors.orange.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isPrinterReady.value 
                          ? Colors.green 
                          : _isPaperOut.value 
                              ? Colors.orange 
                              : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPrinterReady.value 
                            ? Icons.print 
                            : _isPaperOut.value 
                                ? Icons.report_problem 
                                : Icons.print_disabled,
                        color: _isPrinterReady.value 
                            ? Colors.green 
                            : _isPaperOut.value 
                                ? Colors.orange 
                                : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _printerStatusMessage.value,
                          style: TextStyle(
                            color: _isPrinterReady.value 
                                ? Colors.green 
                                : _isPaperOut.value 
                                    ? Colors.orange 
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isPaperOut.value)
                        TextButton.icon(
                          onPressed: _updatePrinterStatus,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Check Again'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                // Large, easy-to-tap buttons for kiosk use
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _kioskController.getNewTicket,
                        icon: const Icon(Icons.add, size: 28),
                        label: const Text('Get Another Ticket'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _kioskController.changeBranch,
                        icon: const Icon(Icons.swap_horiz, size: 28),
                        label: const Text('Change Branch'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}