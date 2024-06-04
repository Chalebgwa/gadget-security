
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';

import 'package:gsec/models/user.dart';
import 'package:gsec/providers/base_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/providers/user_provider.dart';
import 'package:gsec/widgets/device_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  SIGNED_IN,
  SIGNED_OUT,
  LOADING,
  SAFE_LOADING,
}

class Auth extends BaseProvider {
  // Device provider
  final DeviceProvider _deviceProvider = DeviceProvider();
  DeviceProvider get deviceProvider => _deviceProvider;

  // User provider
  final UserProvider _userProvider = UserProvider();

  // current state of the app
  AuthState _state = AuthState.SIGNED_OUT;

  // logged in Client
  Client? _currentUser;
  Client? get currentUser => _currentUser;

  // state getter
  AuthState get state => _state;
  set state(AuthState state) {
    _state = state;
    notifyListeners();
  }

  // auto retrieve verification id
  String? verificationId;

  UserProvider get userProvider => _userProvider;

  Future<void> setPersistentLogin(Client user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    List<String> data = Client.toList(user);
    prefs.setStringList("userData", data);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool("isLoggedIn") ?? false;
    if (status) {
      List<String>? data = prefs.getStringList("userData");
      if (data != null) {
        _currentUser = Client.fromList(data);
        _state = AuthState.SIGNED_IN;
      } else {
        _state = AuthState.SIGNED_OUT;
      }
    } else {
      _state = AuthState.SIGNED_OUT;
    }
    notifyListeners();
  }

  Future<void> resetPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _state = AuthState.LOADING;
    notifyListeners();
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user != null) {
        final user = result.user!;
        DocumentReference<Map<String, dynamic>> reference =
            FirebaseFirestore.instance.collection("users").doc(user.uid);
        DocumentSnapshot<Map<String, dynamic>> snapshot = await reference.get();

        if (snapshot.exists) {
          _currentUser = Client.fromMap(snapshot.data()!);
          await setPersistentLogin(_currentUser!);
          _state = AuthState.SIGNED_IN;
          notifyListeners();
          return true;
        }
      }
    } on FirebaseAuthException {
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return false;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Bad internet");
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return false;
    }

    _state = AuthState.SIGNED_OUT;
    notifyListeners();
    return false;
  }

  Future<String> resetPassword(String email) async {
    String message;
    try {
      _state = AuthState.LOADING;
      notifyListeners();

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      message = "Check Your Email";
    } catch (e) {
      message = "Error: ${e.toString()}";
    }
    _state = AuthState.SIGNED_OUT;
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    _state = AuthState.LOADING;
    notifyListeners();
    Fluttertoast.showToast(msg: "See you later");
    await FirebaseAuth.instance.signOut();
    _state = AuthState.SIGNED_OUT;
    notifyListeners();
    await resetPrefs();
  }

  Future<Client?> searchDeviceById(String identifier) async {
    AuthState temp = _state;
    _state = AuthState.SAFE_LOADING;
    notifyListeners();

    DocumentSnapshot shot = await FirebaseFirestore.instance
        .collection("devices")
        .doc(identifier)
        .get();

    if (shot.exists) {
      String uid = shot['ownerId'];
      DocumentSnapshot<Map<String,dynamic>> ushot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (ushot.exists) {
        _state = temp;
        notifyListeners();
        return Client.fromMap(ushot.data()!);
      }
    }

    _state = temp;
    notifyListeners();
    return null;
  }

  Future<String?> registerUser(
    String name,
    String surname,
    String email,
    String password,
    String phone,
    String gId,
  ) async {
    _state = AuthState.LOADING;
    notifyListeners();

    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        User user = authResult.user!;
        await authenticateViaPhone(phone);

        Map<String, String> _userInfo = {
          "name": name,
          "surname": surname,
          "email": email,
          "password": password,
          "phone": phone,
          "governmentId": gId,
          "id": user.uid
        };

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(_userInfo);

        _state = AuthState.SIGNED_OUT;
        notifyListeners();
        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }

    _state = AuthState.SIGNED_OUT;
    notifyListeners();
    return null;
  }

  Future<void> authenticateViaPhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Fluttertoast.showToast(msg: "Phone verification Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: "Phone verification Failed: ${e.message}");
      },
      codeSent: (String verID, int? forceCodeResend) {
        verificationId = verID;
        Fluttertoast.showToast(msg: "Phone verification code sent");
      },
      codeAutoRetrievalTimeout: (String verID) {
        verificationId = verID;
      },
    );
  }

  Future<String> uploadDocument(File file, String link) async {
    _state = AuthState.LOADING;
    notifyListeners();

    final storageRef = FirebaseStorage.instance.ref().child('$link${currentUser!.id}');
    final uploadTask = storageRef.putFile(file);

    final taskSnapshot = await uploadTask;
    final url = await taskSnapshot.ref.getDownloadURL();

    _state = AuthState.SIGNED_IN;
    notifyListeners();
    return url;
  }

  Future<void> updateUser({
    required String name,
    required String city,
    required String email,
    required String idNumber,
    required String phone,
    required String userId,
    required String middlename,
    required String surname,
    required String country,
    required String imageUrl,
  }) async {
    final data = {
      "email": email,
      "city": city,
      "name": name,
      "governmentId": idNumber,
      "phone": phone,
      "surname": surname,
      "middlename": middlename,
      "country": country,
      "imageUrl": imageUrl
    };

    _state = AuthState.LOADING;
    notifyListeners();

    await FirebaseFirestore.instance.collection("users").doc(currentUser!.id).update(data);
    Fluttertoast.showToast(msg: "User details changed");

    final shot = await FirebaseFirestore.instance.collection("users").doc(currentUser!.id).get();
    _currentUser = Client.fromMap(shot.data()!);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<void> uploadFile(File file, {String? filename}) async {
    _state = AuthState.LOADING;
    notifyListeners();

    filename ??= currentUser!.id;
    final storageRef = FirebaseStorage.instance.ref().child(filename);
    final uploadTask = storageRef.putFile(file);

    final taskSnapshot = await uploadTask;
    final url = await taskSnapshot.ref.getDownloadURL();

    final data = {"imageUrl": url};
    await FirebaseFirestore.instance.collection("users").doc(currentUser!.id).update(data);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<void> addDevice(Device device, File file) async {
    _state = AuthState.LOADING;
    notifyListeners();

    final url = await uploadDocument(file, "/${device.identifier}/");

    await _deviceProvider.addDevice(device, url: url);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<void> transfer(Client to, Device device) async {
    _state = AuthState.LOADING;
    notifyListeners();

    await _deviceProvider.transfer(to, device);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<Client> GetUserBySsn(String barcode) async {
    AuthState _tempState = _state;
    _state = AuthState.SAFE_LOADING;
    notifyListeners();

    DocumentSnapshot<Map<String,dynamic>> shot =
        await firestore.collection("primary").doc(barcode).get();

    String uid = shot.data()!["uid"];

    DocumentSnapshot<Map<String,dynamic>> ushot =
        await firestore.collection('users').doc(uid).get();

    _state = _tempState;
    notifyListeners();

    return Client.fromMap(ushot.data()!);
  }

  Future<Action> confirmWithPin(String pin) async {
    var doc = await firestore
        .collection("security_info")
        .doc("${currentUser!.id}")
        .get();
    var data = doc.data()!;
    if (pin == data["safe"]) {
      return Action.OK;
    } else if (pin == data["alert"]) {
      return Action.ALERT;
    } else {
      return Action.NO;
    }
  }

  void alertSecurity(User peer) {
    sendSMS(
      message: "I am in an emergency please contact the authorities\n " +
          peer.toString(),
      recipients: ["+26777147912"],
    );
  }
  
  @override
  void initializePreferences()  {
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
    });
  }
}
