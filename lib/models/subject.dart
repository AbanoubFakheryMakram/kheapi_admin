class Subject {
  String name;
  String code;
  String currentCount;
  String profName;
  String profID;
  String academicYear;
  String semester;

  Subject({
    name,
    code,
    currentCount,
    profName,
    profID,
    semester,
    academicYear,
  }) {
    this.name = name;
    this.code = code;
    this.currentCount = currentCount;
    this.profName = profName;
    this.profID = profID;
    this.semester = semester;
    this.academicYear = academicYear;
  }

  Map<String, String> subjectToMap() {
    return <String, String>{
      'name': this.name,
      'code': this.code,
      'academicYear': this.academicYear,
      'semester': this.semester,
      'profID': this.profID,
      'profName': this.profName,
      'currentCount': this.currentCount,
    };
  }

  factory Subject.fromMap(Map map) {
    return Subject(
      academicYear: map['academicYear'],
      code: map['code'],
      currentCount: map['currentCount'],
      name: map['name'],
      profID: map['profID'],
      semester: map['semester'],
      profName: map['profName'],
    );
  }

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getCode => code;

  set setCode(String code) => this.code = code;

  String get getCurrentCount => currentCount;

  set setCurrentCount(String currentCount) => this.currentCount = currentCount;

  String get getProfName => profName;

  set setProfName(String profName) => this.profName = profName;

  String get getProfID => profID;

  set setProfID(String profID) => this.profID = profID;
}
