import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/doctor.dart';
import 'package:admin/pages/auth/home/delete/delete_course_from_doc_std.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/patterns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

import 'add_courses_to_std_doc.dart';

class EditDoctor extends StatefulWidget {
  final Doctor currentDoctor;

  const EditDoctor({Key key, this.currentDoctor}) : super(key: key);

  @override
  _EditDoctorState createState() => _EditDoctorState();
}

class _EditDoctorState extends State<EditDoctor> {
  final _formKey = GlobalKey<FormState>();
  String doctorName;
  String doctorCode;
  String doctorPassword;
  String doctorEmail;
  String doctorPhone;
  String doctorSSN;

  String olddoctorCode;

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorCodeController = TextEditingController();
  TextEditingController doctorPasswordController = TextEditingController();
  TextEditingController doctorEmailController = TextEditingController();
  TextEditingController doctorPhoneController = TextEditingController();
  TextEditingController doctorSSNController = TextEditingController();

  @override
  void initState() {
    super.initState();

    olddoctorCode = widget.currentDoctor.id;
    doctorCode = widget.currentDoctor.id;
    doctorPassword = widget.currentDoctor.password;
    doctorEmail = widget.currentDoctor.email;
    doctorPhone = widget.currentDoctor.phone;
    doctorSSN = widget.currentDoctor.ssn;
    doctorName = widget.currentDoctor.name;
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'تعديل بيانات دكتور',
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
                                child: Text('اسم الدكتور'),
                                delayinseconds: 1,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 1,
                                child: buildField(
                                  hint: '${widget.currentDoctor.name}',
                                  controller: doctorNameController,
                                  onChange: (String input) {
                                    doctorName = input;
                                  },
                                  validator: (String input) {
                                    if (doctorName.isEmpty) {
                                      return 'مطلوب';
                                    } else if (doctorName.length < 3) {
                                      return 'اسم الطالب لا يمكن ان يقل عن 3 حروف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                child: Text('كود الدكتور'),
                                delayinseconds: 1.5,
                              ),
                              MyFadeAnimation(
                                delayinseconds: 1.5,
                                child: buildField(
                                  controller: doctorCodeController,
                                  hint: '${widget.currentDoctor.id}',
                                  onChange: (String input) {
                                    doctorCode = input;
                                  },
                                  validator: (String input) {
                                    if (doctorCode.isEmpty) {
                                      return 'مطلوب';
                                    } else if (doctorCode.length < 3) {
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
                                  controller: doctorPasswordController,
                                  hint: widget.currentDoctor.password,
                                  onChange: (String input) {
                                    doctorPassword = input;
                                  },
                                  validator: (String input) {
                                    if (doctorPassword.isEmpty) {
                                      return 'مطلوب';
                                    } else if (doctorPassword.length < 6) {
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
                                  controller: doctorEmailController,
                                  hint: widget.currentDoctor.email,
                                  onChange: (String input) {
                                    doctorEmail = input;
                                  },
                                  validator: (String input) {
                                    if (doctorEmail.isNotEmpty) {
                                      if (!MyPatterns.isEmailValid(
                                          doctorEmail)) {
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
                                  controller: doctorPhoneController,
                                  hint: widget.currentDoctor.phone,
                                  onChange: (String input) {
                                    doctorPhone = input;
                                  },
                                  validator: (String input) {
                                    if (doctorPhone.isNotEmpty) {
                                      print('0$doctorPhone');
                                      if (!MyPatterns.isPhoneValid(
                                          '0$doctorPhone')) {
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
                                  controller: doctorSSNController,
                                  hint: widget.currentDoctor.ssn,
                                  onChange: (String input) {
                                    doctorSSN = input;
                                  },
                                  validator: (String input) {
                                    if (doctorSSN.isEmpty) {
                                      return 'مطلوب';
                                    } else if (!MyPatterns
                                        .isIdentityNumberValid(doctorSSN)) {
                                      return 'الرقم القومي غير صحيح';
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
                                      'عرض مواد الدكتور',
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
                                            type: 'Doctors',
                                            student: null,
                                            doctor: widget.currentDoctor,
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
                                      'اضافة مواد للدكتور',
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
                                            student: null,
                                            doctor: widget.currentDoctor,
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
      Doctor student = Doctor(
        name: doctorName,
        id: doctorCode,
        ssn: doctorSSN,
        phone: '$doctorPhone',
        image: '',
        email: doctorEmail,
        password: doctorPassword,
      );

      await Firestore.instance
          .collection('Students')
          .document(olddoctorCode)
          .delete();

      await Firestore.instance
          .collection('Students')
          .document(doctorCode)
          .setData(
            student.toMap(),
          );

      AppUtils.showToast(msg: 'تم التعديل');
      controller.reverse();
      setState(() {});
      Navigator.of(context).pop();
    }
  }
}
