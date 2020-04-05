class Student {
  String name;
  String level;
  String password;
  String ssn;
  String email;
  String phone;
  String semester;
  String academicYear;
  String image;
  String id;

  Student({
    name,
    password,
    level,
    ssn,
    email,
    phone,
    semester,
    academicYear,
    id,
    image,
  }) {
    this.name = name;
    this.password = password;
    this.level = level;
    this.ssn = ssn;
    this.email = email;
    this.phone = phone;
    this.semester = semester;
    this.academicYear = academicYear;
    this.id = id;
    this.image = image;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'password': this.password,
      'level': this.level,
      'ssn': this.ssn,
      'email': this.email,
      'phone': this.phone,
      'semester': this.semester,
      'academicYear': this.academicYear,
      'image': this.image,
      'id': this.id,
    };
  }

  factory Student.fromMap(Map map) {
    return Student(
      name: map['name'],
      password: map['password'],
      level: map['level'],
      ssn: map['ssn'],
      email: map['email'],
      phone: map['phone'],
      semester: map['semester'],
      academicYear: map['academicYear'],
      image: map['image'],
      id: map['id'],
    );
  }

  String get getId => id;

  set setId(String id) => this.id = id;

  String get getName => name;

  String get getImage => image;

  set setImage(String image) => this.image = image;

  set setName(String name) => this.name = name;

  String get getLevel => level;

  set setLevel(String level) => this.level = level;

  String get getPassword => password;

  set setPassword(String password) => this.password = password;

  String get getSsn => ssn;

  set setSsn(String ssn) => this.ssn = ssn;

  String get getEmail => email;

  set setEmail(String email) => this.email = email;

  String get getPhone => phone;

  set setPhone(String phone) => this.phone = phone;

  String get getSemester => semester;

  set setSemester(String semester) => this.semester = semester;

  String get getAcademicYear => academicYear;

  set setAcademicYear(String academicYear) => this.academicYear = academicYear;
}
