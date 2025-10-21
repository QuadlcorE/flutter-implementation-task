import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_implementation_task/services/storage_service.dart';

/// Authentication Logic Controller
/// Manages user authentication state and operations
class AuthLogic extends ChangeNotifier {
  final StorageService _storage = GetIt.I.get<StorageService>();
  
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  
  String? _userId;
  String? get userId => _userId;
  
  String? _userEmail;
  String? get userEmail => _userEmail;
  
  String? _userName;
  String? get userName => _userName;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  /// Check authentication status on app startup
  Future<void> checkAuthStatus() async {
    try {
      debugPrint('🔐 Checking auth status...');
      
      final isLoggedIn = _storage.isLoggedIn();
      final hasToken = _storage.hasAuthToken();
      
      if (isLoggedIn && hasToken) {
        _userId = _storage.getUserId();
        _userEmail = _storage.getUserEmail();
        _userName = _storage.getUserName();
        _isAuthenticated = true;
        
        debugPrint('✅ User is authenticated: $_userEmail');
      } else {
        _isAuthenticated = false;
        debugPrint('❌ User is not authenticated');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error checking auth status: $e');
      _isAuthenticated = false;
      notifyListeners();
    }
  }
  
  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      debugPrint('🔐 Attempting login for: $email');
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': email, 'password': password}),
      // );
      
      // For demo purposes, accept any login with valid format
      if (email.isNotEmpty && password.length >= 6) {
        // Simulate successful login
        final fakeToken = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
        final fakeUserId = 'user_${email.hashCode}';
        
        // Save to storage
        await _storage.saveAuthToken(fakeToken);
        await _storage.saveUserData(
          userId: fakeUserId,
          email: email,
          name: email.split('@')[0],
        );
        
        // Update state
        _isAuthenticated = true;
        _userId = fakeUserId;
        _userEmail = email;
        _userName = email.split('@')[0];
        
        debugPrint('✅ Login successful');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Sign up with email and password
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      debugPrint('🔐 Attempting signup for: $email');
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/signup'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': email, 'password': password, 'name': name}),
      // );
      
      // For demo purposes, accept any signup with valid format
      if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
        // Simulate successful signup
        final fakeToken = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
        final fakeUserId = 'user_${email.hashCode}';
        
        // Save to storage
        await _storage.saveAuthToken(fakeToken);
        await _storage.saveUserData(
          userId: fakeUserId,
          email: email,
          name: name,
        );
        
        // Update state
        _isAuthenticated = true;
        _userId = fakeUserId;
        _userEmail = email;
        _userName = name;
        
        debugPrint('✅ Signup successful');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid signup data';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('❌ Signup error: $e');
      _errorMessage = 'Signup failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Logout user
  Future<void> logout() async {
    try {
      debugPrint('🔐 Logging out...');
      
      // Clear storage
      await _storage.clearAuthData();
      
      // Clear state
      _isAuthenticated = false;
      _userId = null;
      _userEmail = null;
      _userName = null;
      _errorMessage = null;
      
      debugPrint('✅ Logout successful');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Logout error: $e');
    }
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Validate token (check if still valid)
  Future<bool> validateToken() async {
    try {
      final token = _storage.getAuthToken();
      if (token == null) return false;
      
      // TODO: Call API to validate token
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/validate'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      
      // For demo, assume token is valid if it exists
      return true;
    } catch (e) {
      debugPrint('❌ Token validation error: $e');
      return false;
    }
  }
  
  /// Update user profile
  Future<bool> updateProfile({String? name, String? email}) async {
    try {
      // TODO: Call API to update profile
      
      // Update local state
      if (name != null) {
        _userName = name;
        await _storage.saveUserData(
          userId: _userId!,
          email: _userEmail!,
          name: name,
        );
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Profile update error: $e');
      return false;
    }
  }
}