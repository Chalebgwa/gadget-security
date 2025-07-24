import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String identifier;
  final String ownerId;
  final String name;
  final String? type;
  final String? imei;
  final String? serialNumber;
  final String? brand;
  final String? model;
  final bool confirmed;
  final DateTime? purchaseDate;
  final String? purchaseLocation;
  final double? purchasePrice;
  final String? description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Device({
    required this.identifier,
    required this.ownerId,
    required this.name,
    this.type,
    this.imei,
    this.serialNumber,
    this.brand,
    this.model,
    this.confirmed = false,
    this.purchaseDate,
    this.purchaseLocation,
    this.purchasePrice,
    this.description,
    this.imageUrls = const [],
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // converts a map from database to Device object
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      identifier: map['identifier'] ?? '',
      ownerId: map["ownerId"] ?? "",
      name: map["name"] ?? '',
      type: map["type"],
      imei: map['imei'],
      serialNumber: map['serialNumber'],
      brand: map['brand'],
      model: map['model'],
      confirmed: map['confirmed'] ?? false,
      purchaseDate: map['purchaseDate'] != null 
          ? (map['purchaseDate'] as Timestamp).toDate() 
          : null,
      purchaseLocation: map['purchaseLocation'],
      purchasePrice: map['purchasePrice']?.toDouble(),
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "identifier": identifier,
      "ownerId": ownerId,
      "name": name,
      "type": type,
      'imei': imei,
      'serialNumber': serialNumber,
      'brand': brand,
      'model': model,
      "confirmed": confirmed,
      'purchaseDate': purchaseDate != null ? Timestamp.fromDate(purchaseDate!) : null,
      'purchaseLocation': purchaseLocation,
      'purchasePrice': purchasePrice,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Device copyWith({
    String? identifier,
    String? ownerId,
    String? name,
    String? type,
    String? imei,
    String? serialNumber,
    String? brand,
    String? model,
    bool? confirmed,
    DateTime? purchaseDate,
    String? purchaseLocation,
    double? purchasePrice,
    String? description,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Device(
      identifier: identifier ?? this.identifier,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      imei: imei ?? this.imei,
      serialNumber: serialNumber ?? this.serialNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      confirmed: confirmed ?? this.confirmed,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseLocation: purchaseLocation ?? this.purchaseLocation,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Device(identifier: $identifier, name: $name, type: $type, confirmed: $confirmed)';
  }

  static List<Device> get sampleDevices => List<Device>.generate(
    5,
    (i) => Device(
      identifier: "device_$i",
      ownerId: "sample_user",
      name: "Sample Device $i",
      type: EntityType.mobile.name,
      confirmed: i % 2 == 0,
    ),
  );

  /// Generate a unique device identifier
  static String generateIdentifier() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

enum EntityType {
  mobile,
  vehicle,
  laptopOrTv,
  pc,
  fridge,
  camera,
  radio,
  smartwatch,
  tablet,
  headphones,
  speaker,
  gameConsole,
  other;

  String get displayName {
    switch (this) {
      case EntityType.mobile:
        return 'Mobile Phone';
      case EntityType.vehicle:
        return 'Vehicle';
      case EntityType.laptopOrTv:
        return 'Laptop/TV';
      case EntityType.pc:
        return 'Desktop Computer';
      case EntityType.fridge:
        return 'Refrigerator';
      case EntityType.camera:
        return 'Camera';
      case EntityType.radio:
        return 'Radio';
      case EntityType.smartwatch:
        return 'Smart Watch';
      case EntityType.tablet:
        return 'Tablet';
      case EntityType.headphones:
        return 'Headphones';
      case EntityType.speaker:
        return 'Speaker';
      case EntityType.gameConsole:
        return 'Game Console';
      case EntityType.other:
        return 'Other';
    }
  }
}