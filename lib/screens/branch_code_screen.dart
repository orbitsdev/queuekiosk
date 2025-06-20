import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/utils/app_theme.dart';

class BranchCodeScreen extends StatelessWidget {
  BranchCodeScreen({ Key? key }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _kioskController = KioskController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiosk Setup'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business,
                    size: 80,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Enter Branch Code',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please enter your branch code to continue',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Branch Code',
                    hintText: 'e.g. BR001',
                    prefixIcon: Icon(Icons.code, color: primaryColor),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a branch code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                  onPressed: _kioskController.isLoading.value 
                    ? null 
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _kioskController.submitBranchCode(_codeController.text);
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _kioskController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text('CONTINUE', style: TextStyle(fontSize: 16)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}