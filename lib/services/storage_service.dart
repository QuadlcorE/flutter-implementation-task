import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Local Storage Service using SharedPreferences
/// Handles persistent storage for auth tokens, user data, etc.
class StorageService {
  SharedPreferences? _prefs;
  
  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyIsLoggedIn = 'is_logged_in';
  
  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('💾 Storage service initialized');
  }
  
  /// Save authentication token
  Future<bool> saveAuthToken(String token) async {
    try {
      final result = await _prefs?.setString(_keyAuthToken, token) ?? false;
      debugPrint('💾 Auth token saved: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error saving auth token: $e');
      return false;
    }
  }
  
  /// Get authentication token
  String? getAuthToken() {
    return _prefs?.getString(_keyAuthToken);
  }
  
  /// Check if auth token exists
  bool hasAuthToken() {
    final token = getAuthToken();
    return token != null && token.isNotEmpty;
  }
  
  /// Save user data
  Future<bool> saveUserData({
    required String userId,
    required String email,
    String? name,
  }) async {
    try {
      await _prefs?.setString(_keyUserId, userId);
      await _prefs?.setString(_keyUserEmail, email);
      if (name != null) {
        await _prefs?.setString(_keyUserName, name);
      }
      await _prefs?.setBool(_keyIsLoggedIn, true);
      
      debugPrint('💾 User data saved: $email');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
      return false;
    }
  }
  
  /// Get user ID
  String? getUserId() {
    return _prefs?.getString(_keyUserId);
  }
  
  /// Get user email
  String? getUserEmail() {
    return _prefs?.getString(_keyUserEmail);
  }
  
  /// Get user name
  String? getUserName() {
    return _prefs?.getString(_keyUserName);
  }
  
  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }
  
  /// Clear all authentication data (logout)
  Future<bool> clearAuthData() async {
    try {
      await _prefs?.remove(_keyAuthToken);
      await _prefs?.remove(_keyUserId);
      await _prefs?.remove(_keyUserEmail);
      await _prefs?.remove(_keyUserName);
      await _prefs?.setBool(_keyIsLoggedIn, false);
      
      debugPrint('💾 Auth data cleared');
      return true;
    } catch (e) {
      debugPrint('❌ Error clearing auth data: $e');
      return false;
    }
  }
  
  /// Save any string value
  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }
  
  /// Get any string value
  String? getString(String key) {
    return _prefs?.getString(key);
  }
  
  /// Save any boolean value
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }
  
  /// Get any boolean value
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  /// Save any integer value
  Future<bool> saveInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }
  
  /// Get any integer value
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }
  
  /// Save JSON object
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    try {
      final jsonString = jsonEncode(json);
      return await saveString(key, jsonString);
    } catch (e) {
      debugPrint('❌ Error saving JSON: $e');
      return false;
    }
  }
  
  /// Get JSON object
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error reading JSON: $e');
      return null;
    }
  }
  
  /// Remove a specific key
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }
  
  /// Clear all stored data
  Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }
  
  /// Check if a key exists
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
}