import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';

import 'package:gsec/models/user.dart';
import 'package:gsec/providers/base_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  SIGNED_IN,
  SIGNED_OUT,
  LOADING,
  SAFE_LOADING,
}

class Auth extends BaseProvider {
  //Device provider
  DeviceProvider _deviceProvider = new DeviceProvider();
  DeviceProvider get deviceProvider => _deviceProvider;

  //User provider
  UserProvider _userProvider = new UserProvider();

  // current state of the app
  AuthState _state = AuthState.SIGNED_OUT;

  // logged in user
  User _currentUser;

  User get currentUser => _currentUser;

  // state getter
  AuthState get state => _state;

  set state(AuthState state) {
    _state = state;

    notifyListeners();
  }

  // auto retrieve verification id
  String verificationId;

  UserProvider get userProvider => _userProvider;

  Future<void> setPersistantLogin(User user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    List<String> data = User.toList(user);
    prefs.setStringList("userData", data);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    var prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool("isLoggedIn") ?? false;
    print(status);
    if (status) {
      List<String> data = prefs.getStringList("userData");
      if (data != null) {
        print(data);
        _currentUser = User.fromList(data);
        _state = AuthState.SIGNED_IN;
        notifyListeners();
      }
    } else {
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
    }
  }

  Future<void> resetPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
  }

  Future<bool> signInWithEmail(String email, String password) async {
    //set the screen to show loading
    _state = AuthState.LOADING;
    notifyListeners();
    email = email.trim();
    // lets play
    try {
      AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result != null) {
        FirebaseUser user = result.user;
        DocumentReference reference =
            firestore.collection("users").document(user.uid);
        DocumentSnapshot snapshot = await reference.get();

        _currentUser = User.fromMap(snapshot.data);
        // set persistant login
        setPersistantLogin(_currentUser);
        _state = AuthState.SIGNED_IN;
        notifyListeners();
        return true;
      }
    } on PlatformException {
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return false;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Bad internet");
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return false;
    } on AuthException {
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<String> resetPassword(String email) async {
    String message;
    try {
      _state = AuthState.LOADING;
      notifyListeners();
      //trigger loading screen

      firebaseAuth.sendPasswordResetEmail(email: email);

      message = "Check Your Email";
    } catch (e) {
      message = "error";
    }
    _state = AuthState.SIGNED_OUT;
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    _state = AuthState.LOADING;
    notifyListeners();
    Fluttertoast.showToast(msg: "See you later");
    await firebaseAuth.signOut().then((b) {
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      resetPrefs();
      print("logged out");
    });
  }

  Future<User> searchDeviceById(String identifier) async {
    //the state to return to after loading
    AuthState temp = _state;
    // display looading screen while fetching data
    _state = AuthState.SAFE_LOADING;
    notifyListeners();
    //print(identifier);
    DocumentSnapshot shot = await Firestore.instance
        .collection("devices")
        .document(identifier)
        .get();
    if (shot.exists) {
      String uid = shot['ownerId'];
      DocumentSnapshot ushot =
          await firestore.collection("users").document(uid).get();
      if (ushot.exists) {
        _state = temp;
        notifyListeners();
        return User.fromMap(ushot.data);
      }
    }
    _state = temp;
    notifyListeners();
    return null;
  }

  Future<String> registerUser(
    String name,
    String surname,
    String email,
    String password,
    String phone,
    String gId,
  ) async {
    //show loading screen
    _state = AuthState.LOADING;
    notifyListeners();

    try {
      // create user here
      AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // incase anything goes wrong
      // todo : find out what could actually go wrong
      if (authResult != null) {
        FirebaseUser _user = authResult.user;
        await authenticateViaPhone(phone);
        Map<String, String> _userInfo = {
          "name": name,
          "surname": surname,
          "email": email,
          "password": password,
          "phone": phone,
          "gorvenmentId ": gId,
          "id": _user.uid
        };

        await firestore
            .collection("users")
            .document(_user.uid)
            .setData(_userInfo);

        _state = AuthState.SIGNED_OUT;
        notifyListeners();

        return _user.uid;
      }
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return null;
    } on PlatformException catch (e) {
      print(e.message);
      _state = AuthState.SIGNED_OUT;
      notifyListeners();
      return null;
    }
  }

  Future<void> authenticateViaPhone(String phone) async {
    print(phone);
    // auto retrieve verification code
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
    };

    final PhoneCodeSent codeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;
      print(verID);
      Fluttertoast.showToast(msg: "Phone verification code sent");
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      print(credential);
      Fluttertoast.showToast(msg: "Phone verification Completed");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      Fluttertoast.showToast(msg: "Phone verification Failed");
    };

    await firebaseAuth.verifyPhoneNumber(
      codeAutoRetrievalTimeout: autoRetrieve,
      phoneNumber: phone,
      codeSent: codeSent,
      timeout: const Duration(microseconds: 0),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
    );
  }

  Future<String> uploadImage(File image) async {
    _state = AuthState.LOADING;
    notifyListeners();

    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(currentUser.id);

    StorageUploadTask uploadTask = storageRef.putFile(image);

    await uploadTask.onComplete;

    String url = await storageRef.getDownloadURL();

    _state = AuthState.SIGNED_IN;
    notifyListeners();

    return url;
  }

  Future<void> updateUser(
      {name,
      city,
      email,
      idNumber,
      phone,
      userId,
      middlename,
      surname,
      country,
      imageUrl}) async {
    var data = {
      "email": email,
      "city": city,
      "name": name,
      "gorvenmentId": idNumber,
      "phone": phone,
      "surname": surname,
      "middlename": middlename,
      "country": country,
      "imageUrl": imageUrl
    };

    _state = AuthState.LOADING;
    notifyListeners();

    await firestore
        .collection("users")
        .document(_currentUser.id)
        .updateData(data);
    Fluttertoast.showToast(msg: "user details changed");
    _state = AuthState.SIGNED_IN;

    DocumentSnapshot shot =
        await firestore.collection("users").document(_currentUser.id).get();
    _currentUser = User.fromMap(shot.data);

    notifyListeners();
  }

  Future<bool> updateProfileImage(File image) async {
    //set loading screen
    _state = AuthState.LOADING;
    notifyListeners();

    String filename = _currentUser.id;
    StorageReference reference = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    print(url);

    Map<String, String> data = {"imageUrl": url};
    await firestore
        .collection("users")
        .document(_currentUser.id)
        .updateData(data);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    _state = AuthState.LOADING;
    notifyListeners();

    await _deviceProvider.addDevice(device);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<void> transfer(User to, Device device) async {
    _state = AuthState.LOADING;
    notifyListeners();

    await _deviceProvider.transfer(to, device);

    _state = AuthState.SIGNED_IN;
    notifyListeners();
  }

  Future<User> GetUserBySsn(String barcode) async {
    AuthState _tempState = _state;
    _state = AuthState.SAFE_LOADING;
    notifyListeners();

    DocumentSnapshot shot =
        await firestore.collection("primary").document(barcode).get();

    String uid = shot.data['uid'];

    DocumentSnapshot ushot =
        await firestore.collection('users').document(uid).get();

    _state = _tempState;
    notifyListeners();

    return User.fromMap(ushot.data);
  }
}
