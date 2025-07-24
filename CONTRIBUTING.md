# Contributing to Gadget Security

We love your input! We want to make contributing to Gadget Security as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

### Git Workflow

1. Fork the repo and create your branch from `develop`
2. If you've added code that should be tested, add tests
3. If you've changed APIs, update the documentation
4. Ensure the test suite passes
5. Make sure your code lints
6. Issue that pull request!

### Branch Naming Convention

- `feature/your-feature-name` - for new features
- `bugfix/issue-description` - for bug fixes
- `hotfix/critical-fix` - for critical production fixes
- `docs/documentation-update` - for documentation changes
- `refactor/code-improvement` - for code refactoring

### Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

Examples:
```
feat(auth): add biometric authentication support
fix(device): resolve QR code scanning on Android 13
docs(readme): update installation instructions
```

## Development Setup

### Prerequisites

- Flutter 3.22.0 or later
- Dart 3.0.0 or later
- Android Studio / VS Code with Flutter extensions
- Git
- Firebase CLI (for backend changes)

### Setup Steps

1. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/gadget-security.git
   cd gadget-security
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/Chalebgwa/gadget-security.git
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Set up Firebase**
   - Create a Firebase project for development
   - Download `google-services.json` and place in `android/app/`
   - Download `GoogleService-Info.plist` and add to iOS project

5. **Run the app**
   ```bash
   flutter run
   ```

### Development Environment

Create a `.env` file in the root directory:
```env
ENVIRONMENT=development
FIREBASE_PROJECT_ID=your-dev-project-id
EMERGENCY_PHONE=+1234567890
SECURITY_ALERT_PHONE=+1234567890
API_BASE_URL=https://api-dev.gadgetsecurity.app
```

## Code Standards

### Dart/Flutter Guidelines

We follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices).

#### Key Points:

1. **Formatting**: Use `dart format` to format your code
2. **Linting**: All code must pass `flutter analyze` without warnings
3. **Documentation**: Public APIs must be documented
4. **Testing**: All new features must include tests
5. **Performance**: Consider performance implications of your changes

#### Code Structure

```
lib/
├── config/          # App configuration
├── models/          # Data models
├── pages/           # UI screens/pages
├── providers/       # State management
├── services/        # Business logic services
├── utils/           # Utility functions
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

### State Management

We use the Provider pattern for state management:

- Use `ChangeNotifier` for mutable state
- Keep providers focused on single responsibilities
- Use `Consumer` widgets for UI updates
- Avoid unnecessary rebuilds with `Selector`

### Error Handling

- Always handle exceptions appropriately
- Use the `AppLogger` for consistent logging
- Provide meaningful error messages to users
- Use `try-catch` blocks for async operations

### Security Guidelines

- Never commit sensitive data (API keys, passwords)
- Use environment variables for configuration
- Validate all user inputs
- Follow Firebase security best practices
- Use HTTPS for all network communications

## Testing

### Types of Tests

1. **Unit Tests**: Test individual functions and classes
2. **Widget Tests**: Test UI components
3. **Integration Tests**: Test complete user flows

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Writing Tests

- Tests should be deterministic and isolated
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Test both success and failure scenarios

Example:
```dart
group('AuthProvider', () {
  testWidgets('should sign in user with valid credentials', (tester) async {
    // Arrange
    final authProvider = AuthProvider();
    
    // Act
    final result = await authProvider.signInWithEmail('test@example.com', 'password');
    
    // Assert
    expect(result, isTrue);
    expect(authProvider.currentUser, isNotNull);
  });
});
```

## Documentation

### Code Documentation

- Use dartdoc comments for public APIs
- Include examples in documentation
- Keep comments up to date with code changes
- Document complex algorithms and business logic

### README Updates

When adding features that affect user setup or usage:

1. Update installation instructions
2. Add feature documentation
3. Update configuration examples
4. Include troubleshooting tips

## Pull Request Process

### Before Submitting

1. **Sync with upstream**
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

2. **Run quality checks**
   ```bash
   flutter analyze
   dart format .
   flutter test
   ```

3. **Test on multiple platforms**
   - Android (minimum API 21)
   - iOS (minimum iOS 13)

### PR Template

When creating a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Tested on Android
- [ ] Tested on iOS

## Screenshots (if applicable)
Add screenshots or videos demonstrating the changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No new warnings from analyzer
```

### Review Process

1. **Automated Checks**: CI/CD pipeline runs tests and analysis
2. **Code Review**: At least one maintainer reviews the code
3. **Testing**: Reviewers test the changes on different devices
4. **Approval**: PR must be approved before merging
5. **Merge**: Squash and merge to keep history clean

## Feature Requests

We use GitHub Issues to track feature requests:

1. Check if the feature already exists or is requested
2. Use the feature request template
3. Provide detailed use cases and requirements
4. Include mockups or examples if possible

## Bug Reports

When reporting bugs:

1. Use the bug report template
2. Include steps to reproduce
3. Provide device and OS information
4. Add screenshots or videos if helpful
5. Include relevant logs or error messages

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different opinions and approaches

### Communication

- **GitHub Issues**: For bugs and feature requests
- **Pull Requests**: For code discussions
- **Discussions**: For general questions and ideas
- **Email**: For security issues (security@gadgetsecurity.app)

## Recognition

Contributors who make significant contributions will be:

- Added to the CONTRIBUTORS.md file
- Mentioned in release notes
- Invited to join the core team (for exceptional contributors)

## Getting Help

If you need help:

1. Check the documentation
2. Search existing issues
3. Ask in GitHub Discussions
4. Contact us at support@gadgetsecurity.app

Thank you for contributing to Gadget Security! 🚀