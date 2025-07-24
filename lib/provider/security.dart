//import 'package:drifter/drifter.dart'; // This package appears to be outdated
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sim_info/sim_info.dart';

class Security extends ChangeNotifier {
  Security() {
    _initDevice();
    _initSim();
  }

  Map<String, String?> get simInfo => _simInfo;
  final Map<String, String?> _simInfo = {};

  Map<String, String?> get deviceInfo => _deviceInfo;
  final Map<String, String?> _deviceInfo = {};

  Future<void> _initSim() async {
    try {
      // Note: Some of these methods may not be available in newer versions
      // You may need to check the sim_info package documentation
      _simInfo['carrier'] = await SimInfo.getCarrierName;
      _simInfo['countryCode'] = await SimInfo.getMobileCountryCode;
      _simInfo['networkCode'] = await SimInfo.getMobileNetworkCode;
      _simInfo['country'] = await SimInfo.getIsoCountryCode;
      
      notifyListeners();
    } catch (e) {
      print('Error initializing SIM info: $e');
      // Fallback values or error handling
    }
  }

  Future<void> _initDevice() async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      
      // Get device information based on platform
      if (Theme.of(WidgetsBinding.instance.window.platformDispatcher as BuildContext).platform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        _deviceInfo['model'] = androidInfo.model;
        _deviceInfo['manufacturer'] = androidInfo.manufacturer;
        _deviceInfo['brand'] = androidInfo.brand;
        _deviceInfo['device'] = androidInfo.device;
        _deviceInfo['id'] = androidInfo.id;
        _deviceInfo['androidId'] = androidInfo.androidId;
      } else if (Theme.of(WidgetsBinding.instance.window.platformDispatcher as BuildContext).platform == TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        _deviceInfo['model'] = iosInfo.model;
        _deviceInfo['name'] = iosInfo.name;
        _deviceInfo['systemName'] = iosInfo.systemName;
        _deviceInfo['systemVersion'] = iosInfo.systemVersion;
        _deviceInfo['identifierForVendor'] = iosInfo.identifierForVendor;
      }
      
      notifyListeners();
    } catch (e) {
      print('Error initializing device info: $e');
      // Fallback values or error handling
    }
  }

  /// Get a unique device identifier for security purposes
  String? get deviceIdentifier {
    // Use the most appropriate identifier based on platform
    return _deviceInfo['androidId'] ?? _deviceInfo['identifierForVendor'];
  }

  /// Check if device information is loaded
  bool get isDeviceInfoLoaded => _deviceInfo.isNotEmpty;

  /// Check if SIM information is loaded  
  bool get isSimInfoLoaded => _simInfo.isNotEmpty;

  /// Refresh device and SIM information
  Future<void> refresh() async {
    await _initDevice();
    await _initSim();
  }
}
