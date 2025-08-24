import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserModel();
        await _saveUserToPrefs();
      } else {
        _userModel = null;
        await _clearUserFromPrefs();
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserModel() async {
    if (_user != null) {
      try {
        _userModel = await _authService.getUserDocument(_user!.uid);
      } catch (e) {
        _error = e.toString();
      }
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String username, String displayName) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.registerWithEmailAndPassword(email, password, username, displayName);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAsGuest() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInAsGuest();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.updatePassword(newPassword);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.deleteAccount();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserModel(UserModel updatedUser) async {
    _userModel = updatedUser;
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    if (_user != null && _userModel != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userIdKey, _user!.uid);
      await prefs.setString(AppConstants.usernameKey, _userModel!.username);
      await prefs.setString(AppConstants.emailKey, _userModel!.email);
      await prefs.setBool(AppConstants.isLoggedInKey, true);
    }
  }

  Future<void> _clearUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.usernameKey);
    await prefs.remove(AppConstants.emailKey);
    await prefs.setBool(AppConstants.isLoggedInKey, false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}