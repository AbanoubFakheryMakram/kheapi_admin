import 'package:admin/models/doctor.dart';
import 'package:admin/models/pointer.dart';
import 'package:admin/models/student.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/pages/auth/home/admin_home.dart';
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
  List<Subject> subjectsData;
  List<Doctor> doctorsData;
  List<Student> studentsData;
  final Firestore _firestore = Firestore.instance;
  String subject = '';

  @override
  void initState() {
    super.initState();

    selectedRadio = 0;
  }

  bool loading = true;

  setSelectedRadio(int val) {
    setState(
      () {
        selectedRadio = val;
      },
    );
  }

  void getSubjects() async {
    subjectsData = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('Subjects')
        .getDocuments(); // fetch all subjects

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

    loading = false;
    setState(() {});
  }

  void getDoctors() async {
    doctorsData = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('Doctors')
        .getDocuments(); // fetch all subjects

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
        subjects: currentSubject.data['subjects'] == null
            ? []
            : List.from(
                currentSubject.data['subjects'],
              ),
      );

      if (!doctorsData.contains(doctor)) {
        doctorsData.add(doctor);
      }
    }

    print('doctors: ${doctorsData.length}');
    setState(() {});
  }

  void getStudents() async {
    studentsData = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('Students')
        .getDocuments(); // fetch all subjects

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

    print('students: ${studentsData.length}');

    setState(() {});
  }

  bool subStop = false;
  bool stdStop = false;
  bool docStop = false;

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection) {
      if (subjectsData == null && !subStop) {
        subStop = true;
        getSubjects();
      }
      if (doctorsData == null && !docStop) {
        docStop = true;
        getDoctors();
      }
      if (studentsData == null && !stdStop) {
        stdStop = true;
        getStudents();
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: selectedRadio == 0
            ? <Widget>[
                Tooltip(
                  message: 'مسح جميع المواد',
                  child: IconButton(
                    icon: Icon(Icons.delete_sweep),
                    onPressed: () {
                      if (subjectsData.length == 0) {
                        AppUtils.showToast(msg: 'لا يوجد مواد ليتم مسحها');
                      } else {
                        AppUtils.showDialog(
                          context: context,
                          title: 'تنبيه',
                          negativeText: 'لا',
                          positiveText: 'نعم',
                          onNegativeButtonPressed: () {
                            Navigator.of(context).pop();
                          },
                          onPositiveButtonPressed: () {
                            Navigator.of(context).pop();
                            deleteAllCourses();
                          },
                          contentText: 'هل تريد مسح جميع المواد ؟',
                        );
                      }
                    },
                  ),
                ),
              ]
            : null,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) =>
                  AdminHomePage(username: Pointer.currentAdmin.username),
            ),
          ),
        ),
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
              subjectsData == null ||
              doctorsData == null ||
              studentsData == null
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
        child: subjectsData.isEmpty && !loading
            ? Center(
                child: Text('لا توجد مواد'),
              )
            : subjectsData.isEmpty && loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
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
        child: doctorsData.isEmpty
            ? Center(
                child: Text('لا يوجد دكاترة'),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DeleteCourseFromStdOrDoc(
                            backTo: 'Delete',
                            type: 'Doctors',
                            student: null,
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
        child: studentsData.isEmpty
            ? Center(
                child: Text('لا يوجد طلاب'),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DeleteCourseFromStdOrDoc(
                            type: 'Students',
                            backTo: 'Delete',
                            student: studentsData[index],
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

  void deleteAllCourses() async {
    AppUtils.showToast(msg: 'starting....');
    var firestore = Firestore.instance;
    for (int i = 0; i < subjectsData.length; i++) {
      var stdDocs = await firestore
          .collection('Subjects')
          .document(subjectsData[i].code)
          .collection('Students')
          .getDocuments();
      for (DocumentSnapshot ds in stdDocs.documents) {
        ds.reference.delete();
      }
      await firestore
          .collection('Subjects')
          .document(subjectsData[i].code)
          .delete();
    }
    for (int i = 0; i < doctorsData.length; i++) {
      await firestore
          .collection('Doctors')
          .document(doctorsData[i].id)
          .updateData(
        {
          'subjects': FieldValue.delete(),
        },
      );
      doctorsData[i].subjects.clear();
    }

    subjectsData.clear();
    setState(() {});
    AppUtils.showToast(msg: 'Done');
  }
}
