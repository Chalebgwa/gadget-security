import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart' as app_user;
import 'package:gsec/providers/base_provider.dart';

class DeviceProvider extends BaseProvider {
  /// list of user's devices
  List<Device> _myDevices = [];
  List<Device> get myDevices => _myDevices;

  /// device info
  Map<String, String> _details = {};
  Map<String, String> get details => _details;

  /// Device owner info
  app_user.User? _owner;
  app_user.User? get owner => _owner;

  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DeviceProvider() {
    initDeviceInfo();
  }

  /// Returns the device's owner using identifier
  Future<app_user.User?> fetchUser() async {
    try {
      final String? deviceId = _details['identifier'];
      if (deviceId == null) return null;

      final DocumentSnapshot primaryDoc = await firestore
          .collection('primary')
          .doc(deviceId)
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
                return app_user.User.fromMap(userData);
              }
            }
          }
        }
      }

      return null;
    } catch (e) {
      print('Error fetching user: $e');
      Fluttertoast.showToast(msg: 'Device Offline');
      return null;
    }
  }

  /// Fetch device information locally
  Future<void> initDeviceInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      final DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await infoPlugin.androidInfo;
        _details = {
          'identifier': info.androidId ?? '',
          'model': info.model,
          'name': info.brand,
          'manufacturer': info.manufacturer,
          'device': info.device,
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo info = await infoPlugin.iosInfo;
        _details = {
          'identifier': info.identifierForVendor ?? '',
          'model': info.model,
          'name': info.name,
          'systemName': info.systemName,
          'systemVersion': info.systemVersion,
        };
      }

      // Fetch owner details from the database
      if (_details.containsKey('identifier') && _details['identifier']!.isNotEmpty) {
        _owner = await fetchUser();
        print('The device belongs to ${_owner?.name ?? "unknown user"}');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error initializing device info: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Store the current device info to the database as primary device
  Future<bool> savePrimaryDevice(String uid) async {
    try {
      final String? deviceId = _details['identifier'];
      if (deviceId == null || deviceId.isEmpty) {
        Fluttertoast.showToast(msg: 'Unable to identify device');
        return false;
      }

      final DocumentReference docRef = firestore.collection('primary').doc(deviceId);
      final DocumentSnapshot docSnap = await docRef.get();
      
      if (!docSnap.exists) {
        final Map<String, dynamic> deviceData = Map<String, dynamic>.from(_details);
        deviceData['uid'] = uid;
        deviceData['registeredAt'] = FieldValue.serverTimestamp();
        
        await docRef.set(deviceData);
        notifyListeners();
        return true;
      }

      Fluttertoast.showToast(msg: 'Device already registered');
      return false;
    } catch (e) {
      print('Error saving primary device: $e');
      Fluttertoast.showToast(msg: 'Failed to register device');
      return false;
    }
  }

  /// Add a new device to the user's collection
  Future<bool> addDevice(Device device, {String? url}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final Map<String, dynamic> deviceData = device.toMap();
      if (url != null) {
        deviceData["documentUrl"] = url;
      }

      await firestore
          .collection("devices")
          .doc(device.identifier)
          .set(deviceData);

      // Add to local list if not already present
      if (!_myDevices.any((d) => d.identifier == device.identifier)) {
        _myDevices.add(device);
      }

      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Device added successfully');
      return true;
    } catch (e) {
      print('Error adding device: $e');
      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Failed to add device');
      return false;
    }
  }

  /// Transfer device ownership to another user
  Future<bool> transfer(app_user.User to, Device device) async {
    try {
      _isLoading = true;
      notifyListeners();

      await firestore
          .collection("devices")
          .doc(device.identifier)
          .update({
            "ownerId": to.id,
            "transferredAt": FieldValue.serverTimestamp(),
          });

      // Remove from local list
      _myDevices.removeWhere((d) => d.identifier == device.identifier);

      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Device transferred successfully');
      return true;
    } catch (e) {
      print('Error transferring device: $e');
      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Failed to transfer device');
      return false;
    }
  }

  /// Remove a device from the user's collection
  Future<bool> removeDevice(Device device) async {
    try {
      _isLoading = true;
      notifyListeners();

      await firestore.collection("devices").doc(device.identifier).delete();
      
      // Remove from local list
      _myDevices.removeWhere((d) => d.identifier == device.identifier);

      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Device removed successfully');
      return true;
    } catch (e) {
      print('Error removing device: $e');
      _isLoading = false;
      notifyListeners();
      
      Fluttertoast.showToast(msg: 'Failed to remove device');
      return false;
    }
  }

  /// Load user's devices from Firestore
  Future<void> loadUserDevices(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final QuerySnapshot snapshot = await firestore
          .collection("devices")
          .where("ownerId", isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .get();

      _myDevices = snapshot.docs
          .map((doc) => Device.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading user devices: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search for a device by identifier
  Future<Device?> searchDeviceByIdentifier(String identifier) async {
    try {
      final DocumentSnapshot doc = await firestore
          .collection("devices")
          .doc(identifier)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return Device.fromMap(data);
        }
      }
      
      return null;
    } catch (e) {
      print('Error searching device: $e');
      return null;
    }
  }

  /// Mark device as stolen
  Future<bool> reportStolen(Device device, String details) async {
    try {
      await firestore
          .collection("stolen_devices")
          .doc(device.identifier)
          .set({
            ...device.toMap(),
            "reportedAt": FieldValue.serverTimestamp(),
            "reportDetails": details,
            "status": "stolen",
          });

      Fluttertoast.showToast(msg: 'Device reported as stolen');
      return true;
    } catch (e) {
      print('Error reporting stolen device: $e');
      Fluttertoast.showToast(msg: 'Failed to report device');
      return false;
    }
  }

  /// Check if device is reported as stolen
  Future<bool> isDeviceStolen(String identifier) async {
    try {
      final DocumentSnapshot doc = await firestore
          .collection("stolen_devices")
          .doc(identifier)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking stolen status: $e');
      return false;
    }
  }
}
