import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/base_provider.dart';

class DeviceProvider extends BaseProvider {
  /// list of user's devices
  List<Device> _myDevices = [];
  List<Device> get myDevices => _myDevices;

  /// device info
  Map<String, String> _details = new Map();
  Map<String, String> get details => _details;

  /// Device owner info
  User _owner;
  User get owner => _owner;

  /// returns the device's owner using [ssn] as the indetifier
  Future<User> fetchUser() async {
    try {
      var did = _details['identifier'];

      var docRef = firestore.collection('primary').document(did);
      var docSnap = await docRef.get();
      if (docSnap.exists) {
        // fetch user id from the device document
        var uid = docSnap.data['uid'];
        print(uid);

        //fetch user info using [uid]
        docRef = firestore.collection('users').document(uid);

        docSnap = await docRef.get();

        var map = docSnap.data;

        return User.fromMap(map);
      }

      // return nothing if user not registered
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Device Offline');
      return null;
    }
  }

  DeviceProvider() {
    initDeviceInfo();
  }

  /// fetch device information locally
  Future<void> initDeviceInfo() async {
    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var info = await infoPlugin.androidInfo;

      _details = {
        'identifier': info.androidId,
        'model': info.model,
        'name': info.brand
      };
    } else if (Platform.isIOS) {
      var info = await infoPlugin.iosInfo;

      _details = {
        'identifier': info.identifierForVendor,
        'model': info.model,
        'name': info.name
      };
    }

    // fetch owner details from the database
    if (_details.containsKey('identifier')) {
      _owner = await fetchUser();
      print('The device belongs to ${_owner?.name}');
      notifyListeners();
    }

    notifyListeners();
    return null;
  }

  ///store the current device info to the database
  Future<bool> savePrimaryDevice(String uid) async {
    // fetch the device serial number and determine if it exists in db
    var _id = _details['identifier'];
    var docRef = firestore.collection('primary').document(_id);
    var docSnap = await docRef.get();
    if (!docSnap.exists) {
      _details['uid'] = uid;
      docRef.setData(_details);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> addDevice(Device device) async {
    Map _details = Device.toMap(device);
    print(_details);
    await firestore
        .collection("devices")
        .document(device.identifier)
        .setData(_details);
  }

  Future<void> transfer(User to, Device device) async {
    await firestore
        .collection("devices")
        .document(device.identifier)
        .updateData({"ownerId": to.id});
  }

  Future<void> removeDevice(Device device) async {
    await firestore.collection("devices").document(device.identifier).delete();
    notifyListeners();
  }
}
