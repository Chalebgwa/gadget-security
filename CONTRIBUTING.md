# Contributing to Gadget Security

We love your input! We want to make contributing to Gadget Security as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

### We Use [Github Flow](https://guides.github.com/introduction/flow/index.html)

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.12.0)
- Git
- A Firebase project for testing

### Setting Up Development Environment

1. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/gadget-security.git
   cd gadget-security
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (for testing):
   - Create a test Firebase project
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Place them in the appropriate directories

4. **Run tests**:
   ```bash
   flutter test
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

## How to Contribute

### Reporting Bugs

We use GitHub issues to track bugs. Report a bug by [opening a new issue](https://github.com/Chalebgwa/gadget-security/issues/new).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

### Security Vulnerabilities

**Do not report security vulnerabilities through public GitHub issues.**

Instead, please email security@gadgetsecurity.com with:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested fixes

We'll respond within 24 hours and work with you to address the issue.

### Suggesting Enhancements

We use GitHub issues to track enhancement requests. Suggest an enhancement by [opening a new issue](https://github.com/Chalebgwa/gadget-security/issues/new) with the "enhancement" label.

**Great Enhancement Requests** include:

- A clear and descriptive title
- A detailed description of the proposed enhancement
- Any relevant examples or mockups
- Explanation of why this enhancement would be useful

### Pull Requests

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes**:
   - Follow the coding standards below
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   flutter format --set-exit-if-changed .
   ```

4. **Commit your changes**:
   ```bash
   git commit -m "Add amazing feature"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/amazing-feature
   ```

6. **Open a Pull Request** on GitHub

## Coding Standards

### Dart/Flutter Code Style

We follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and use `flutter format` to ensure consistency.

#### Key Points:

- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and types
- Use `snake_case` for file names
- Maximum line length: 80 characters
- Use meaningful variable and function names

#### Example:
```dart
class UserAuthentication {
  final String emailAddress;
  
  Future<bool> signInUser(String email, String password) async {
    // Implementation
  }
}
```

### Security Guidelines

**All code must follow security best practices:**

1. **Never store sensitive data in plaintext**
2. **Always validate and sanitize user input**
3. **Use proper error handling without exposing system details**
4. **Follow the principle of least privilege**
5. **Use secure random number generation for tokens/salts**

#### Security Checklist:
- [ ] Input validation implemented
- [ ] No hardcoded secrets or credentials
- [ ] Proper error handling
- [ ] Authentication/authorization checks
- [ ] Data encryption where appropriate

### Testing Requirements

- Write unit tests for all new functions
- Write widget tests for UI components
- Ensure security utilities are thoroughly tested
- Maintain minimum 80% code coverage

#### Test Structure:
```dart
group('Feature Name', () {
  test('should do something', () {
    // Arrange
    final input = 'test';
    
    // Act
    final result = someFunction(input);
    
    // Assert
    expect(result, expectedValue);
  });
});
```

### Documentation Standards

- Update README.md for significant changes
- Update API.md for new endpoints or data models
- Add inline documentation for complex functions
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)

#### Documentation Example:
```dart
/// Validates user registration data and returns validation result.
/// 
/// This function performs comprehensive validation including:
/// - Email format validation
/// - Password strength requirements
/// - Phone number format
/// - Government ID format
/// 
/// [name] - User's first name (minimum 2 characters)
/// [email] - User's email address
/// [password] - User's password (must meet strength requirements)
/// 
/// Returns [ValidationResult] with success/failure and error message.
ValidationResult validateRegistration({
  required String name,
  required String email,
  required String password,
}) {
  // Implementation
}
```

## Git Workflow

### Commit Message Format

Use the [Conventional Commits](https://conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

#### Examples:
```
feat(auth): add rate limiting to login attempts

fix(device): correct boolean parsing in Device.fromMap

docs(api): update authentication endpoint documentation

security: remove plaintext password storage
```

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `security/description` - Security improvements

## Release Process

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create release branch: `release/v1.x.x`
4. Run full test suite
5. Create pull request to `main`
6. After merge, tag the release
7. Build and deploy

## Community

### Getting Help

- Join our Discord: [Invite Link]
- Stack Overflow: Use tag `gadget-security`
- Email: support@gadgetsecurity.com

### Discussions

- Feature requests: GitHub Issues
- General questions: GitHub Discussions
- Security concerns: security@gadgetsecurity.com

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Special recognition for security contributions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Questions?

Don't hesitate to ask questions! We're here to help:
- Open an issue for general questions
- Email contribute@gadgetsecurity.com for contribution-specific questions
- Check existing issues and pull requests first

Thank you for contributing to Gadget Security! 🚀