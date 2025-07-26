class Client {
  final String name;
  final String surname;
  final String id;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String governmentId;
  final String imageUrl;

  // calculates progress
  int _progress = 0;

  Client(this.name, this.id, this.email, this.phone, this.city, this.country,
      this.governmentId, this.surname, this.imageUrl);

  factory Client.fromList(List<String> data) {
    String _name = data[0];
    String _id = data[1];
    String _email = data[2];
    String _phone = data[3];
    String _city = data[4];
    String _country = data[5];
    String _governmentId = data[6];
    String _surname = data[7];
    String _image = data[8] ??
        "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6";

    return Client(_name, _id, _email, _phone, _city, _country, _governmentId,
        _surname, _image);
  }

  factory Client.fromMap(Map map) {
    String _name = map["name"];
    String _id = map["id"];
    String _email = map["email"];
    String _phone = map["phone"];
    String _city = map["city"];
    String _country = map["country"];
    String _governmentId = map["governmentId"] ?? "";
    String _surname = map["surname"];
    String _image = map["imageUrl"] ??
        "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6";

    return Client(_name, _id, _email, _phone, _city, _country, _governmentId,
        _surname, _image);
  }

  get progress => null;

  static toList(Client user) {
    return [
      user.name,
      user.id,
      user.email,
      user.phone,
      user.city,
      user.country,
      user.governmentId,
      user.surname,
      user.imageUrl,
    ];
  }

  @override
  String toString() {
    return "firstname: $name, lastname: $surname , id: $id";
  }

  static List<Client> get users => List.generate(
      30,
      (i) =>
          Client("name$i", "$i", "user.$i@test.com", "", "", "", "", "", ""));
}
