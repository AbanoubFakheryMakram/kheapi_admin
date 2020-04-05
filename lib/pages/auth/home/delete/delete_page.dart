import 'package:admin/models/doctor.dart';
import 'package:admin/models/student.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/pages/auth/home/delete/delete_course_from_doc_std.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  // 0 >> Course    ||    1 >> Student    ||    2 >> Doctor
  int selectedRadio;
  List<Subject> subjectsData = [];
  List<Doctor> doctorsData = [];
  List<Student> studentsData = [];
  final Firestore _firestore = Firestore.instance;
  String subject = '';

  @override
  void initState() {
    super.initState();

    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(
      () {
        selectedRadio = val;
      },
    );
  }

  void getSubjects() async {
    subjectsData.clear();
    QuerySnapshot querySnapshot = await _firestore
        .collection('Subjects')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      DocumentSnapshot currentSubject = querySnapshot.documents[i];

      Subject subject = Subject(
        name: currentSubject.data['name'],
        code: currentSubject.data['code'],
        currentCount: currentSubject.data['currentCount'],
        profID: currentSubject.data['profID'],
        profName: currentSubject.data['profName'],
      );

      if (!subjectsData.contains(subject)) {
        subjectsData.add(subject);
      }
    }

    setState(() {});
  }

  void getDoctors() async {
    doctorsData.clear();
    QuerySnapshot querySnapshot = await _firestore
        .collection('Doctors')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      DocumentSnapshot currentSubject = querySnapshot.documents[i];

      Doctor doctor = Doctor(
        name: currentSubject.data['name'],
        ssn: currentSubject.data['ssn'],
        email: currentSubject.data['email'],
        id: currentSubject.data['id'],
        image: currentSubject.data['image'],
        password: currentSubject.data['password'],
        phone: currentSubject.data['phone'],
        subjects: List.from(
          currentSubject.data['subjects'],
        ),
      );

      if (!doctorsData.contains(doctor)) {
        doctorsData.add(doctor);
      }
    }

    setState(() {});
  }

  void getStudents() async {
    doctorsData.clear();
    QuerySnapshot querySnapshot = await _firestore
        .collection('Students')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      DocumentSnapshot currentStudent = querySnapshot.documents[i];

      Student student = Student(
        name: currentStudent.data['name'],
        ssn: currentStudent.data['ssn'],
        email: currentStudent.data['email'],
        id: currentStudent.data['id'],
        image: currentStudent.data['image'],
        password: currentStudent.data['password'],
        phone: currentStudent.data['phone'],
        level: currentStudent.data['level'],
        semester: currentStudent.data['semester'],
        academicYear: currentStudent.data['academicYear'],
      );

      if (!studentsData.contains(student)) {
        studentsData.add(student);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection) {
      if (subjectsData.isEmpty) {
        getSubjects();
      }
      if (doctorsData.isEmpty) {
        getDoctors();
      }
      if (studentsData.isEmpty) {
        getStudents();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'حذف',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: networkProvider.hasNetworkConnection == null ||
              subjectsData.isEmpty ||
              doctorsData.isEmpty ||
              studentsData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : networkProvider.hasNetworkConnection
              ? Column(
                  children: <Widget>[
                    Hero(
                      tag: 'assets/images/delete.png',
                      child: Image.asset('assets/images/delete.png'),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            title: Text('كورس'),
                            value: 0,
                            groupValue: selectedRadio,
                            onChanged: (int val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 1,
                            title: Text('طالب'),
                            groupValue: selectedRadio,
                            onChanged: (int val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text('دكتور'),
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: (int val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    selectedRadio == 0
                        ? coursesListView(context)
                        : selectedRadio == 1
                            ? studentsListView()
                            : selectedRadio == 2
                                ? doctorsListView()
                                : SizedBox.shrink()
                  ],
                )
              : Container(
                  color: Color(0xffF2F2F2),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/no_internet_connection.jpg',
                      ),
                      Text(
                        'لا يوجد اتصال بالانترنت',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void deleteCourse(int index, context) {
    AppUtils.showDialog(
      context: context,
      title: 'تحذير',
      negativeText: 'الغاء',
      positiveText: 'تاكيد',
      onNegativeButtonPressed: () {
        Navigator.of(context).pop();
      },
      onPositiveButtonPressed: () async {
        Navigator.of(context).pop();
        Subject clickedSubject = subjectsData[index];
        subjectsData.removeAt(index);
        await _firestore
            .collection('Subjects')
            .document(clickedSubject.code)
            .delete();

        setState(() {});
        AppUtils.showToast(msg: 'تم مسج الكورس');
      },
      contentText: 'هل تريد مسح الكورس؟',
    );
  }

  Widget coursesListView(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                deleteCourse(index, context);
              },
              subtitle: Text(
                '${subjectsData[index].code}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              title: Text(
                '${subjectsData[index].name}',
                textAlign: TextAlign.right,
              ),
              leading: Text(
                'X',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Icon(
                Icons.description,
                color: Const.mainColor,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Const.mainColor,
              height: ScreenUtil().setHeight(2),
              indent: ScreenUtil().setWidth(18),
              endIndent: ScreenUtil().setWidth(18),
              thickness: 2,
            );
          },
          itemCount: subjectsData.length,
        ),
      ),
    );
  }

  Widget doctorsListView() {
    return Expanded(
      child: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DeleteCourseFromStdOrDoc(
                      type: 'Doctors',
                      id: doctorsData[index].id,
                      doctor: doctorsData[index],
                    ),
                  ),
                );
              },
              title: Text(
                '${doctorsData[index].name}',
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                '${doctorsData[index].id}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              leading: Icon(
                Icons.arrow_left,
                color: Const.mainColor,
                size: 30,
              ),
              trailing: Icon(
                Icons.settings_input_svideo,
                color: Const.mainColor,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Const.mainColor,
              height: ScreenUtil().setHeight(2),
              indent: ScreenUtil().setWidth(18),
              endIndent: ScreenUtil().setWidth(18),
              thickness: 2,
            );
          },
          itemCount: doctorsData.length,
        ),
      ),
    );
  }

  Widget studentsListView() {
    return Expanded(
      child: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DeleteCourseFromStdOrDoc(
                      type: 'Students',
                      id: studentsData[index].id,
                      doctor: null,
                    ),
                  ),
                );
              },
              title: Text(
                '${studentsData[index].name}',
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                '${studentsData[index].id}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              leading: Icon(
                Icons.arrow_left,
                color: Const.mainColor,
                size: 30,
              ),
              trailing: Icon(
                Icons.person_pin,
                color: Const.mainColor,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Const.mainColor,
              height: ScreenUtil().setHeight(2),
              indent: ScreenUtil().setWidth(18),
              endIndent: ScreenUtil().setWidth(18),
              thickness: 2,
            );
          },
          itemCount: studentsData.length,
        ),
      ),
    );
  }
}
