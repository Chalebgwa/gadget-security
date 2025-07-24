import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_sms/flutter_sms.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';

import 'package:gsec/models/user.dart' as app_user;
import 'package:gsec/providers/base_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  signedIn,
  signedOut,
  loading,
  safeLoading,
}

enum Action { alert, ok, no }

class Auth extends BaseProvider {
  //Device provider
  final DeviceProvider _deviceProvider = DeviceProvider();
  DeviceProvider get deviceProvider => _deviceProvider;

  //User provider
  final UserProvider _userProvider = UserProvider();

  // current state of the app
  AuthState _state = AuthState.signedOut;

  // logged in user
  app_user.User? _currentUser;

  app_user.User? get currentUser => _currentUser;

  // state getter
  AuthState get state => _state;

  set state(AuthState state) {
    _state = state;
    notifyListeners();
  }

  // auto retrieve verification id
  String? verificationId;

  Auth() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Check if user is already signed in
    checkLoginStatus();
  }

  UserProvider get userProvider => _userProvider;

  Future<void> setPersistentLogin(app_user.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    final List<String> data = app_user.User.toList(user);
    await prefs.setStringList("userData", data);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool status = prefs.getBool("isLoggedIn") ?? false;
      
      if (status) {
        final List<String>? data = prefs.getStringList("userData");
        if (data != null && data.isNotEmpty) {
          _currentUser = app_user.User.fromList(data);
          _state = AuthState.signedIn;
          notifyListeners();
          return;
        }
      }
      
      _state = AuthState.signedOut;
      notifyListeners();
    } catch (e) {
      print('Error checking login status: $e');
      _state = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future<void> resetPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await prefs.remove("userData");
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      //set the screen to show loading
      _state = AuthState.loading;
      notifyListeners();
      
      email = email.trim();
      
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final auth.User user = credential.user!;
        final DocumentReference reference =
            firestore.collection("users").doc(user.uid);
        final DocumentSnapshot snapshot = await reference.get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            _currentUser = app_user.User.fromMap(data);
            // set persistent login
            await setPersistentLogin(_currentUser!);
            _state = AuthState.signedIn;
            notifyListeners();
            return true;
          }
        }
      }
      
      _state = AuthState.signedOut;
      notifyListeners();
      return false;
    } on auth.FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } on PlatformException catch (e) {
      print('Platform exception: ${e.message}');
      _state = AuthState.signedOut;
      notifyListeners();
      return false;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Bad internet connection");
      _state = AuthState.signedOut;
      notifyListeners();
      return false;
    } catch (e) {
      print('Unexpected error during sign in: $e');
      _state = AuthState.signedOut;
      notifyListeners();
      return false;
    }
  }

  void _handleAuthError(auth.FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'user-disabled':
        message = 'User account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      default:
        message = 'Authentication failed: ${e.message}';
    }
    
    Fluttertoast.showToast(msg: message);
    _state = AuthState.signedOut;
    notifyListeners();
  }

  Future<String> resetPassword(String email) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      await firebaseAuth.sendPasswordResetEmail(email: email);
      
      _state = AuthState.signedOut;
      notifyListeners();
      return "Check Your Email";
    } on auth.FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        default:
          message = 'Error sending reset email: ${e.message}';
      }
      
      _state = AuthState.signedOut;
      notifyListeners();
      return message;
    } catch (e) {
      _state = AuthState.signedOut;
      notifyListeners();
      return "Error occurred. Please try again.";
    }
  }

  Future<void> signOut() async {
    try {
      _state = AuthState.loading;
      notifyListeners();
      
      await firebaseAuth.signOut();
      await resetPrefs();
      
      _currentUser = null;
      _state = AuthState.signedOut;
      notifyListeners();
      
      Fluttertoast.showToast(msg: "See you later");
    } catch (e) {
      print('Error during sign out: $e');
      _state = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future<app_user.User?> searchDeviceById(String identifier) async {
    try {
      //the state to return to after loading
      final AuthState temp = _state;
      // display loading screen while fetching data
      _state = AuthState.safeLoading;
      notifyListeners();

      final DocumentSnapshot deviceDoc = await firestore
          .collection("devices")
          .doc(identifier)
          .get();
          
      if (deviceDoc.exists) {
        final deviceData = deviceDoc.data() as Map<String, dynamic>?;
        if (deviceData != null) {
          final String? uid = deviceData['ownerId'] as String?;
          if (uid != null) {
            final DocumentSnapshot userDoc = await firestore
                .collection("users")
                .doc(uid)
                .get();
                
            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>?;
              if (userData != null) {
                _state = temp;
                notifyListeners();
                return app_user.User.fromMap(userData);
              }
            }
          }
        }
      }
      
      _state = temp;
      notifyListeners();
      return null;
    } catch (e) {
      print('Error searching device by ID: $e');
      _state = AuthState.signedOut;
      notifyListeners();
      return null;
    }
  }

  Future<String?> registerUser(
    String name,
    String surname,
    String email,
    String password,
    String phone,
    String governmentId,
  ) async {
    try {
      //show loading screen
      _state = AuthState.loading;
      notifyListeners();

      // create user here
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final auth.User user = credential.user!;
        
        // Authenticate via phone (optional for now)
        // await authenticateViaPhone(phone);
        
        final Map<String, dynamic> userInfo = {
          "name": name,
          "surname": surname,
          "email": email,
          "phone": phone,
          "governmentId": governmentId,
          "id": user.uid,
          "createdAt": FieldValue.serverTimestamp(),
        };

        await firestore
            .collection("users")
            .doc(user.uid)
            .set(userInfo);

        _state = AuthState.signedOut;
        notifyListeners();

        return user.uid;
      }
      
      _state = AuthState.signedOut;
      notifyListeners();
      return null;
    } on auth.FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } on PlatformException catch (e) {
      print('Platform exception during registration: ${e.message}');
      _state = AuthState.signedOut;
      notifyListeners();
      return null;
    } catch (e) {
      print('Unexpected error during registration: $e');
      _state = AuthState.signedOut;
      notifyListeners();
      return null;
    }
  }

  Future<void> authenticateViaPhone(String phone) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (auth.PhoneAuthCredential credential) {
          print('Phone verification completed automatically');
          Fluttertoast.showToast(msg: "Phone verification completed");
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          print('Phone verification failed: ${e.message}');
          Fluttertoast.showToast(msg: "Phone verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          print('Code sent to $phone');
          Fluttertoast.showToast(msg: "Phone verification code sent");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          print('Auto retrieval timeout');
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('Error during phone authentication: $e');
      Fluttertoast.showToast(msg: "Phone verification error");
    }
  }

  Future<String?> uploadDocument(File file, String path) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final storageRef = firebaseStorage.ref().child('$path${currentUser?.id}');
      final uploadTask = storageRef.putFile(file);
      
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      _state = AuthState.signedIn;
      notifyListeners();

      return url;
    } catch (e) {
      print('Error uploading document: $e');
      _state = AuthState.signedIn;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateUser({
    String? name,
    String? city,
    String? email,
    String? idNumber,
    String? phone,
    String? userId,
    String? middlename,
    String? surname,
    String? country,
    String? imageUrl,
  }) async {
    try {
      if (_currentUser == null) return;
      
      final data = <String, dynamic>{};
      
      if (email != null) data["email"] = email;
      if (city != null) data["city"] = city;
      if (name != null) data["name"] = name;
      if (idNumber != null) data["governmentId"] = idNumber;
      if (phone != null) data["phone"] = phone;
      if (surname != null) data["surname"] = surname;
      if (middlename != null) data["middlename"] = middlename;
      if (country != null) data["country"] = country;
      if (imageUrl != null) data["imageUrl"] = imageUrl;
      
      data["updatedAt"] = FieldValue.serverTimestamp();

      _state = AuthState.loading;
      notifyListeners();

      await firestore
          .collection("users")
          .doc(_currentUser!.id)
          .update(data);
          
      Fluttertoast.showToast(msg: "User details updated");
      
      // Refresh current user data
      final DocumentSnapshot userDoc = await firestore
          .collection("users")
          .doc(_currentUser!.id)
          .get();
          
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          _currentUser = app_user.User.fromMap(userData);
        }
      }

      _state = AuthState.signedIn;
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
      Fluttertoast.showToast(msg: "Error updating user details");
      _state = AuthState.signedIn;
      notifyListeners();
    }
  }

  Future<void> uploadFile(File file, {String? filename}) async {
    try {
      if (_currentUser == null) return;
      
      //set loading screen
      _state = AuthState.loading;
      notifyListeners();

      final String actualFilename = filename ?? _currentUser!.id;
      final storageRef = firebaseStorage.ref().child(actualFilename);
      final uploadTask = storageRef.putFile(file);
      
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      
      print('File uploaded: $url');

      await firestore
          .collection("users")
          .doc(_currentUser!.id)
          .update({"imageUrl": url});

      _state = AuthState.signedIn;
      notifyListeners();
    } catch (e) {
      print('Error uploading file: $e');
      _state = AuthState.signedIn;
      notifyListeners();
    }
  }

  Future<void> addDevice(Device device, File? file) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      String? url;
      if (file != null) {
        url = await uploadDocument(file, "/${device.identifier}/");
      }

      await _deviceProvider.addDevice(device, url: url);

      _state = AuthState.signedIn;
      notifyListeners();
    } catch (e) {
      print('Error adding device: $e');
      _state = AuthState.signedIn;
      notifyListeners();
    }
  }

  Future<void> transfer(app_user.User to, Device device) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      await _deviceProvider.transfer(to, device);

      _state = AuthState.signedIn;
      notifyListeners();
    } catch (e) {
      print('Error transferring device: $e');
      _state = AuthState.signedIn;
      notifyListeners();
    }
  }

  Future<app_user.User?> getUserBySsn(String barcode) async {
    try {
      final AuthState tempState = _state;
      _state = AuthState.safeLoading;
      notifyListeners();

      final DocumentSnapshot primaryDoc = await firestore
          .collection("primary")
          .doc(barcode)
          .get();

      if (primaryDoc.exists) {
        final primaryData = primaryDoc.data() as Map<String, dynamic>?;
        if (primaryData != null) {
          final String? uid = primaryData['uid'] as String?;
          if (uid != null) {
            final DocumentSnapshot userDoc = await firestore
                .collection('users')
                .doc(uid)
                .get();

            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>?;
              if (userData != null) {
                _state = tempState;
                notifyListeners();
                return app_user.User.fromMap(userData);
              }
            }
          }
        }
      }

      _state = tempState;
      notifyListeners();
      return null;
    } catch (e) {
      print('Error getting user by SSN: $e');
      _state = AuthState.signedOut;
      notifyListeners();
      return null;
    }
  }

  Future<Action> confirmWithPin(String pin) async {
    try {
      if (_currentUser == null) return Action.no;
      
      final DocumentSnapshot doc = await firestore
          .collection("security_info")
          .doc(_currentUser!.id)
          .get();
          
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          if (pin == data["safe"]) {
            return Action.ok;
          } else if (pin == data["alert"]) {
            return Action.alert;
          }
        }
      }
      
      return Action.no;
    } catch (e) {
      print('Error confirming PIN: $e');
      return Action.no;
    }
  }

  Future<void> alertSecurity(app_user.User peer) async {
    try {
      await sendSMS(
        message: "I am in an emergency please contact the authorities\n${peer.toString()}",
        recipients: ["+26777147912"], // This should be configurable
      );
    } catch (e) {
      print('Error sending security alert: $e');
      Fluttertoast.showToast(msg: "Failed to send security alert");
    }
  }
}