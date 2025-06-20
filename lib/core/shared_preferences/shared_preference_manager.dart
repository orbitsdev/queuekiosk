import 'dart:convert'; // for jsonEncode, jsonDecode
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static const String _branchCodeKey = 'branch_code';
  static const String _branchModelKey = 'branch_model';

  /// Save branch code only
  Future<void> saveBranchCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_branchCodeKey, code);
  }

  /// Get branch code
  Future<String?> getBranchCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_branchCodeKey);
  }

  /// Remove branch code
  Future<void> removeBranchCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_branchCodeKey);
  }

  /// Save the whole Branch model as JSON string
  Future<void> saveBranchModel(Map<String, dynamic> branchMap) async {
    final prefs = await SharedPreferences.getInstance();
    final branchJson = jsonEncode(branchMap);
    await prefs.setString(_branchModelKey, branchJson);
  }

  /// Get the Branch model as decoded Map
  Future<Map<String, dynamic>?> getBranchModel() async {
    final prefs = await SharedPreferences.getInstance();
    final branchJson = prefs.getString(_branchModelKey);
    if (branchJson == null) return null;
    return jsonDecode(branchJson);
  }

  /// Remove Branch model
  Future<void> removeBranchModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_branchModelKey);
  }
}
