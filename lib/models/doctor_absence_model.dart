class DoctorAbsenceModel {
  String std_name;
  String std_id;
  String lastAttendance;
  String numberOfTimes;
  String currentCount;
  List attendenc;

  DoctorAbsenceModel({
    this.std_name,
    this.std_id,
    this.lastAttendance,
    this.numberOfTimes,
    this.currentCount,
    this.attendenc,
  });

  factory DoctorAbsenceModel.fromDoc(Map doc) {
    return DoctorAbsenceModel(
      std_name: doc['std_name'],
      std_id: doc['id'],
      lastAttendance: doc['Last attendance'],
      numberOfTimes: doc['numberOfTimes'],
      currentCount: doc['currentCount'],
      attendenc: List.from(doc['attendenc']),
    );
  }

  Map toMap() {
    return {
      'std_name': std_name,
      'id': std_id,
      'Last attendance': lastAttendance,
      'numberOfTimes': numberOfTimes,
      'currentCount': currentCount,
      'attendenc': attendenc,
    };
  }
}
