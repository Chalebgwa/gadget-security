//import 'package:drifter/drifter.dart'; // This package appears to be outdated
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sim_info/sim_info.dart';
import 'dart:io';

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
      if (!kIsWeb && Platform.isAndroid || Platform.isIOS) {
        _simInfo['carrier'] = await SimInfo.getCarrierName;
        _simInfo['countryCode'] = await SimInfo.getMobileCountryCode;
        _simInfo['networkCode'] = await SimInfo.getMobileNetworkCode;
        _simInfo['country'] = await SimInfo.getIsoCountryCode;
      }
      
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
      if (!kIsWeb && Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        _deviceInfo['model'] = androidInfo.model;
        _deviceInfo['manufacturer'] = androidInfo.manufacturer;
        _deviceInfo['brand'] = androidInfo.brand;
        _deviceInfo['device'] = androidInfo.device;
        _deviceInfo['id'] = androidInfo.id;
        _deviceInfo['androidId'] = androidInfo.androidId;
      } else if (!kIsWeb && Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        _deviceInfo['model'] = iosInfo.model;
        _deviceInfo['name'] = iosInfo.name;
        _deviceInfo['systemName'] = iosInfo.systemName;
        _deviceInfo['systemVersion'] = iosInfo.systemVersion;
        _deviceInfo['identifierForVendor'] = iosInfo.identifierForVendor;
      } else if (kIsWeb) {
        final WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        _deviceInfo['userAgent'] = webInfo.userAgent;
        _deviceInfo['platform'] = webInfo.platform;
        _deviceInfo['vendor'] = webInfo.vendor;
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
    if (!kIsWeb && Platform.isAndroid) {
      return _deviceInfo['androidId'];
    } else if (!kIsWeb && Platform.isIOS) {
      return _deviceInfo['identifierForVendor'];
    } else if (kIsWeb) {
      return _deviceInfo['userAgent']; // Not ideal but works for web
    }
    return null;
  }

  /// Check if device information is loaded
  bool get isDeviceInfoLoaded => _deviceInfo.isNotEmpty;

  /// Check if SIM information is loaded  
  bool get isSimInfoLoaded => _simInfo.isNotEmpty;

  /// Get platform-specific device description
  String get deviceDescription {
    if (!kIsWeb && Platform.isAndroid) {
      return '${_deviceInfo['manufacturer']} ${_deviceInfo['model']}';
    } else if (!kIsWeb && Platform.isIOS) {
      return '${_deviceInfo['name']} (${_deviceInfo['model']})';
    } else if (kIsWeb) {
      return 'Web Browser on ${_deviceInfo['platform']}';
    }
    return 'Unknown Device';
  }

  /// Refresh device and SIM information
  Future<void> refresh() async {
    await _initDevice();
    await _initSim();
  }

  /// Check if the current device is secure based on various factors
  bool get isDeviceSecure {
    // Basic security checks - can be expanded
    if (!kIsWeb && Platform.isAndroid) {
      // Check if device ID is available (indicates proper device access)
      return _deviceInfo['androidId'] != null && _deviceInfo['androidId']!.isNotEmpty;
    } else if (!kIsWeb && Platform.isIOS) {
      return _deviceInfo['identifierForVendor'] != null && _deviceInfo['identifierForVendor']!.isNotEmpty;
    }
    return true; // Assume web is secure for now
  }
}
