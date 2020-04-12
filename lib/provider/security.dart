//import 'package:drifter/drifter.dart';
import 'package:flutter/material.dart';
import 'package:sim_info/sim_info.dart';

class Security extends ChangeNotifier {
/// 

  Security() {
    _initDevice();
    _initSim();
  }

  Map<String, String> get simInfo => _simInfo;
  Map<String, String> _simInfo = {};

  Map<String, String> get deviceInfo => _deviceInfo;
  Map<String, String> _deviceInfo = {};

  Future<void> _initSim() async {
    //_simInfo['carrier'] = await SimInfo.getCarrierName;
    //_simInfo['countryCode'] = await SimInfo.getMobileCountryCode;
    //_simInfo['networkCode'] = await SimInfo.getMobileNetworkCode;
    //_simInfo['country'] = await SimInfo.getIsoCountryCode;
  }

  Future<void> _initDevice() async {
    //_deviceInfo['imsi'] = await Drifter.imsi();
    //_deviceInfo['imei'] = await Drifter.imei();
    //_deviceInfo['id'] = await Drifter.deviceId();
    //_deviceInfo['id'] = await Drifter.wifiMacAddress();
  }
}
