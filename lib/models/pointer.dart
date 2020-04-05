import 'package:admin/models/student.dart';
import 'admins.dart';
import 'doctor.dart';
import 'doctor_absence_model.dart';

class Pointer {
  static Student currentStudent = Student();
  static Doctor currentDoctor = Doctor();
  static Admin currentAdmin = Admin();
  static DoctorAbsenceModel currentAbsence = DoctorAbsenceModel();
}
