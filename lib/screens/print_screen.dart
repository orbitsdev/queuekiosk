import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/models/service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_flutter/src/qr_versions.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final _kioskController = KioskController.instance;
  late Service _service;

  @override
  void initState() {
    super.initState();
    _service = Get.arguments as Service;
    _kioskController.checkPrinterStatus();
    _kioskController.createQueueTicket(_service);
  }
  
  // Show dialog to enter branch code
  void _showBranchCodeDialog() {
    final branchCodeController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Enter Branch Code',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: branchCodeController,
            decoration: const InputDecoration(
              labelText: 'Branch Code',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ],
      ),
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        final code = branchCodeController.text.trim();
        if (code.isNotEmpty) {
          Get.back();
          _kioskController.changeBranch();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: const Text('Ticket Information', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Get.defaultDialog(
                title: 'Kiosk Settings',
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.swap_horiz),
                      title: const Text('Change Branch Code'),
                      onTap: () {
                        Get.back();
                        _showBranchCodeDialog();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_kioskController.isQueueLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'Creating your ticket...',
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
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
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  'No ticket information available',
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _kioskController.getNewTicket,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
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
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // QR Code for ticket number
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: QrImageView(
                              // Use a URL format that includes the ticket number for better compatibility
                              // with Sunmi scanning systems - typically they expect a URL or structured data
                              data: 'https://queue.ticket/${queue.ticketNumber}',
                              version: QrVersions.auto,
                              size: 180,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.all(8),
                              // Optimize for Sunmi scanners with higher error correction
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                              // Add embeddedImage for branding if needed
                              // embeddedImage: const AssetImage('assets/images/logo_small.png'),
                              // embeddedImageStyle: QrEmbeddedImageStyle(
                              //   size: const Size(40, 40),
                              // ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Ticket number (large and prominent)
                          Text(
                            queue.ticketNumber ?? 'N/A',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Service name
                          Text(
                            queue.service?.name ?? 'Unknown Service',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Branch name
                          Text(
                            queue.branch?.name ?? 'Unknown Branch',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          const Divider(thickness: 1),
                          const SizedBox(height: 16),
                          // Date and time info with larger text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                queue.formattedDate ?? _kioskController.formatDate(queue.createdDateTime),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                queue.formattedTime ?? _kioskController.formatTime(queue.createdDateTime),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  queue.status?.toUpperCase() ?? 'PENDING',
                                  style: TextStyle(
                                    color: theme.primaryColor,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _kioskController.isPrinterReady.value 
                          ? Colors.green 
                          : _kioskController.isPaperOut.value 
                              ? Colors.orange 
                              : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _kioskController.isPrinterReady.value 
                            ? Icons.print 
                            : _kioskController.isPaperOut.value 
                                ? Icons.report_problem 
                                : Icons.print_disabled,
                        color: _kioskController.isPrinterReady.value 
                            ? Colors.green 
                            : _kioskController.isPaperOut.value 
                                ? Colors.orange 
                                : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _kioskController.printerStatusMessage.value,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_kioskController.isPaperOut.value)
                        TextButton.icon(
                          onPressed: _kioskController.updatePrinterStatus,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Check Again'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                          ),
                        ),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                // Large, easy-to-tap buttons for kiosk use
                ElevatedButton.icon(
                  onPressed: _kioskController.getNewTicket,
                  icon: const Icon(Icons.add, size: 28),
                  label: const Text('Get Another Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}