import 'package:admin/models/doctor.dart';
import 'package:admin/models/student.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/pages/auth/home/delete/delete_page.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class DeleteCourseFromStdOrDoc extends StatefulWidget {
  final String type;
  final Student student;
  final Doctor doctor;
  final String backTo;

  const DeleteCourseFromStdOrDoc({
    Key key,
    @required this.type,
    @required this.doctor,
    @required this.student,
    @required this.backTo,
  }) : super(key: key);

  @override
  _DeleteCourseFromStdOrDocState createState() =>
      _DeleteCourseFromStdOrDocState();
}

class _DeleteCourseFromStdOrDocState extends State<DeleteCourseFromStdOrDoc> {
  List<String> doctorCourses = List();
  List<Subject> studentCourses = List();

  bool fetched = false;

  getDoctorSubjects() async {
    var doctorDoc = await Firestore.instance
        .collection('Doctors')
        .document(widget.doctor.id)
        .get();
    doctorCourses = doctorDoc.data['subjects'] != null
        ? List.from(doctorDoc.data['subjects'])
        : [];

    print('doctors subject length: ${doctorCourses.length}');
    setState(() {
      fetched = true;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.doctor == null ? null : getDoctorSubjects();
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection &&
        widget.student != null &&
        !fetched) {
      getStudentCourses();
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => widget.backTo == 'Edit'
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => DeletePage(),
                    ),
                  ),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => widget.backTo == 'Edit'
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => DeletePage(),
                    ),
                  ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                if (widget.student != null) {
                  if (studentCourses.length == 0) {
                    AppUtils.showToast(msg: 'لا يوجد مواد ليتم حذفها');
                  } else {
                    deleteAll();
                  }
                } else if (widget.doctor != null && doctorCourses.length == 0) {
                  AppUtils.showToast(msg: 'لا يوجد مواد ليتم حذفها');
                } else {
                  AppUtils.showDialog(
                    context: context,
                    title: 'تحذير',
                    negativeText: 'لا',
                    onNegativeButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                    positiveText: 'نعم',
                    onPositiveButtonPressed: () {
                      deleteAll();
                    },
                    contentText: 'هل تريد مسح جميع المواد ؟',
                  );
                }
              },
            ),
          ],
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
        body: networkProvider.hasNetworkConnection == null
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
                      Text(
                        '${widget.type == 'Doctors' ? widget.doctor.name : widget.student.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Const.mainColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      widget.type == 'Doctors'
                          ? doctorCourses.isEmpty && fetched
                              ? Text('لا يوجد مواد')
                              : doctorCourses.isEmpty && !fetched
                                  ? Container(
                                      height: ScreenUtil().setHeight(60),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        addAutomaticKeepAlives: true,
                                        itemCount: doctorCourses.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () {
                                              deleteCourseFromDoctor(context,
                                                  '${doctorCourses[index]}');
                                            },
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
                                            title: Text(
                                              '${doctorCourses[index]}',
                                              textAlign: TextAlign.right,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                          : studentCourses.isEmpty && fetched
                              ? Text('لا يوجد مواد')
                              : studentCourses.isEmpty && !fetched
                                  ? Container(
                                      height: ScreenUtil().setHeight(60),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        addAutomaticKeepAlives: true,
                                        itemCount: studentCourses.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () {
                                              deleteCourseFromStudent(
                                                context,
                                                index,
                                              );
                                            },
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
                                            subtitle: Text(
                                              '${studentCourses[index].code}',
                                              textAlign: TextAlign.right,
                                            ),
                                            title: Text(
                                              '${studentCourses[index].name}',
                                              textAlign: TextAlign.right,
                                            ),
                                          );
                                        },
                                      ),
                                    )
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
      ),
    );
  }

  void deleteCourseFromDoctor(BuildContext context, String code) {
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
        AppUtils.showToast(msg: 'جاري المسح');

        await Firestore.instance
            .collection('Doctors')
            .document(widget.doctor.id)
            .updateData(
          {
            'subjects': FieldValue.arrayRemove(['$code']),
          },
        );

        await Firestore.instance
            .collection('Subjects')
            .document(code)
            .updateData(
          {
            'profID': '',
            'profName': '',
          },
        );

        Navigator.of(context).pop();
        AppUtils.showToast(msg: 'تم مسج الكورس');
        setState(() {});
      },
      contentText: 'هل تريد مسح الكورس؟',
    );
  }

  void deleteCourseFromStudent(BuildContext context, index) {
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

        await Firestore.instance
            .collection('Subjects')
            .document(studentCourses[index].code)
            .collection('Students')
            .document(widget.student.id)
            .delete();

        Navigator.of(context).pop();
        setState(() {});
        AppUtils.showToast(msg: 'تم مسج الكورس');
      },
      contentText: 'هل تريد مسح الكورس؟',
    );
  }

  void getStudentCourses() async {
    Firestore firestore = Firestore.instance;
    var allSubjects = await firestore.collection('Subjects').getDocuments();

    for (int i = 0; i < allSubjects.documents.length; i++) {
      var currentSubjectStudents = await firestore
          .collection('Subjects')
          .document(allSubjects.documents[i].documentID)
          .collection('Students')
          .getDocuments();

      for (int j = 0; j < currentSubjectStudents.documents.length; j++) {
        if (currentSubjectStudents.documents[j].documentID ==
            widget.student.id) {
          Subject subject = Subject.fromMap(allSubjects.documents[i].data);
          studentCourses.add(subject);
        }
      }
    }
    fetched = true;

    if (mounted) {
      setState(() {});
    }
  }

  void deleteAll() async {
    if (widget.student != null) {
      AppUtils.showDialog(
        context: context,
        title: 'تنبيه',
        negativeText: 'لا',
        onNegativeButtonPressed: () {
          Navigator.of(context).pop();
        },
        positiveText: 'نعم',
        onPositiveButtonPressed: () async {
          Navigator.of(context).pop();
          AppUtils.showToast(msg: 'جاري المسح');
          Firestore firestore = Firestore.instance;
          var allSubjects =
              await firestore.collection('Subjects').getDocuments();
          for (int i = 0; i < allSubjects.documents.length; i++) {
            await firestore
                .collection('Subjects')
                .document(allSubjects.documents[i].documentID)
                .collection('Students')
                .document(widget.student.id)
                .delete();
          }

          AppUtils.showToast(msg: 'تم المسح');
          Navigator.of(context).pop();
          if (mounted) {
            setState(() {});
          }
        },
        contentText: 'هل تريد مسح جميع المواد ؟',
      );
    } else {
      AppUtils.showDialog(
        context: context,
        title: 'تنبيه',
        negativeText: 'لا',
        onNegativeButtonPressed: () {
          Navigator.of(context).pop();
        },
        positiveText: 'نعم',
        onPositiveButtonPressed: () async {
          Navigator.of(context).pop();
          AppUtils.showToast(msg: 'جاري المسح');
          Firestore firestore = Firestore.instance;
          for (int i = 0; i < doctorCourses.length; i++) {
            await firestore
                .collection('Doctors')
                .document(widget.doctor.id)
                .updateData(
              {
                'subjects': FieldValue.arrayRemove([doctorCourses[i]]),
              },
            );
            await firestore
                .collection('Subjects')
                .document(doctorCourses[i])
                .updateData(
              {
                'profID': '',
                'profName': '',
              },
            );
          }

          AppUtils.showToast(msg: 'تم المسح');
          Navigator.of(context).pop();
          if (mounted) {
            setState(() {});
          }
        },
        contentText: 'هل تريد مسح جميع المواد ؟',
      );
    }
  }
}
