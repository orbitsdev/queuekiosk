
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/controllers/sunmi_printer_controller.dart';
  
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KioskController(), permanent: true);
    Get.put(SunmiPrinterController(), permanent: true);
  }
}
