# API Documentation

## Overview

This document describes the API endpoints and data models used in the Gadget Security application. The app uses Firebase Firestore as the primary database with the following collections.

## Database Collections

### Users Collection (`/users/{userId}`)

#### User Document Structure
```json
{
  "id": "string",              // Firebase Auth UID
  "name": "string",            // User's first name
  "surname": "string",         // User's last name
  "email": "string",           // User's email address
  "phone": "string",           // User's phone number
  "governmentId": "string",    // Government ID number
  "city": "string",            // User's city (optional)
  "country": "string",         // User's country (optional)
  "middlename": "string",      // User's middle name (optional)
  "imageUrl": "string",        // Profile picture URL
  "createdAt": "string"        // ISO 8601 timestamp
}
```

#### Security Rules
```javascript
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

### Devices Collection (`/devices/{deviceId}`)

#### Device Document Structure
```json
{
  "identifier": "string",      // Unique device identifier
  "ownerId": "string",         // Firebase Auth UID of owner
  "name": "string",            // Device name/model
  "type": "string",            // Device type (mobile, laptop, etc.)
  "imei": "string",            // IMEI or serial number
  "confirmed": "boolean",      // Ownership verification status
  "proofUrl": "string",        // URL to proof of purchase document
  "createdAt": "string"        // ISO 8601 timestamp
}
```

#### Security Rules
```javascript
match /devices/{deviceId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && 
    (request.auth.uid == resource.data.ownerId || 
     request.auth.uid == request.resource.data.ownerId);
}
```

### Security Info Collection (`/security_info/{userId}`)

#### Security Document Structure
```json
{
  "salt": "string",            // Unique salt for PIN hashing
  "safeHash": "string",        // Hashed safe PIN
  "alertHash": "string",       // Hashed alert PIN
  "createdAt": "string",       // ISO 8601 timestamp
  "lastUpdated": "string"      // ISO 8601 timestamp
}
```

#### Security Rules
```javascript
match /security_info/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

### Conversations Collection (`/conversations/{conversationId}`)

#### Conversation Document Structure
```json
{
  "participants": ["string"],   // Array of user IDs
  "lastMessage": "string",      // Last message content
  "lastMessageTime": "string",  // ISO 8601 timestamp
  "createdAt": "string"         // ISO 8601 timestamp
}
```

#### Message Subcollection (`/conversations/{conversationId}/messages/{messageId}`)
```json
{
  "senderId": "string",         // Firebase Auth UID of sender
  "content": "string",          // Message content
  "timestamp": "string",        // ISO 8601 timestamp
  "messageType": "string"       // text, image, system
}
```

#### Security Rules
```javascript
match /conversations/{conversationId} {
  allow read, write: if request.auth != null && 
    request.auth.uid in resource.data.participants;
    
  match /messages/{messageId} {
    allow read, write: if request.auth != null && 
      request.auth.uid in get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
  }
}
```

## Authentication Provider API

### Class: `Auth`

#### Properties
- `currentUser: Client?` - Currently authenticated user
- `state: AuthState` - Current authentication state
- `deviceProvider: DeviceProvider` - Device management provider
- `userProvider: UserProvider` - User management provider

#### Methods

##### `signInWithEmail(String email, String password) -> Future<bool>`
Signs in a user with email and password.

**Parameters:**
- `email`: User's email address
- `password`: User's password

**Returns:** 
- `true` if login successful, `false` otherwise

**Security Features:**
- Input validation and sanitization
- Rate limiting (5 attempts per 15 minutes)
- Proper error handling

**Example:**
```dart
final auth = Provider.of<Auth>(context);
bool success = await auth.signInWithEmail('user@example.com', 'password123');
```

##### `registerUser(String name, String surname, String email, String password, String phone, String gId) -> Future<String?>`
Registers a new user account.

**Parameters:**
- `name`: User's first name
- `surname`: User's last name
- `email`: User's email address
- `password`: User's password
- `phone`: User's phone number
- `gId`: Government ID number

**Returns:**
- User ID if successful, `null` otherwise

**Security Features:**
- Comprehensive input validation
- Password strength requirements
- Input sanitization
- No password storage in database

##### `setupSecurityPins(String safePin, String alertPin) -> Future<void>`
Sets up security PINs for device access.

**Parameters:**
- `safePin`: PIN for normal access
- `alertPin`: PIN that triggers emergency alert

**Security Features:**
- PIN hashing with unique salt
- No plaintext storage

##### `confirmWithPin(String pin) -> Future<Action>`
Verifies a PIN against stored security PINs.

**Parameters:**
- `pin`: PIN to verify

**Returns:**
- `Action.OK`: Safe PIN matched
- `Action.ALERT`: Alert PIN matched
- `Action.NO`: No match

##### `resetPassword(String email) -> Future<String>`
Sends password reset email.

**Parameters:**
- `email`: User's email address

**Returns:**
- Success/error message

##### `signOut() -> Future<void>`
Signs out the current user and clears session data.

##### `addDevice(Device device, File file) -> Future<void>`
Adds a new device with proof of purchase.

**Parameters:**
- `device`: Device object
- `file`: Proof of purchase document

##### `transfer(Client to, Device device) -> Future<void>`
Transfers device ownership to another user.

**Parameters:**
- `to`: Target user
- `device`: Device to transfer

##### `searchDeviceById(String identifier) -> Future<Client?>`
Searches for device owner by device identifier.

**Parameters:**
- `identifier`: Device identifier

**Returns:**
- Owner's user data if found, `null` otherwise

## Security Utils API

### Class: `SecurityUtils`

#### Static Methods

##### `generateSalt() -> String`
Generates a cryptographically secure salt for password hashing.

##### `hashPassword(String password, String salt) -> String`
Hashes a password with salt using SHA-256.

##### `verifyPassword(String password, String hash, String salt) -> bool`
Verifies a password against its hash.

##### `isValidEmail(String email) -> bool`
Validates email format using regex.

##### `isValidPhoneNumber(String phone) -> bool`
Validates international phone number format.

##### `isStrongPassword(String password) -> bool`
Checks password strength requirements:
- Minimum 8 characters
- Uppercase and lowercase letters
- Numbers and special characters

##### `sanitizeInput(String input) -> String`
Sanitizes input to prevent XSS and injection attacks.

##### `isValidGovernmentId(String id) -> bool`
Validates government ID format (8-15 digits).

##### `generateSecurePin(int length) -> String`
Generates a cryptographically secure PIN.

##### `isRateLimited(String identifier, {int maxAttempts, Duration window}) -> bool`
Checks if identifier has exceeded rate limit.

##### `recordLoginAttempt(String identifier) -> void`
Records a login attempt for rate limiting.

##### `clearLoginAttempts(String identifier) -> void`
Clears login attempts for successful authentication.

## Input Validator API

### Class: `InputValidator`

#### Static Methods

##### `validateRegistration({required String name, surname, email, password, phone, governmentId}) -> ValidationResult`
Validates user registration data.

##### `validateLogin({required String email, password}) -> ValidationResult`
Validates login credentials.

### Class: `ValidationResult`

#### Properties
- `isValid: bool` - Whether validation passed
- `error: String?` - Error message if validation failed

#### Static Methods
- `valid() -> ValidationResult` - Creates a valid result
- `invalid(String error) -> ValidationResult` - Creates an invalid result

## Device Provider API

### Class: `DeviceProvider`

#### Methods

##### `addDevice(Device device, {String? url}) -> Future<void>`
Adds a device to the database.

##### `getUserDevices(String userId) -> Future<List<Device>>`
Retrieves all devices owned by a user.

##### `transfer(Client to, Device device) -> Future<void>`
Transfers device ownership.

##### `confirmDevice(String deviceId) -> Future<void>`
Confirms device ownership after verification.

## Data Models

### User Model (`Client`)

```dart
class Client {
  final String name;
  final String surname;
  final String id;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String governmentId;
  final String imageUrl;
  
  Client(this.name, this.id, this.email, this.phone, this.city, 
         this.country, this.governmentId, this.surname, this.imageUrl);
  
  factory Client.fromMap(Map map);
  factory Client.fromList(List<String> data);
  static List<String> toList(Client user);
}
```

### Device Model

```dart
class Device {
  final String identifier;
  final String ownerId;
  final String name;
  final String type;
  final String imei;
  final bool confirmed;
  
  Device(this.identifier, this.ownerId, this.name, 
         {required this.type, required this.imei, this.confirmed = false});
  
  factory Device.fromMap(Map map);
  static Map<String, dynamic> toMap(Device device);
}
```

## Error Handling

### Authentication Errors
- `user-not-found`: No account with provided email
- `wrong-password`: Incorrect password
- `user-disabled`: Account has been disabled
- `too-many-requests`: Rate limit exceeded
- `weak-password`: Password doesn't meet requirements
- `email-already-in-use`: Account with email already exists
- `invalid-email`: Invalid email format

### Validation Errors
- Input validation failures return descriptive error messages
- All errors are user-friendly and don't expose system internals

## Rate Limiting

### Login Attempts
- Maximum 5 attempts per email address
- 15-minute lockout window
- Attempts reset on successful login

### Implementation
```dart
// Check rate limiting
if (SecurityUtils.isRateLimited(email)) {
  // Handle rate limited user
}

// Record attempt
SecurityUtils.recordLoginAttempt(email);

// Clear on success
SecurityUtils.clearLoginAttempts(email);
```

## Security Considerations

### Data Protection
- All sensitive data is hashed or encrypted
- Input validation on all user inputs
- SQL injection prevention through Firestore
- XSS prevention through input sanitization

### Authentication Security
- Strong password requirements
- Rate limiting against brute force
- Secure session management
- PIN-based device access with emergency alerts

### Privacy
- Minimal data collection
- User consent for data processing
- Secure data transmission (HTTPS/TLS)
- Data retention policies

---

**Last Updated**: December 2024
**Version**: 1.0