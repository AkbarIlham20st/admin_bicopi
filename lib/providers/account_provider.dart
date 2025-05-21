import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/admin_model.dart' as admin_model;
import '../models/affiliate_model.dart';
import '../services/user_service.dart';
import '../services/admin_service.dart';
import '../services/affiliate_service.dart';

class AccountProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final AdminService _adminService = AdminService();
  final AffiliateService _affiliateService = AffiliateService();

  List<UserModel> _users = [];
  List<admin_model.AdminModel> _admins = [];
  List<AffiliateModel> _affiliates = [];

  List<UserModel> get users => _users;
  List<admin_model.AdminModel> get admins => _admins;
  List<AffiliateModel> get affiliates => _affiliates;

  bool isLoading = false;
  String? error;

  Future<void> loadAllAccounts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _users = await _userService.fetchUsers();
      _admins = await _adminService.fetchAdmins();
      _affiliates = await _affiliateService.fetchAffiliates();
    } catch (e) {
      error = 'Gagal memuat data akun: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
