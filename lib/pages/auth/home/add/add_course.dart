import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/pages/auth/home/add/show_all_courses.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  String courseName;
  String courseCode;

  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة كورس',
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
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/add.png'),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                          child: Column(
                            children: <Widget>[
                              MyFadeAnimation(
                                delayinseconds: 1,
                                child: buildField(
                                  hint: 'اسم المادة',
                                  controller: courseNameController,
                                  onChange: (String input) {
                                    courseName = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 3) {
                                      return 'اسم المادة لا يمكن ان يقل عن 3 حروف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 1.5,
                                child: buildField(
                                  controller: courseCodeController,
                                  hint: 'كود المادة',
                                  onChange: (String input) {
                                    courseCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 3) {
                                      return 'كود المادة لا يمكن ان يقل عن 3 حروف';
                                    } else if (input.contains(' ')) {
                                      return 'كود المادة لا يمكن ان يحتوي علي مسافات';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2,
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
                                      'اضافة',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      validateAndSave(controller);
                                    },
                                  ),
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2.5,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                    right: ScreenUtil().setWidth(20),
                                    bottom: ScreenUtil().setWidth(30),
                                  ),
                                  height: ScreenUtil().setHeight(48),
                                  child: ProgressButton(
                                    color: Const.mainColor,
                                    child: Text(
                                      'عرض كل المواد',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ShowAllCourses(),
                                        ),
                                      );
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

  Widget buildField(
      {String hint, onChange, validator, keyboardType, controller}) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        keyboardType: keyboardType,
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
        username: courseCode,
        collection: 'Subjects',
      );

      if (isCourseCodeExist) {
        AppUtils.showToast(msg: 'كود المادة موجود بالفعل');
        controller.reverse();
        return;
      }

      Subject newCourse = Subject(
        code: courseCode,
        name: courseName,
        currentCount: '0',
        profID: '',
        profName: '',
        academicYear: '${DateTime.now().year}-${DateTime.now().year + 1}',
      );

      await Firestore.instance
          .collection('Subjects')
          .document(courseCode)
          .setData(
            newCourse.subjectToMap(),
          );
      courseNameController.clear();
      courseCodeController.clear();

      AppUtils.showToast(msg: 'تمت الاضافة');
      controller.reverse();
    }
  }
}
