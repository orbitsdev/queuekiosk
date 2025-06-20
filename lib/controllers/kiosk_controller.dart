import 'package:get/get.dart';
import 'package:kiosk/core/dio/dio_service.dart';
import 'package:kiosk/core/shared_preferences/shared_preference_manager.dart';
import 'package:kiosk/models/branch.dart';
import 'package:kiosk/widgets/modal.dart';

class KioskController extends GetxController {
  static KioskController instance = Get.find();

  final SharedPreferenceManager _storage = SharedPreferenceManager();
  final DioService _dio = DioService();

  var branchCode = ''.obs;
  Rxn<Branch> branch = Rxn<Branch>();

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

  /// ✅ API: Check branch code and store it if valid
  Future<bool> checkBranch(String inputCode) async {
    final result = await _dio.request(
      path: "/check-branch",
      method: "POST",
      data: {"branch_code": inputCode},
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
}
