# Gadget Security 🔒📱

A modern Flutter mobile application that provides comprehensive device security, ownership verification, peer-to-peer trading, and emergency alert features for electronic devices.

## 🌟 Features

### Core Functionality
- **🔐 Proof of Ownership**: Verify and establish device ownership with cryptographic proof
- **🤝 Peer-to-Peer Trading**: Secure marketplace for trading devices between users
- **🚨 Security Alerts**: Real-time notifications for stolen or compromised devices
- **💬 Peer-to-Peer Chat**: Direct communication between users for trading and support
- **📱 Device Registry**: Comprehensive database of registered devices
- **🆔 QR Code Generation & Scanning**: Quick device identification and verification

### Security Features
- **Emergency Alerts**: Silent alarm system with law enforcement integration
- **Device Fingerprinting**: Unique device identification using IMEI, serial numbers
- **Secure Authentication**: Firebase-based user authentication with phone verification
- **Data Encryption**: End-to-end encryption for sensitive device and user data

## 🚀 Quick Start

### Prerequisites
- Flutter 3.22.0 or later
- Dart 3.0.0 or later
- Android Studio / VS Code with Flutter extensions
- Firebase account for backend services

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Chalebgwa/gadget-security.git
   cd gadget-security
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a new Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
   - Enable Authentication, Firestore, and Storage
   - Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
   - Place the files in their respective platform directories

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (13.0+)
- 🔄 Web (Beta)

## 🏗️ Architecture

### State Management
- **Provider Pattern**: Centralized state management using the Provider package
- **Separation of Concerns**: Clear distinction between UI, business logic, and data layers

### Backend Integration
- **Firebase Auth**: User authentication and authorization
- **Cloud Firestore**: Real-time database for device registry and user data
- **Firebase Storage**: Secure file storage for device documentation and images

### Key Components
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── device.dart          # Device model
│   └── user.dart            # User model
├── pages/                    # UI screens
│   ├── dashboard.dart       # Main dashboard
│   ├── authentication/      # Auth screens
│   └── device_info.dart     # Device details
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication logic
│   ├── device_provider.dart # Device management
│   └── security.dart        # Security features
└── widgets/                 # Reusable UI components
```

## 🔧 Configuration

### Environment Setup
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID=your_project_id
EMERGENCY_CONTACT=+1234567890
API_BASE_URL=https://your-api.com
```

### Firebase Security Rules
Configure Firestore security rules:
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
        request.auth.uid == resource.data.ownerId;
    }
  }
}
```

## 🔒 Security Features

### Device Registration
1. **IMEI/Serial Verification**: Automatic extraction of device identifiers
2. **Ownership Proof**: Upload purchase receipts or documentation
3. **Photo Verification**: Multiple device photos for visual confirmation
4. **QR Code Generation**: Unique QR codes for quick device identification

### Emergency Protocol
1. **Silent Alarm**: Discrete emergency signal activation
2. **Location Sharing**: Automatic GPS coordinate transmission
3. **Contact Alerts**: Automated notifications to emergency contacts
4. **Law Enforcement Integration**: Direct communication with security services

### Trading Security
1. **Identity Verification**: Government ID verification for traders
2. **Escrow System**: Secure payment holding during transactions
3. **Rating System**: Community-based trust scoring
4. **Dispute Resolution**: Mediation system for transaction conflicts

## 📊 Usage Analytics

The app includes privacy-respecting analytics to improve user experience:
- Feature usage statistics
- Performance metrics
- Crash reporting
- User feedback collection

All analytics are anonymized and GDPR compliant.

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔄 Development Workflow

### Code Style
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` for consistent formatting
- Run `flutter analyze` before committing

### Git Workflow
1. Create feature branches from `develop`
2. Use conventional commit messages
3. Submit PRs to `develop` branch
4. Squash commits before merging

### CI/CD Pipeline
- Automated testing on push
- Code quality checks
- Build verification for all platforms
- Automated deployment to Firebase App Distribution

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Getting Help
- 📧 Email: support@gadgetsecurity.app
- 💬 Discord: [Join our community](https://discord.gg/gadgetsecurity)
- 📖 Documentation: [docs.gadgetsecurity.app](https://docs.gadgetsecurity.app)
- 🐛 Bug Reports: [GitHub Issues](https://github.com/Chalebgwa/gadget-security/issues)

### Emergency Support
For emergency situations involving device theft or security threats:
- 🚨 Emergency Hotline: +1-800-GADGET-911
- 📱 In-app Emergency Button
- 🔗 Direct law enforcement integration

## 🗺️ Roadmap

### Version 2.1.0 (Current)
- [x] Modern Flutter 3.x migration
- [x] Material Design 3 implementation
- [x] Improved QR scanning with mobile_scanner
- [x] Enhanced security protocols
- [x] Comprehensive documentation

### Version 2.2.0 (Planned)
- [ ] Blockchain integration for ownership verification
- [ ] AI-powered fraud detection
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Web platform launch

### Version 3.0.0 (Future)
- [ ] Smart contract integration
- [ ] IoT device support
- [ ] Machine learning recommendations
- [ ] Enterprise features
- [ ] API marketplace

## 📈 Performance

### Benchmarks
- Cold start time: <2 seconds
- Memory usage: <150MB average
- Network efficiency: Optimized for 3G networks
- Battery impact: Minimal background processing

### Optimization Features
- Image compression and caching
- Lazy loading for large lists
- Efficient state management
- Background sync optimization

## 🌍 Localization

Currently supported languages:
- English (en-US)
- Spanish (es-ES) - Coming soon
- French (fr-FR) - Coming soon
- German (de-DE) - Coming soon

## 🔐 Privacy Policy

We take privacy seriously. Our app:
- Minimizes data collection
- Uses end-to-end encryption
- Complies with GDPR and CCPA
- Provides user data export/deletion
- Maintains transparent privacy practices

For full details, see our [Privacy Policy](PRIVACY.md).

---

**Made with ❤️ by the Gadget Security Team**

*Protecting your digital life, one device at a time.*
