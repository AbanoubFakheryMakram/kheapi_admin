class Admin {
  String name;
  String username;
  String password;
  String code;

  Admin({this.name, this.username, this.password, this.code});

  factory Admin.fromMap(Map map) {
    return Admin(
      name: map['name'],
      username: map['username'],
      password: map['password'],
      code: map['code'],
    );
  }

  Map adminToMap() {
    return <String, String>{
      'name': this.name,
      'username': this.username,
      'password': this.password,
      'code': this.code,
    };
  }
}
