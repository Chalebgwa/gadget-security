# Production Deployment Guide

This guide covers deploying the Gadget Security Flutter app to production environments.

## Prerequisites

### Development Environment
- Flutter 3.22.0 or later
- Dart 3.0.0 or later
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS builds)
- Git for version control

### Production Services
- Firebase project with the following enabled:
  - Authentication
  - Cloud Firestore
  - Firebase Storage
  - Firebase Analytics (optional)
  - Firebase Crashlytics (recommended)
- Google Play Console account (for Android)
- Apple Developer account (for iOS)

## Environment Configuration

### 1. Environment Variables

Set the following environment variables for production:

```bash
export ENVIRONMENT=production
export FIREBASE_PROJECT_ID=your-production-project-id
export EMERGENCY_PHONE=+1234567890
export SECURITY_ALERT_PHONE=+1234567890
export API_BASE_URL=https://api.gadgetsecurity.app
```

### 2. Firebase Configuration

#### Android
1. Download `google-services.json` from your Firebase console
2. Place it in `android/app/google-services.json`
3. Ensure the file is included in version control or CI/CD pipeline

#### iOS
1. Download `GoogleService-Info.plist` from your Firebase console
2. Add it to your iOS project in Xcode
3. Ensure it's properly linked in your project settings

### 3. Signing Configuration

#### Android Production Signing

1. Create a production keystore:
```bash
keytool -genkey -v -keystore release.keystore -alias key -keyalg RSA -keysize 2048 -validity 10000
```

2. Update `android/app/build.gradle` signing configuration:
```gradle
signingConfigs {
    release {
        storeFile file('keystore/release.keystore')
        storePassword System.getenv("KEYSTORE_PASSWORD")
        keyAlias System.getenv("KEY_ALIAS")
        keyPassword System.getenv("KEY_PASSWORD")
    }
}
```

3. Set environment variables:
```bash
export KEYSTORE_PASSWORD=your_keystore_password
export KEY_ALIAS=your_key_alias
export KEY_PASSWORD=your_key_password
```

#### iOS Production Signing

1. Set up proper provisioning profiles in Xcode
2. Configure code signing for distribution
3. Use automatic signing with your Apple Developer account

## Build Process

### Development Build
```bash
# Debug build for testing
flutter build apk --debug
flutter build ios --debug
```

### Staging Build
```bash
# Staging build with production optimizations
flutter build apk --flavor staging --dart-define=ENVIRONMENT=staging
flutter build ios --flavor staging --dart-define=ENVIRONMENT=staging
```

### Production Build

#### Android
```bash
# Production APK
flutter build apk --release \
  --dart-define=ENVIRONMENT=production \
  --dart-define=FIREBASE_PROJECT_ID=your-prod-project-id \
  --dart-define=EMERGENCY_PHONE=+1234567890 \
  --dart-define=SECURITY_ALERT_PHONE=+1234567890 \
  --dart-define=API_BASE_URL=https://api.gadgetsecurity.app

# Production AAB (recommended for Play Store)
flutter build appbundle --release \
  --dart-define=ENVIRONMENT=production \
  --dart-define=FIREBASE_PROJECT_ID=your-prod-project-id \
  --dart-define=EMERGENCY_PHONE=+1234567890 \
  --dart-define=SECURITY_ALERT_PHONE=+1234567890 \
  --dart-define=API_BASE_URL=https://api.gadgetsecurity.app
```

#### iOS
```bash
flutter build ios --release \
  --dart-define=ENVIRONMENT=production \
  --dart-define=FIREBASE_PROJECT_ID=your-prod-project-id \
  --dart-define=EMERGENCY_PHONE=+1234567890 \
  --dart-define=SECURITY_ALERT_PHONE=+1234567890 \
  --dart-define=API_BASE_URL=https://api.gadgetsecurity.app
```

## Security Checklist

### Code Security
- [ ] Remove all debug logging from production builds
- [ ] Ensure no API keys or secrets are hardcoded
- [ ] Validate all user inputs
- [ ] Implement proper authentication checks
- [ ] Use HTTPS for all network communications
- [ ] Enable ProGuard/R8 for Android releases

### Firebase Security
- [ ] Configure proper Firestore security rules
- [ ] Enable Firebase App Check
- [ ] Set up proper user permissions
- [ ] Configure Firebase Storage rules
- [ ] Enable audit logging

### App Store Security
- [ ] Enable app signing by Google Play/Apple
- [ ] Configure proper app permissions
- [ ] Set minimum SDK versions appropriately
- [ ] Review and remove unused permissions

## Monitoring and Analytics

### Performance Monitoring
1. Enable Firebase Performance Monitoring
2. Set up custom metrics for critical user flows
3. Monitor app startup time and memory usage

### Crash Reporting
1. Integrate Firebase Crashlytics
2. Set up custom crash reporting for critical errors
3. Configure alert thresholds

### Analytics
1. Configure Firebase Analytics events
2. Set up conversion tracking
3. Monitor user engagement metrics

## CI/CD Pipeline

### GitHub Actions Configuration

Update `.github/workflows/dart.yml`:

```yaml
name: Production Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.0'
        channel: 'stable'
    - run: flutter pub get
    - run: dart format --output=none --set-exit-if-changed .
    - run: flutter analyze
    - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.0'
        channel: 'stable'
    - run: flutter pub get
    - name: Build Android AAB
      run: |
        flutter build appbundle --release \
          --dart-define=ENVIRONMENT=production \
          --dart-define=FIREBASE_PROJECT_ID=${{ secrets.FIREBASE_PROJECT_ID }} \
          --dart-define=EMERGENCY_PHONE=${{ secrets.EMERGENCY_PHONE }} \
          --dart-define=SECURITY_ALERT_PHONE=${{ secrets.SECURITY_ALERT_PHONE }} \
          --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }}
    - name: Upload to Play Store
      # Add your Play Store upload action here

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.0'
        channel: 'stable'
    - run: flutter pub get
    - name: Build iOS
      run: |
        flutter build ios --release \
          --dart-define=ENVIRONMENT=production \
          --dart-define=FIREBASE_PROJECT_ID=${{ secrets.FIREBASE_PROJECT_ID }} \
          --dart-define=EMERGENCY_PHONE=${{ secrets.EMERGENCY_PHONE }} \
          --dart-define=SECURITY_ALERT_PHONE=${{ secrets.SECURITY_ALERT_PHONE }} \
          --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }}
    - name: Upload to App Store
      # Add your App Store upload action here
```

## Post-Deployment

### Monitoring
1. Monitor crash reports and fix critical issues
2. Track app performance metrics
3. Monitor user feedback and ratings

### Updates
1. Use staged rollouts for updates
2. Monitor for regressions after deployments
3. Keep dependencies up to date

### Support
1. Set up support channels for users
2. Monitor emergency alert functionality
3. Regularly test backup and recovery procedures

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Verify all environment variables are set
   - Check Flutter and dependencies versions
   - Ensure proper signing configuration

2. **Firebase Connection Issues**
   - Verify `google-services.json` and `GoogleService-Info.plist` are correct
   - Check Firebase project configuration
   - Ensure proper network permissions

3. **Performance Issues**
   - Review ProGuard configuration
   - Check for memory leaks
   - Monitor network requests

### Emergency Procedures

1. **Rollback Process**
   - Use app store rollback features
   - Communicate with users about issues
   - Fix and redeploy quickly

2. **Security Incidents**
   - Immediately revoke compromised credentials
   - Update security rules
   - Notify users if necessary

## Support

For deployment support, contact:
- Email: support@gadgetsecurity.app
- Emergency: +1-800-GADGET-911
- Documentation: [docs.gadgetsecurity.app](https://docs.gadgetsecurity.app)