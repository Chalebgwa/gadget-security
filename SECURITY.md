# Security Policy

## Supported Versions

We actively support and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 2.1.x   | :white_check_mark: |
| 2.0.x   | :white_check_mark: |
| 1.x.x   | :x:                |

## Reporting a Vulnerability

The Gadget Security team takes security vulnerabilities seriously. We appreciate your efforts to responsibly disclose your findings.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by emailing: **security@gadgetsecurity.app**

Include the following information in your report:

- Type of issue (e.g. buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit the issue

### Response Timeline

- **Initial Response**: Within 24 hours of receiving your report
- **Assessment**: Within 72 hours, we'll provide an initial assessment
- **Resolution**: Critical issues will be patched within 7 days, other issues within 30 days
- **Disclosure**: We'll coordinate with you on responsible disclosure timing

### Bug Bounty Program

We currently do not have a formal bug bounty program, but we recognize and appreciate security researchers who help improve our security:

- **Hall of Fame**: Recognized researchers will be listed in our security acknowledgments
- **Swag**: Depending on the severity, we may send Gadget Security merchandise
- **Recognition**: With your permission, we'll acknowledge your contribution in our release notes

### Security Features

Our app implements multiple security layers:

#### Authentication & Authorization
- Firebase Authentication with email verification
- Multi-factor authentication support
- Secure session management
- Role-based access control

#### Data Protection
- End-to-end encryption for sensitive data
- Secure storage of device information
- PII data encryption at rest
- Secure communication protocols (HTTPS/TLS)

#### Device Security
- Device fingerprinting for ownership verification
- Secure QR code generation and scanning
- Tamper detection for device registry
- Emergency alert system with law enforcement integration

#### Application Security
- Certificate pinning for API communications
- Code obfuscation in production builds
- Anti-debugging and anti-tampering measures
- Secure key storage using platform key stores

#### Infrastructure Security
- Firebase security rules for database access
- Storage access controls
- Regular security audits
- GDPR and CCPA compliance

### Security Monitoring

We continuously monitor for:

- Unauthorized access attempts
- Suspicious device registration patterns
- Fraudulent trading activities
- Emergency alert abuse
- Data breach indicators

### Incident Response

In case of a security incident:

1. **Immediate Response**: Critical systems are isolated within 1 hour
2. **Assessment**: Full impact assessment within 6 hours
3. **Communication**: Affected users notified within 24 hours
4. **Resolution**: Issues resolved and systems restored ASAP
5. **Post-Mortem**: Full analysis and prevention measures implemented

### Contact Information

- **Security Team**: security@gadgetsecurity.app
- **General Support**: support@gadgetsecurity.app
- **Emergency Hotline**: +1-800-GADGET-911

### Legal

This security policy is subject to our Terms of Service and Privacy Policy. By participating in our responsible disclosure program, you agree to:

- Not access or modify user data without explicit permission
- Not perform testing that could impact service availability
- Not violate any applicable laws or regulations
- Provide reasonable time for us to address issues before public disclosure

Thank you for helping keep Gadget Security and our users safe!