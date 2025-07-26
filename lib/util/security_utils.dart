import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Security utilities for the Gadget Security app
class SecurityUtils {
  
  /// Generates a secure salt for password hashing
  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }
  
  /// Hashes a password with salt using SHA-256
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Verifies a password against its hash
  static bool verifyPassword(String password, String hash, String salt) {
    final hashedInput = hashPassword(password, salt);
    return hashedInput == hash;
  }
  
  /// Validates email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  /// Validates phone number format (international)
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
  
  /// Validates password strength
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }
  
  /// Sanitizes input to prevent XSS and injection attacks
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'[<>"\']'), '') // Remove dangerous characters
        .trim();
  }
  
  /// Validates government ID format (basic numeric check)
  static bool isValidGovernmentId(String id) {
    final idRegex = RegExp(r'^\d{8,15}$'); // 8-15 digits
    return idRegex.hasMatch(id);
  }
  
  /// Generates a secure PIN with the specified length
  static String generateSecurePin(int length) {
    final random = Random.secure();
    return List.generate(length, (index) => random.nextInt(10)).join();
  }
  
  /// Rate limiting helper - tracks login attempts
  static final Map<String, List<DateTime>> _loginAttempts = {};
  
  /// Checks if user has exceeded login attempt limit
  static bool isRateLimited(String identifier, {int maxAttempts = 5, Duration window = const Duration(minutes: 15)}) {
    final now = DateTime.now();
    final attempts = _loginAttempts[identifier] ?? [];
    
    // Remove old attempts outside the window
    attempts.removeWhere((attempt) => now.difference(attempt) > window);
    _loginAttempts[identifier] = attempts;
    
    return attempts.length >= maxAttempts;
  }
  
  /// Records a login attempt
  static void recordLoginAttempt(String identifier) {
    final attempts = _loginAttempts[identifier] ?? [];
    attempts.add(DateTime.now());
    _loginAttempts[identifier] = attempts;
  }
  
  /// Clears login attempts for a user (on successful login)
  static void clearLoginAttempts(String identifier) {
    _loginAttempts.remove(identifier);
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? error;
  
  ValidationResult(this.isValid, [this.error]);
  
  static ValidationResult valid() => ValidationResult(true);
  static ValidationResult invalid(String error) => ValidationResult(false, error);
}

/// Input validator class for form validation
class InputValidator {
  
  /// Validates user registration data
  static ValidationResult validateRegistration({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String phone,
    required String governmentId,
  }) {
    // Sanitize inputs
    name = SecurityUtils.sanitizeInput(name);
    surname = SecurityUtils.sanitizeInput(surname);
    email = SecurityUtils.sanitizeInput(email);
    
    // Validate individual fields
    if (name.isEmpty || name.length < 2) {
      return ValidationResult.invalid("Name must be at least 2 characters long");
    }
    
    if (surname.isEmpty || surname.length < 2) {
      return ValidationResult.invalid("Surname must be at least 2 characters long");
    }
    
    if (!SecurityUtils.isValidEmail(email)) {
      return ValidationResult.invalid("Please enter a valid email address");
    }
    
    if (!SecurityUtils.isStrongPassword(password)) {
      return ValidationResult.invalid("Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters");
    }
    
    if (!SecurityUtils.isValidPhoneNumber(phone)) {
      return ValidationResult.invalid("Please enter a valid phone number");
    }
    
    if (!SecurityUtils.isValidGovernmentId(governmentId)) {
      return ValidationResult.invalid("Government ID must be 8-15 digits");
    }
    
    return ValidationResult.valid();
  }
  
  /// Validates login data
  static ValidationResult validateLogin({
    required String email,
    required String password,
  }) {
    email = SecurityUtils.sanitizeInput(email);
    
    if (!SecurityUtils.isValidEmail(email)) {
      return ValidationResult.invalid("Please enter a valid email address");
    }
    
    if (password.isEmpty) {
      return ValidationResult.invalid("Password cannot be empty");
    }
    
    return ValidationResult.valid();
  }
}