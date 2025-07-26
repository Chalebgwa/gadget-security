# GADGET SECURITY

A comprehensive Flutter mobile application for device security, ownership verification, and peer-to-peer device trading with enhanced security features.

![](assets/gs.gif)

## 🚀 Features

### Core Functionality
- **🔐 Secure Authentication**: Email/password with rate limiting and strong password requirements
- **📱 Device Registration**: Register and verify ownership of electronic devices (phones, laptops, etc.)
- **🎯 Proof of Ownership**: PIN-based verification system with QR code generation
- **🤝 Peer-to-Peer Trading**: Secure device transfers between verified users
- **🚨 Security Alerts**: Emergency alert system for stolen devices
- **💬 Peer-to-Peer Chat**: Secure messaging between users
- **🔍 Device Search**: Find device owners by device identifier

### Security Features
- **🛡️ Password Security**: Strong password requirements with hashing
- **🔒 PIN Protection**: Dual PIN system (safe/alert) with secure hashing
- **🚫 Rate Limiting**: Protection against brute force attacks
- **✅ Input Validation**: Comprehensive input sanitization and validation
- **📞 Emergency Alerts**: Configurable emergency contact system
- **🔐 Data Encryption**: Secure storage of sensitive information

## 📋 Prerequisites

Before running this application, ensure you have:

- **Flutter SDK** (>=3.0.0)
- **Dart SDK** (>=2.12.0)
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase Project** with the following services enabled:
  - Authentication (Email/Password)
  - Firestore Database
  - Cloud Storage
  - Phone Authentication

## 🛠️ Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Chalebgwa/gadget-security.git
cd gadget-security
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication with Email/Password and Phone providers
3. Create a Firestore database with the following security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Devices - owners can read/write, others can only read confirmed devices
    match /devices/{deviceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.ownerId || 
         request.auth.uid == request.resource.data.ownerId);
    }
    
    // Security info - only the user can access their security data
    match /security_info/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Chat messages - participants can read/write
    match /conversations/{conversationId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
    }
  }
}
```

4. Download the `google-services.json` file and place it in `android/app/`
5. For iOS, download `GoogleService-Info.plist` and place it in `ios/Runner/`

### 4. Configure Emergency Contacts

Set up your emergency contact number in the app settings or modify the default in `auth_provider.dart`.

### 5. Run the Application

```bash
# For debug mode
flutter run

# For release mode
flutter run --release
```

## 📱 Usage Guide

### Getting Started

1. **Register**: Create an account with strong password requirements
2. **Setup Security**: Configure your security PINs (safe PIN and alert PIN)
3. **Add Devices**: Register your electronic devices with proof of purchase
4. **Verify Ownership**: Generate QR codes for ownership verification

### Security Features

#### PIN System
- **Safe PIN**: Normal access to your devices
- **Alert PIN**: Triggers emergency alert while appearing normal

#### Device Registration
1. Take a photo of your device and purchase receipt
2. Enter device details (IMEI, serial number, etc.)
3. Wait for verification from the system

#### Emergency Alerts
- If you enter your alert PIN, an SMS is sent to your emergency contact
- The alert appears normal to potential thieves

## 🏗️ Architecture

### Directory Structure
```
lib/
├── models/          # Data models (User, Device, etc.)
├── providers/       # State management (Auth, Device, etc.)
├── views/           # UI screens
├── widgets/         # Reusable UI components
├── util/            # Utility functions and security helpers
└── main.dart        # Application entry point
```

### Key Components

- **SecurityUtils**: Handles password hashing, input validation, and rate limiting
- **Auth Provider**: Manages user authentication and security
- **Device Provider**: Handles device registration and transfers
- **Input Validator**: Validates and sanitizes user inputs

## 🔒 Security Best Practices

### For Users
1. Use a strong, unique password for your account
2. Keep your security PINs confidential and different from each other
3. Regularly update your emergency contact information
4. Report suspicious activity immediately

### For Developers
1. Never store passwords in plaintext
2. Always validate and sanitize user inputs
3. Implement proper error handling
4. Use secure communication channels
5. Regular security audits and updates

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Test Structure
- Unit tests for security utilities
- Widget tests for UI components
- Integration tests for complete user flows

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure security best practices are followed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Security Disclaimer

This application handles sensitive personal and device information. Always:
- Keep the app updated to the latest version
- Use strong, unique passwords
- Enable two-factor authentication where available
- Report security vulnerabilities responsibly

## 📞 Support

For support, email support@gadgetsecurity.com or join our community forum.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Contributors and beta testers

---

**⚡ Built with Flutter 💙**
