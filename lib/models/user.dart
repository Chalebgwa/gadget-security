class User {
  final String name;
  final String surname;
  final String id;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String gorvenmentId;
  final String imageUrl;

  User(this.name, this.id, this.email, this.phone, this.city, this.country,
      this.gorvenmentId, this.surname, this.imageUrl);

  factory User.fromMap(Map map) {
    String _name = map["name"];
    String _id = map["id"];
    String _email = map["email"];
    String _phone = map["phone"];
    String _city = map["city"];
    String _country = map["country"];
    String _gorvenmentId = map["gorvenmentId "];
    String _surname = map["surname"];
    String _image = map["imageUrl"] ?? "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6";

    return User(
        _name, _id, _email, _phone, _city, _country, _gorvenmentId, _surname,_image);
  }

  static List<User> get users => List.generate(30,(i)=>User("name$i","$i","user.$i@test.com","","","","","","")) ;
}
