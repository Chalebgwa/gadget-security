class User {
  final String name;
  final String surname;
  final String id;
  final String email;
  final String phone;
  final String? city;
  final String? country;
  final String? governmentId;
  final String imageUrl;

  // calculates progress
  int _progress = 0;

  User({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.surname,
    this.city,
    this.country,
    this.governmentId,
    String? imageUrl,
  }) : imageUrl = imageUrl ?? _defaultImageUrl;

  static const String _defaultImageUrl = 
    "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6";

  factory User.fromList(List<String> data) {
    if (data.length < 8) {
      throw ArgumentError('Insufficient data for User creation');
    }
    
    return User(
      name: data[0],
      id: data[1],
      email: data[2],
      phone: data[3],
      city: data.length > 4 ? data[4] : null,
      country: data.length > 5 ? data[5] : null,
      governmentId: data.length > 6 ? data[6] : null,
      surname: data.length > 7 ? data[7] : '',
      imageUrl: data.length > 8 ? data[8] : null,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map["name"] ?? '',
      id: map["id"] ?? '',
      email: map["email"] ?? '',
      phone: map["phone"] ?? '',
      city: map["city"],
      country: map["country"],
      governmentId: map["governmentId"] ?? map["gorvenmentId "], // Handle typo
      surname: map["surname"] ?? '',
      imageUrl: map["imageUrl"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phone': phone,
      'city': city,
      'country': country,
      'governmentId': governmentId,
      'surname': surname,
      'imageUrl': imageUrl,
    };
  }

  int get progress => _progress;

  static List<String> toList(User user) {
    return [
      user.name,
      user.id,
      user.email,
      user.phone,
      user.city ?? '',
      user.country ?? '',
      user.governmentId ?? '',
      user.surname,
      user.imageUrl,
    ];
  }

  @override
  String toString() {
    return "firstname: $name, lastname: $surname, id: $id";
  }

  User copyWith({
    String? name,
    String? surname,
    String? id,
    String? email,
    String? phone,
    String? city,
    String? country,
    String? governmentId,
    String? imageUrl,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      governmentId: governmentId ?? this.governmentId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static List<User> get users => List.generate(
    30,
    (i) => User(
      name: "name$i",
      id: "$i",
      email: "user.$i@test.com",
      phone: "",
      surname: "",
    ),
  );
}
