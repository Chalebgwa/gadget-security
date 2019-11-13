import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/base_provider.dart';

class DeviceProvider extends BaseProvider {
  List<Device> _myDevices = [];
  List<Device> get myDevices => _myDevices;

  Future<User> fetchUser(String ssn) async {
    DocumentSnapshot shot =
        await firestore.collection("primary").document(ssn).get();
    Map data = shot.data;
    String uid = data['uid'];
    DocumentSnapshot ushot =
        await firestore.collection("users").document(uid).get();
    Map map = ushot.data;
    return User.fromMap(map);
  }

  Future<String> fetchDeviceID() async {
    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var info = await infoPlugin.androidInfo;
      return info.androidId;
    } else if (Platform.isIOS) {
      var info = await infoPlugin.iosInfo;
      return info.identifierForVendor;
    }
    return null;
  }

  //fetch current user's devices from database
  Future<void> init(Auth auth) async {}

  // uses the provided device id to return its owner
  Future<User> findOwnerByDeviceId(String identifier) async {
    // 1: search device
    // 2 : get device owner id
    // 3 : use owner id to get user
    // 4 return Owner map

    Map dummy = {
      "name": "test",
      "surname": "pilot",
      "email": "testpilot@gmail.com",
      "phone": "77147912",
      "city": "Francistown",
      "country": "Botswana",
      "gorvenmentId": "728018011",
      "id": "001"
    };

    return User.fromMap(dummy);
  }

  // transfer device ownership to the provided user
  Future<void> transferTo(Device device, User from, User to) async {
    // 1: delete the device in from's collection
    // 2: add the device in to's collection
    //
  }

  Future<bool> savePrimaryDevice(Map info, String uid) async {
    
    // fetch the device serial number and determine if it exists in db
    String identifier = info["identifier"];
    var doc = firestore.collection("primary").document(identifier);
    var snapshot = await doc.get();
    if (!snapshot.exists) {

      //  if device doesnts already exist add the the owner's uid the device info
      info["uid"] = uid;
      doc.setData(info);
      return true;
    }
    return false;
  }

  Future<User> fetchUserByDevice(String deviceId) async {
    var ref = firestore.collection("primary").document(deviceId);
    var snapshot = await ref.get();
    var data = snapshot.data;
    String uid = data["uid"];
    var userdata = await firestore.collection("users").document(uid).get();
    return User.fromMap(userdata.data);
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
