class Device {
  final String identifier;
  final String ownerId;
  final String name;
  final String type;

  Device(this.identifier, this.ownerId, this.name, {this.type});

  // converts a map from database to Device object
  factory Device.fromMap(Map map) {
    String _identifier = map['identifier'];
    String _ownerId = map["ownerId"];
    String _name = map["name"];
    String _type = map["type"] ?? ' ';

    return Device(_identifier, _ownerId, _name, type: _type);
  }

  static List<Device> get devices =>
      List<Device>.generate(5, (i) => Device("$i", "001", "device $i"));

  static Map toMap(Device device) {
    return <String,String>{
      "identifier": device.identifier,  
      "ownerId": device.ownerId,
      "name": device.name
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
