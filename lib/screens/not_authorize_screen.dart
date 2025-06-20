import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';

class NotAuthrizeScreen extends StatefulWidget {
  const NotAuthrizeScreen({ Key? key }) : super(key: key);

  @override
  _NotAuthrizeScreenState createState() => _NotAuthrizeScreenState();
}

class _NotAuthrizeScreenState extends State<NotAuthrizeScreen> {
  final _kioskController = KioskController.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Authorized'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Branch Not Authorized',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This branch code is not authorized to use the kiosk system. Please contact your administrator for assistance.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await _kioskController.clearBranchData();
                  Get.offAllNamed('/branch-code');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Try Another Branch Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}