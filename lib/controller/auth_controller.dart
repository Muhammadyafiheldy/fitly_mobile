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
  // String? _authToken; // Token sekarang dikelola di ApiService dan SharedPreferences

  // Getter
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  String get userName => _user?.name ?? 'Guest';
  String get userEmail => _user?.email ?? '-';
  bool get isUserLoaded => _isUserLoaded;
  // String? get authToken => _authToken; // Tidak perlu getter ini lagi

  // Load user from SharedPreferences
  Future<void> loadUserFromPrefs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      final token = prefs.getString('auth_token'); // Dapatkan token
      if (userDataString != null && token != null) { // Pastikan token juga ada
        final userData = json.decode(userDataString);
        _user = User.fromJson(userData).copyWith(token: token); // Tambahkan token saat load
        _isUserLoaded = true;
        debugPrint('AuthController: User loaded: ${_user?.name}');
      } else {
        _user = null;
        _isUserLoaded = true; // tetap true agar UI tahu proses load selesai
      }
    } catch (e) {
      debugPrint('AuthController: Error loading user: $e');
      _user = null;
      _isUserLoaded = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    // Token sudah disimpan oleh ApiService, jadi tidak perlu disimpan di sini lagi
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('auth_token'); // Hapus token juga
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
  Future<bool> updateProfile(String newName, {String? newEmail, File? newProfilePicture}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user == null) throw Exception('User not logged in.');

      final updatedResponse = await ApiService.updateProfile(
        name: newName,
        email: newEmail, // Mengirim email jika ada perubahan
        foto: newProfilePicture,
      );

      if (updatedResponse['data'] == null) {
        throw Exception('Data user tidak ditemukan dalam respons.');
      }

      // Pastikan token tetap ada setelah update, karena API tidak mengembalikannya
      final newUser = User.fromJson(updatedResponse['data']).copyWith(token: _user!.token);
      _user = newUser;
      await _saveUserToPrefs(_user!);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Error updating profile: $_errorMessage');
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

      // Validasi frontend untuk konfirmasi password
      if (newPassword != confirmNewPassword) {
        throw Exception('Konfirmasi password baru tidak cocok.');
      }
      if (newPassword.length < 8) {
        throw Exception('Password baru minimal 8 karakter.');
      }

      final updatedResponse = await ApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmNewPassword,
      );

      // Backend hanya mengembalikan pesan sukses dan data user, token tidak berubah.
      // Jika Anda tidak ingin user logout setelah ganti password, tidak perlu update _user di sini
      // atau hanya update field password (yang tidak ada di model User)
      if (updatedResponse['data'] != null) {
          // Hanya update data user yang bisa berubah, token tetap
          _user = User.fromJson(updatedResponse['data']).copyWith(token: _user!.token);
          await _saveUserToPrefs(_user!);
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Error changing password: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}