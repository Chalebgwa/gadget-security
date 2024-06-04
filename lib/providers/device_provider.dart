import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceProvider extends BaseProvider {
  /// list of user's devices
  List<Device> _myDevices = [];
  List<Device> get myDevices => _myDevices;

  /// device info
  Map<String, String> _details = {};
  Map<String, String> get details => _details;

  /// Device owner info
  Client? _owner;
  Client? get owner => _owner;

  DeviceProvider() {
    initDeviceInfo();
  }

  /// returns the device's owner using [ssn] as the identifier
  Future<Client?> fetchUser() async {
    try {
      var did = _details['identifier'];
      if (did == null) {
        return null;
      }

      var docRef = firestore.collection('primary').doc(did);
      var docSnap = await docRef.get();
      if (docSnap.exists) {
        // fetch user id from the device document
        var uid = docSnap.data()!['uid'];
        print(uid);

        // fetch user info using [uid]
        docRef = firestore.collection('users').doc(uid);
        docSnap = await docRef.get();
        var map = docSnap.data();

        return map != null ? Client.fromMap(map) : null;
      }

      // return null if user not registered
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Device Offline');
      return null;
    }
  }

  /// fetch device information locally
  Future<void> initDeviceInfo() async {
    try {
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

    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to get device info');
    } finally {
      notifyListeners();
    }
  }

  /// store the current device info to the database
  Future<bool> savePrimaryDevice(String uid) async {
    try {
      var _id = _details['identifier'];
      if (_id == null) {
        return false;
      }
      var docRef = firestore.collection('primary').doc(_id);
      var docSnap = await docRef.get();
      if (!docSnap.exists) {
        _details['uid'] = uid;
        await docRef.set(_details);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to save device');
      return false;
    }
  }

  Future<void> addDevice(Device device, {String? url}) async {
    try {
      var _details = Device.toMap(device);
      if (url != null) {
        _details["document"] = url;
      }
      print(_details);
      await firestore.collection("devices").doc(device.identifier).set(_details);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add device');
    }
  }

  Future<void> transfer(Client to, Device device) async {
    try {
      await firestore.collection("devices").doc(device.identifier).update({"ownerId": to.id});
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to transfer device');
    }
  }

  Future<void> removeDevice(Device device) async {
    try {
      await firestore.collection("devices").doc(device.identifier).delete();
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to remove device');
    }
  }

  @override
  void initializePreferences() {
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
    });
  }
}
