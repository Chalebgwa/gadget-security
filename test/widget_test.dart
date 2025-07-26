// Gadget Security App Widget Tests
//
// Tests for the Gadget Security application functionality
// including authentication, security features, and device management.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsec/main.dart';
import 'package:gsec/util/security_utils.dart';

void main() {
  group('Gadget Security App Tests', () {
    
    testWidgets('App should load without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());
      
      // Verify that the app loads without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show correct title', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      
      // Get the MaterialApp widget and check its title
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Gadget Security');
    });
  });

  group('Security Utils Tests', () {
    
    test('Password hashing should be consistent', () {
      const password = 'TestPassword123!';
      const salt = 'testSalt';
      
      final hash1 = SecurityUtils.hashPassword(password, salt);
      final hash2 = SecurityUtils.hashPassword(password, salt);
      
      expect(hash1, equals(hash2));
      expect(hash1, isNotEmpty);
    });

    test('Password verification should work correctly', () {
      const password = 'TestPassword123!';
      const salt = 'testSalt';
      const wrongPassword = 'WrongPassword456!';
      
      final hash = SecurityUtils.hashPassword(password, salt);
      
      expect(SecurityUtils.verifyPassword(password, hash, salt), isTrue);
      expect(SecurityUtils.verifyPassword(wrongPassword, hash, salt), isFalse);
    });

    test('Email validation should work correctly', () {
      expect(SecurityUtils.isValidEmail('test@example.com'), isTrue);
      expect(SecurityUtils.isValidEmail('user.name@domain.co.uk'), isTrue);
      expect(SecurityUtils.isValidEmail('invalid-email'), isFalse);
      expect(SecurityUtils.isValidEmail('missing@domain'), isFalse);
      expect(SecurityUtils.isValidEmail('@missinguser.com'), isFalse);
    });

    test('Phone validation should work correctly', () {
      expect(SecurityUtils.isValidPhoneNumber('+1234567890'), isTrue);
      expect(SecurityUtils.isValidPhoneNumber('+44 123 456 7890'), isTrue);
      expect(SecurityUtils.isValidPhoneNumber('1234567890'), isTrue);
      expect(SecurityUtils.isValidPhoneNumber('invalid-phone'), isFalse);
      expect(SecurityUtils.isValidPhoneNumber('123'), isFalse);
    });

    test('Strong password validation should work correctly', () {
      expect(SecurityUtils.isStrongPassword('StrongPass123!'), isTrue);
      expect(SecurityUtils.isStrongPassword('Aa1!'), isFalse); // Too short
      expect(SecurityUtils.isStrongPassword('weakpassword'), isFalse); // No uppercase, numbers, special chars
      expect(SecurityUtils.isStrongPassword('STRONGPASSWORD'), isFalse); // No lowercase, numbers, special chars
      expect(SecurityUtils.isStrongPassword('StrongPassword'), isFalse); // No numbers, special chars
      expect(SecurityUtils.isStrongPassword('StrongPass123'), isFalse); // No special chars
    });

    test('Input sanitization should remove dangerous content', () {
      expect(SecurityUtils.sanitizeInput('<script>alert("xss")</script>'), 
             equals('alert("xss")'));
      expect(SecurityUtils.sanitizeInput('Normal text'), 
             equals('Normal text'));
      expect(SecurityUtils.sanitizeInput('<div>content</div>'), 
             equals('content'));
      expect(SecurityUtils.sanitizeInput('Text with "quotes" and \'apostrophes\''), 
             equals('Text with quotes and apostrophes'));
    });

    test('Government ID validation should work correctly', () {
      expect(SecurityUtils.isValidGovernmentId('12345678'), isTrue);
      expect(SecurityUtils.isValidGovernmentId('123456789012345'), isTrue);
      expect(SecurityUtils.isValidGovernmentId('1234567'), isFalse); // Too short
      expect(SecurityUtils.isValidGovernmentId('1234567890123456'), isFalse); // Too long
      expect(SecurityUtils.isValidGovernmentId('12345abc'), isFalse); // Non-numeric
    });

    test('Secure PIN generation should work correctly', () {
      final pin4 = SecurityUtils.generateSecurePin(4);
      final pin6 = SecurityUtils.generateSecurePin(6);
      
      expect(pin4.length, equals(4));
      expect(pin6.length, equals(6));
      expect(RegExp(r'^\d+$').hasMatch(pin4), isTrue); // Only digits
      expect(RegExp(r'^\d+$').hasMatch(pin6), isTrue); // Only digits
      
      // PINs should be different each time
      final pin4Second = SecurityUtils.generateSecurePin(4);
      expect(pin4, isNot(equals(pin4Second)));
    });

    test('Rate limiting should work correctly', () {
      const testUser = 'test@example.com';
      
      // Clear any existing attempts
      SecurityUtils.clearLoginAttempts(testUser);
      
      // Should not be rate limited initially
      expect(SecurityUtils.isRateLimited(testUser, maxAttempts: 3), isFalse);
      
      // Record attempts up to the limit
      SecurityUtils.recordLoginAttempt(testUser);
      SecurityUtils.recordLoginAttempt(testUser);
      SecurityUtils.recordLoginAttempt(testUser);
      
      // Should now be rate limited
      expect(SecurityUtils.isRateLimited(testUser, maxAttempts: 3), isTrue);
      
      // Clear attempts
      SecurityUtils.clearLoginAttempts(testUser);
      expect(SecurityUtils.isRateLimited(testUser, maxAttempts: 3), isFalse);
    });
  });

  group('Input Validation Tests', () {
    
    test('Registration validation should accept valid data', () {
      final result = InputValidator.validateRegistration(
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
        password: 'StrongPass123!',
        phone: '+1234567890',
        governmentId: '123456789',
      );
      
      expect(result.isValid, isTrue);
      expect(result.error, isNull);
    });

    test('Registration validation should reject invalid data', () {
      final result = InputValidator.validateRegistration(
        name: 'J', // Too short
        surname: 'Doe',
        email: 'invalid-email',
        password: 'weak',
        phone: 'invalid-phone',
        governmentId: '123', // Too short
      );
      
      expect(result.isValid, isFalse);
      expect(result.error, isNotNull);
    });

    test('Login validation should accept valid data', () {
      final result = InputValidator.validateLogin(
        email: 'test@example.com',
        password: 'SomePassword123!',
      );
      
      expect(result.isValid, isTrue);
      expect(result.error, isNull);
    });

    test('Login validation should reject invalid data', () {
      final result = InputValidator.validateLogin(
        email: 'invalid-email',
        password: '', // Empty password
      );
      
      expect(result.isValid, isFalse);
      expect(result.error, isNotNull);
    });
  });
}
