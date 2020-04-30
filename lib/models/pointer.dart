import 'package:admin/models/student.dart';
import 'admins.dart';
import 'doctor.dart';
import 'doctor_absence_model.dart';

class Pointer {
  static Doctor currentStudent = Doctor();
  static Doctor currentDoctor = Doctor();
  static Admin currentAdmin = Admin();
  static DoctorAbsenceModel currentAbsence = DoctorAbsenceModel();
}
