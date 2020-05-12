import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/student.dart';
import 'package:admin/pages/auth/home/delete/delete_course_from_doc_std.dart';
import 'package:admin/pages/auth/home/edit/edit_page.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/patterns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

import 'add_courses_to_std_doc.dart';

class EditStudent extends StatefulWidget {
  final Student currentStd;

  const EditStudent({Key key, this.currentStd}) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  String stdName;
  String stdCode;
  String stdPassword;
  String stdEmail;
  String stdPhone;
  String stdSSN;
  String level;

  String oldStdCode;

  ProgressDialog pr;

  TextEditingController stdNameController = TextEditingController();
  TextEditingController stdCodeController = TextEditingController();
  TextEditingController stdPasswordController = TextEditingController();
  TextEditingController stdEmailController = TextEditingController();
  TextEditingController stdPhoneController = TextEditingController();
  TextEditingController stdSSNController = TextEditingController();

  @override
  void initState() {
    super.initState();

    oldStdCode = widget.currentStd.id;
    stdCode = widget.currentStd.id;
    stdPassword = widget.currentStd.password;
    stdEmail = widget.currentStd.email;
    stdPhone = widget.currentStd.phone;
    stdSSN = widget.currentStd.ssn;
    level = widget.currentStd.level;
    stdName = widget.currentStd.name;
  }

  showLoadingHud(BuildContext context) async {
    pr.show();
  }

  hideLoadingHud(BuildContext context) {
    pr.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      isDismissible: false,
      showLogs: false,
    );
    pr.style(
      message: 'Deleting data...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      ),
      messageTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      ),
    );
    hideLoadingHud(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
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
                  deleteStd(context);
                },
                contentText: 'هل تريد مسح الطالب ؟',
              );
            },
          ),
        ],
        backgroundColor: Const.mainColor,
        title: Text(
          'تعديل بيانات طالب',
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
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MyFadeAnimation(
                                child: Text('اسم الطالب'),
                                delayinseconds: 1,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 1,
                                child: buildField(
                                  hint: '${widget.currentStd.name}',
                                  controller: stdNameController,
                                  onChange: (String input) {
                                    stdName = input;
                                  },
                                  validator: (String input) {
                                    if (stdName.isEmpty) {
                                      return 'مطلوب';
                                    } else if (stdName.length < 3) {
                                      return 'اسم الطالب لا يمكن ان يقل عن 3 حروف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('كود الطالب'),
                                delayinseconds: 1.5,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 1.5,
                                child: buildField(
                                  controller: stdCodeController,
                                  hint: '${widget.currentStd.id}',
                                  onChange: (String input) {
                                    stdCode = input;
                                  },
                                  validator: (String input) {
                                    if (stdCode.isEmpty) {
                                      return 'مطلوب';
                                    } else if (stdCode.length < 3) {
                                      return 'كود الطالب لا يمكن ان يقل عن 3 حروف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('كلمة المرور'),
                                delayinseconds: 2,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2,
                                child: buildField(
                                  controller: stdPasswordController,
                                  hint: widget.currentStd.password,
                                  onChange: (String input) {
                                    stdPassword = input;
                                  },
                                  validator: (String input) {
                                    if (stdPassword.isEmpty) {
                                      return 'مطلوب';
                                    } else if (stdPassword.length < 6) {
                                      return 'كلمة المرور لا يمكن ان تقل عن 6 حروف او ارقام';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('الايميل'),
                                delayinseconds: 2.5,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2.5,
                                child: buildField(
                                  controller: stdEmailController,
                                  hint: widget.currentStd.email,
                                  onChange: (String input) {
                                    stdEmail = input;
                                  },
                                  validator: (String input) {
                                    if (stdEmail.isNotEmpty) {
                                      if (!MyPatterns.isEmailValid(stdEmail)) {
                                        return 'الايميل غير صحيح';
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('التليفون'),
                                delayinseconds: 3,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 3,
                                child: buildField(
                                  controller: stdPhoneController,
                                  hint: widget.currentStd.phone,
                                  onChange: (String input) {
                                    stdPhone = input;
                                  },
                                  validator: (String input) {
                                    if (stdPhone.isNotEmpty) {
                                      print('0$stdPhone');
                                      if (!MyPatterns.isPhoneValid(
                                          '0$stdPhone')) {
                                        return 'الهاتف غير صحيح';
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('الرقم القومي'),
                                delayinseconds: 3.5,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 3.5,
                                child: buildField(
                                  controller: stdSSNController,
                                  hint: widget.currentStd.ssn,
                                  onChange: (String input) {
                                    stdSSN = input;
                                  },
                                  validator: (String input) {
                                    if (stdSSN.isEmpty) {
                                      return 'مطلوب';
                                    } else if (!MyPatterns
                                        .isIdentityNumberValid(stdSSN)) {
                                      return 'الرقم القومي غير صحيح';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('المستوي'),
                                delayinseconds: 4,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 4,
                                child: buildField(
                                  controller: stdSSNController,
                                  hint: widget.currentStd.level,
                                  onChange: (String input) {
                                    level = input;
                                  },
                                  validator: (String input) {
                                    if (level.isEmpty) {
                                      return 'مطلوب';
                                    } else if (int.parse(level) < 1 ||
                                        int.parse(level) > 4) {
                                      return 'المستوي غير صحيح';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 4.5,
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
                                    onPressed:
                                        (AnimationController controller) {
                                      validateAndSave(controller);
                                    },
                                  ),
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 5,
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
                                      'عرض مواد الطالب',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              DeleteCourseFromStdOrDoc(
                                            type: 'Student',
                                            doctor: null,
                                            student: widget.currentStd,
                                            backTo: 'Edit',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 5.5,
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
                                      'اضافة مواد للطالب',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddCoursesToStdDoc(
                                            student: widget.currentStd,
                                            doctor: null,
                                          ),
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
      setState(() {});
      Student student = Student(
        name: stdName,
        semester: null,
        academicYear: '${DateTime.now().year}-${DateTime.now().year + 1}',
        id: stdCode,
        level: level,
        ssn: stdSSN,
        phone: '$stdPhone',
        image: '',
        email: stdEmail,
        password: stdPassword,
      );

      await Firestore.instance
          .collection('Students')
          .document(oldStdCode)
          .delete();

      await Firestore.instance.collection('Students').document(stdCode).setData(
            student.toMap(),
          );

      AppUtils.showToast(msg: 'تم التعديل');
      controller.reverse();
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  void deleteStd(BuildContext context) async {
    showLoadingHud(context);
    Firestore firestore = Firestore.instance;

    // remove current student from all courses if exist
    var courses = await firestore.collection('Subjects').getDocuments();
    for (int i = 0; i < courses.documents.length; i++) {
      var currentCourse = courses.documents[i].data;
      await firestore
          .collection('Subjects')
          .document(currentCourse['code'])
          .collection('Students')
          .document(stdCode)
          .delete();
    }

    // finally remove current student data from database
    await firestore.collection('Students').document(stdCode).delete();
    hideLoadingHud(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => EditPage(),
      ),
    );
  }
}
