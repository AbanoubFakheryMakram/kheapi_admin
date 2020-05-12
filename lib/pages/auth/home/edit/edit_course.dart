import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/pages/auth/home/edit/edit_page.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

class EditCourse extends StatefulWidget {
  final Subject currentSubject;

  const EditCourse({Key key, this.currentSubject}) : super(key: key);

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final _formKey = GlobalKey<FormState>();
  String courseName;
  String courseCode;
  String doctorCode;
  String doctorName;

  String oldCourseCode;
  String oldDoctorCode;

  int stdsCount;

  bool deleteing = false;

  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    courseName = widget.currentSubject.name;
    courseCode = widget.currentSubject.code;
    doctorName = widget.currentSubject.profName;
    doctorCode = widget.currentSubject.profID;

    oldCourseCode = courseCode;
    oldDoctorCode = doctorCode;

    getCourseStdsCount();
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Tooltip(
            message: 'مسح المادة',
            child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                deleteCourse(context);
              },
            ),
          ),
        ],
        backgroundColor: Const.mainColor,
        title: Text(
          'تعديل كورس',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: networkProvider.hasNetworkConnection == null || stdsCount == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : networkProvider.hasNetworkConnection
              ? Stack(
                  children: <Widget>[
                    deleteing
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(16)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        MyFadeAnimation(
                                          child: Text('اسم المادة'),
                                          delayinseconds: 1,
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 1,
                                          child: buildField(
                                            hint:
                                                '${widget.currentSubject.name}',
                                            controller: courseNameController,
                                            onChange: (String input) {
                                              courseName = input;
                                            },
                                            validator: (String input) {
                                              if (courseName.isEmpty) {
                                                return 'مطلوب';
                                              } else if (courseName.length <
                                                  3) {
                                                return 'اسم المادة لا يمكن ان يقل عن 3 حروف';
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          child: Text('كود المادة'),
                                          delayinseconds: 1.5,
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 1.5,
                                          child: buildField(
                                            controller: courseCodeController,
                                            hint:
                                                '${widget.currentSubject.code}',
                                            onChange: (String input) {
                                              courseCode = input;
                                            },
                                            validator: (String input) {
                                              if (courseCode.isEmpty) {
                                                return 'مطلوب';
                                              } else if (courseCode.length <
                                                  3) {
                                                return 'كود المادة لا يمكن ان يقل عن 3 حروف';
                                              } else if (courseCode
                                                  .contains(' ')) {
                                                return 'كود المادة لا يمكن ان يحتوي علي مسافات';
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          child: Text('اسم الدكتور'),
                                          delayinseconds: 2,
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 2,
                                          child: buildField(
                                            controller: doctorNameController,
                                            hint: widget.currentSubject
                                                            .profName ==
                                                        null ||
                                                    widget.currentSubject
                                                        .profName.isEmpty
                                                ? 'ادخل اسم الدكتور'
                                                : '${widget.currentSubject.profName}',
                                            onChange: (String input) {
                                              doctorName = input;
                                            },
                                            validator: (String input) {
                                              if (doctorName.isEmpty) {
                                                return 'مطلوب';
                                              } else if (doctorName.length <
                                                  3) {
                                                return 'اسم الدكتور لا يمكن ان يقل عن 3 حروف';
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          child: Text('كود الدكتور'),
                                          delayinseconds: 2.5,
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 2.5,
                                          child: buildField(
                                            controller: doctorCodeController,
                                            hint: widget.currentSubject
                                                            .profName ==
                                                        null ||
                                                    widget.currentSubject.profID
                                                        .isEmpty
                                                ? 'ادخل كود الدكتور'
                                                : '${widget.currentSubject.profName}',
                                            onChange: (String input) {
                                              doctorCode = input;
                                            },
                                            validator: (String input) {
                                              if (doctorCode.isEmpty) {
                                                return 'مطلوب';
                                              } else if (doctorCode.length <
                                                  6) {
                                                return 'كود الدكتور لا يمكن ان يقل عن 6 حروف او ارقام';
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          child: Text('عدد المحاضرات حتي الان'),
                                          delayinseconds: 3,
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 3,
                                          child: buildField(
                                            editable: false,
                                            hint:
                                                '${widget.currentSubject.currentCount}',
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 3,
                                          child: buildField(
                                            editable: false,
                                            hint: stdsCount == 0
                                                ? 'لا يوجد طلاب تم تسجيلهم لهذا المقرر'
                                                : 'عدد الطلاب المسجلين لهذا المقرر هو $stdsCount',
                                          ),
                                        ),
                                        MyFadeAnimation(
                                          delayinseconds: 4,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(20),
                                              right: ScreenUtil().setWidth(20),
                                              bottom: ScreenUtil().setWidth(30),
                                              top: ScreenUtil().setHeight(30.0),
                                            ),
                                            height: ScreenUtil().setHeight(48),
                                            child: ProgressButton(
                                              color: Const.mainColor,
                                              child: Text(
                                                'تعديل',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal',
                                                ),
                                              ),
                                              onPressed: (AnimationController
                                                  controller) {
                                                validateAndSave(controller);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget buildField({
    String hint,
    onChange,
    validator,
    keyboardType,
    controller,
    editable,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(5),
        bottom: ScreenUtil().setHeight(5),
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        enabled: editable ?? true,
        validator: validator,
        onChanged: onChange,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Const.mainColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Const.mainColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Const.mainColor,
          ),
        ),
      ),
    );
  }

  void validateAndSave(AnimationController controller) async {
    if (_formKey.currentState.validate()) {
      controller.forward();

      bool isCourseCodeExist = await FirebaseUtils.doesObjectExist(
        username: doctorCode,
        collection: 'Subjects',
      );

      if (isCourseCodeExist) {
        AppUtils.showToast(msg: 'كود المادة موجود بالفعل');
        controller.reverse();
        return;
      }

      bool isDoctorCodeExist = await FirebaseUtils.doesObjectExist(
        username: doctorCode,
        collection: 'Doctors',
      );

      if (!isDoctorCodeExist) {
        AppUtils.showToast(msg: 'كود الدكتور غير موجود');
        controller.reverse();
        return;
      }

      Subject editedCourse = Subject(
        code: courseCode,
        name: courseName,
        currentCount: '${widget.currentSubject.currentCount}',
        profID: '$doctorCode',
        profName: '$doctorName',
        academicYear: '${DateTime.now().year}-${DateTime.now().year + 1}',
      );

      await Firestore.instance
          .collection('Subjects')
          .document(oldCourseCode)
          .delete();

      await Firestore.instance
          .collection('Subjects')
          .document(courseCode)
          .setData(
            editedCourse.subjectToMap(),
          );

      if (oldCourseCode == courseCode) {
        await Firestore.instance
            .collection('Doctors')
            .document(widget.currentSubject.profID)
            .updateData(
          {
            'subjects': FieldValue.arrayUnion(
              ['$courseCode'],
            ),
          },
        );
      } else {
        var doctorSubjectsData = await Firestore.instance
            .collection('Doctors')
            .document(oldDoctorCode)
            .get();

        if (doctorSubjectsData.data['subjects'] != null) {
          if (doctorSubjectsData.data['subjects'].contains(oldCourseCode)) {
            await Firestore.instance
                .collection('Doctors')
                .document(widget.currentSubject.profID)
                .updateData(
              {
                'subjects': FieldValue.arrayRemove(
                  ['$oldCourseCode'],
                ),
              },
            );
            await Firestore.instance
                .collection('Doctors')
                .document(widget.currentSubject.profID)
                .updateData(
              {
                'subjects': FieldValue.arrayUnion(
                  ['$courseCode'],
                ),
              },
            );
          } else {
            await Firestore.instance
                .collection('Doctors')
                .document(widget.currentSubject.profID)
                .updateData(
              {
                'subjects': FieldValue.arrayUnion(
                  ['$courseCode'],
                ),
              },
            );
          }
        } else {
          await Firestore.instance
              .collection('Doctors')
              .document(widget.currentSubject.profID)
              .updateData(
            {
              'subjects': FieldValue.arrayUnion(
                ['$courseCode'],
              ),
            },
          );
        }
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EditPage(),
        ),
      );

      AppUtils.showToast(msg: 'تم التعديل');
      controller.reverse();
    }
  }

  void getCourseStdsCount() async {
    var stdCourseDocs = await Firestore.instance
        .collection('Subjects')
        .document(widget.currentSubject.code)
        .collection('Students')
        .getDocuments();
    stdsCount = stdCourseDocs.documents.length;
    setState(() {});
  }

  void deleteCourse(context) {
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

        deleteing = true;
        setState(() {});

        var firestore = Firestore.instance;

        // remove all std in this course
        var stdDocs = await firestore
            .collection('Subjects')
            .document(oldCourseCode)
            .collection('Students')
            .getDocuments();

        for (DocumentSnapshot ds in stdDocs.documents) {
          ds.reference.delete();
        }

        // remove course
        await firestore.collection('Subjects').document(oldCourseCode).delete();

        deleteing = false;
        setState(() {});
        AppUtils.showToast(msg: 'تم مسج الكورس');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EditPage(),
          ),
        );
      },
      contentText: 'هل تريد مسح الكورس؟',
    );
  }
}
