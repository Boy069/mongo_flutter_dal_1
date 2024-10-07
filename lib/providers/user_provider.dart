import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/models/user_models.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  // Getter สำหรับเข้าถึงข้อมูลผู้ใช้
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  // ฟังก์ชันสำหรับล็อกอิน
  void onLogin(UserModel userModel) async {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  }

  // ฟังก์ชันสำหรับล็อกเอาต์
  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
  // เพิ่มฟังก์ชันเพื่อตรวจสอบสถานะการล็อกอิน
  bool isLoggedIn() {
    return _user != null && _accessToken != null && _refreshToken != null;
  }

  void updateAccessToken(String accessToken) {
    _accessToken = accessToken;
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
    notifyListeners();
  }
}
