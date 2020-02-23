class Device {
  final String identifier;
  final String ownerId;
  final String name;
  final String type;
  final String imei;
  final bool confirmed;

  Device(this.identifier, this.ownerId, this.name,
      {this.type, this.imei, this.confirmed = false});

  // converts a map from database to Device object
  factory Device.fromMap(Map map) {
    String _identifier = map['identifier'];
    String _ownerId = map["ownerId"];
    String _name = map["name"];
    String _type = map["type"] ?? '';
    String _imei = map['imei'] ?? "";
    bool _confirmed = bool.fromEnvironment(map['confirmed'] ?? "false");

    return Device(
      _identifier,
      _ownerId,
      _name,
      type: _type,
      imei: _imei,
      confirmed: _confirmed,
    );
  }

  static List<Device> get devices =>
      List<Device>.generate(5, (i) => Device("$i", "001", "device $i"));

  static Map toMap(Device device) {
    return <String, String>{
      "identifier": device.identifier,
      "ownerId": device.ownerId,
      "name": device.name,
      'imei': device.imei,
      "confirmed":device.confirmed.toString()
    };
  }
}

enum entityType {
  MOBILE,
  VEHICLE,
  LAPTOPorTV,
  PC,
  FRIDGE,
  CAMERA,
  RADIO,
  OTHER
}
