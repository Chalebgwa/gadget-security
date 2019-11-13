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
    String _gorvenmentId = map["gorvernmentId"];
    String _surname = map["surname"];
    String _image = map["imageUrl"];

    return User(
        _name, _id, _email, _phone, _city, _country, _gorvenmentId, _surname,_image);
  }

  static List<User> get users => List.generate(30,(i)=>User("name$i","$i","user.$i@test.com","","","","","","")) ;
}
