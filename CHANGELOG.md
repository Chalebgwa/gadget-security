# Changelog

All notable changes to the Gadget Security project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-26

### 🔒 Security
- **BREAKING**: Removed plaintext password storage from database
- **BREAKING**: Implemented secure PIN hashing with unique salts (replaces plaintext PIN storage)
- Added comprehensive input validation and sanitization
- Implemented rate limiting for authentication (5 attempts per 15 minutes)
- Added brute force protection for login attempts
- Made emergency contact configurable instead of hardcoded
- Added proper error handling without information leakage

### ✨ Added
- New `SecurityUtils` class with comprehensive security functions
- New `InputValidator` class for form validation
- Comprehensive API documentation (`API.md`)
- Security documentation and best practices (`SECURITY.md`)
- Proper CI/CD workflow for Flutter with security scanning
- Extensive test coverage for security utilities
- Password strength validation
- Email and phone number format validation
- Government ID format validation

### 🐛 Fixed
- Fixed "gorvenmentId" typo to "governmentId" throughout codebase
- Fixed boolean parsing in Device model (using proper boolean conversion)
- Fixed import circular dependency with Action enum
- Removed unused positioned_tap_detector import
- Fixed Firebase configuration exposure

### 🔄 Changed
- **BREAKING**: Updated User model to use "governmentId" instead of "gorvenmentId"
- Updated authentication to use proper error handling and user feedback
- Improved device registration with proper type mapping
- Enhanced emergency alert system with better messaging
- Updated test file to test actual application functionality instead of placeholder counter

### 📚 Documentation
- Completely rewritten README with comprehensive setup instructions
- Added security guidelines and threat model
- Added API documentation with examples
- Added inline code documentation
- Added usage guides for developers and users

### 🛠️ Development
- Updated pubspec.yaml with proper dependency versions
- Removed commented-out dependencies
- Added crypto dependency for secure hashing
- Updated Flutter CI workflow from generic Dart workflow
- Added automated security scanning in CI
- Improved project description and metadata

### 🗑️ Removed
- Removed plaintext password storage
- Removed hardcoded emergency contact number
- Removed commented dependencies from pubspec.yaml
- Removed placeholder test code

### 🔧 Dependencies
- Added `crypto: ^3.0.3` for secure hashing
- Updated all dependencies to latest compatible versions
- Added `flutter_lints: ^2.0.3` for better code quality

## [0.1.0] - Initial Release

### Added
- Initial Flutter application structure
- Basic Firebase authentication
- Device registration functionality
- Peer-to-peer chat system
- QR code generation for device verification
- Basic UI components and navigation

### Security Notes
⚠️ **This version had critical security vulnerabilities that have been fixed in v1.0.0:**
- Passwords were stored in plaintext
- PINs were stored without hashing
- No input validation
- Hardcoded emergency contact
- No rate limiting

---

## Migration Guide

### Upgrading from 0.1.0 to 1.0.0

#### Database Migration Required
**⚠️ IMPORTANT**: This update includes breaking changes to the database schema.

1. **User Collection Changes**:
   - `gorvenmentId` field renamed to `governmentId`
   - `password` field removed (security improvement)
   - `createdAt` field added

2. **Security Info Collection Changes**:
   - `safe` field replaced with `safeHash`
   - `alert` field replaced with `alertHash`
   - `salt` field added
   - All existing PINs need to be reset by users

3. **Device Collection Changes**:
   - `confirmed` field now properly stored as boolean
   - `type` field added to device mapping
   - `createdAt` field added

#### Code Changes Required

1. **Update all references to `gorvenmentId`**:
   ```dart
   // Old
   user.gorvenmentId
   
   // New
   user.governmentId
   ```

2. **Update PIN setup**:
   ```dart
   // Old - direct PIN storage (insecure)
   // This is no longer supported
   
   // New - secure PIN setup
   await auth.setupSecurityPins(safePin, alertPin);
   ```

3. **Update authentication calls**:
   ```dart
   // Enhanced with validation and rate limiting
   bool success = await auth.signInWithEmail(email, password);
   ```

#### Firestore Security Rules Update

Update your Firestore security rules to match the new schema:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /devices/{deviceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.ownerId || 
         request.auth.uid == request.resource.data.ownerId);
    }
    
    match /security_info/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Required Actions After Update

1. **User Communication**: Notify all users that they need to:
   - Reset their security PINs (old PINs are no longer valid)
   - Set up emergency contacts in app settings

2. **Database Cleanup**: 
   - Remove password fields from existing user documents
   - Migrate governmentId field names
   - Archive old security_info documents

3. **Configuration**:
   - Update Firebase security rules
   - Configure emergency contact settings
   - Review and update privacy policies

---

## Support

For questions about upgrading or migration issues:
- Check the [API Documentation](API.md)
- Review [Security Documentation](SECURITY.md)
- Contact: support@gadgetsecurity.com