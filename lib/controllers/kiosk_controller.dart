import 'package:get/get.dart';
import 'package:kiosk/core/shared_preferences/shared_preference_manager.dart';
import 'package:kiosk/models/branch.dart';

class KioskController extends GetxController {
  static KioskController instance = Get.find();

  final SharedPreferenceManager _storage = SharedPreferenceManager();

  var branchCode = ''.obs;
  Rxn<Branch> branch = Rxn<Branch>();

  /// Load branch code + branch model from local storage
  Future<void> loadBranchCode() async {
    final code = await _storage.getBranchCode();
    branchCode.value = code ?? '';

    final branchMap = await _storage.getBranchModel();
    if (branchMap != null) {
      branch.value = Branch.fromMap(branchMap);
    } else {
      branch.value = null;
    }
  }

  /// Save branch code + branch model after verifying API
  Future<void> saveBranchCodeAndModel(String code, Branch branchModel) async {
    await _storage.saveBranchCode(code);
    await _storage.saveBranchModel(branchModel.toMap());
    branchCode.value = code;
    branch.value = branchModel;
  }

  /// Clear everything when kiosk needs reset
  Future<void> clearBranchData() async {
    await _storage.removeBranchCode();
    await _storage.removeBranchModel();
    branchCode.value = '';
    branch.value = null;
  }
}
