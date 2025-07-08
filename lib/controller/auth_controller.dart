import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/service/api_service.dart';

class AuthController with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isUserLoaded = false;
  String? _authToken; 

  // Getter
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  String get userName => _user?.name ?? 'Guest';
  String get userEmail => _user?.email ?? '-';
  bool get isUserLoaded => _isUserLoaded;
  String? get authToken => _authToken; 

  // Load user from SharedPreferences
  Future<void> loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        final userData = json.decode(userDataString);
        _user = User.fromJson(userData);
        _isUserLoaded = true;
        debugPrint('AuthController: User loaded: ${_user?.name}');
      } else {
        _isUserLoaded = true; // tetap true agar UI tahu proses load selesai
      }
    } catch (e) {
      debugPrint('AuthController: Error loading user: $e');
      _user = null;
      _isUserLoaded = true;
    } finally {
      notifyListeners();
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ApiService.login(email, password);
      await _saveUserToPrefs(_user!);
      _isUserLoaded = true;
      return true;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register method
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ApiService.register(name, email, password);
      await _saveUserToPrefs(_user!);
      _isUserLoaded = true;
      return true;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.logout();
      _user = null;
      await _clearUserFromPrefs();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isUserLoaded = false;
      notifyListeners();
    }
  }

  // Update Profile
  Future<bool> updateProfile(String newName, {File? newProfilePicture}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user == null) throw Exception('User not logged in.');

      final updatedUserData = await ApiService.updateProfile(
        token: _user!.token!,
        name: newName,
        email: _user!.email,
        foto: newProfilePicture,
      );

      if (updatedUserData['data'] == null) {
        throw Exception('Data user tidak ditemukan dalam respons.');
      }

      _user = User.fromJson(updatedUserData['data']);
      await _saveUserToPrefs(_user!);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change Password
  Future<bool> changePassword(String currentPassword, String newPassword, String confirmNewPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user == null) {
        throw Exception('User tidak terautentikasi. Silakan login kembali.');
      }

      

      final updatedUserData = await ApiService.updateProfile(
        token: _user!.token!,
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmNewPassword, // Ini akan tetap dikirim ke API
      );

      if (updatedUserData['data'] == null) {
        throw Exception('Data user tidak ditemukan dalam respons update password.');
      }

      _user = User.fromJson(updatedUserData['data']);
      await _saveUserToPrefs(_user!);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
