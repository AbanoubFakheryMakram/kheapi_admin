import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/doctor.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:admin/utils/patterns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final _formKey = GlobalKey<FormState>();
  String courseName;
  String courseCode;
  String doctorCode;
  String doctorName;
  Firestore _firestore = Firestore.instance;

  var subjects = [];
  List selected = [];

  bool showUnSelectedCoursesError = false;

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection &&
        subjects.isEmpty) {
      getSubjects();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة دكتور',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: networkProvider.hasNetworkConnection == null || subjects.isEmpty
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
                                  hint: 'اسم الدكتور',
                                  controller: doctorNameController,
                                  onChange: (String input) {
                                    courseName = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 3) {
                                      return 'اسم الدكتور لا يمكن ان يقل عن 3 حروف';
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
                                  controller: doctorCodeController,
                                  hint: 'كود الدكتور (اسم المستخدم)',
                                  onChange: (String input) {
                                    courseCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 6) {
                                      return 'كود الدكتور لا يمكن ان يقل عن 6 ارقام';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2,
                                child: buildField(
                                  hint: 'كلمة المرور',
                                  controller: passwordController,
                                  onChange: (String input) {
                                    doctorName = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 6) {
                                      return 'كلمة المرور لا يمكن ان يقل عن 6 حروف';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 2.5,
                                child: buildField(
                                  hint: 'الايميل (اختياري)',
                                  controller: emailController,
                                  validator: (String input) {
                                    if (input.isNotEmpty) {
                                      if (!MyPatterns.isEmailValid(input)) {
                                        return 'ايميل غير صحيح';
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChange: (String input) {
                                    doctorCode = input;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 3,
                                child: buildField(
                                  hint: 'رقم التليفون (اختياري)',
                                  controller: phoneController,
                                  onChange: (String input) {
                                    doctorCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isNotEmpty) {
                                      if (!MyPatterns.isPhoneValid(input)) {
                                        return 'رقم التليفون غير صحيح';
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
                                delayinseconds: 3.5,
                                child: buildField(
                                  hint: 'رقم البطاقة',
                                  controller: identityNumberController,
                                  onChange: (String input) {
                                    doctorCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (!MyPatterns
                                        .isIdentityNumberValid(input)) {
                                      return 'رقم البطاقة غير صحيح';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 4,
                                child: MultiSelectFormField(
                                  titleText: 'المقررات',
                                  autovalidate: showUnSelectedCoursesError,
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'من فضلك قم بتحديد المقررات';
                                    } else {
                                      return null;
                                    }
                                  },
                                  dataSource: subjects,
                                  textField: 'display',
                                  valueField: 'value',
                                  okButtonLabel: 'تم',
                                  cancelButtonLabel: 'الغاء',
                                  // required: true,
                                  hintText: 'من فضلك قم بتحديد المقررات',
                                  value: selected,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    selected = value;
                                    showUnSelectedCoursesError = false;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 4.5,
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
      if (selected.isEmpty) {
        AppUtils.showToast(msg: 'قم بتحديد المقررات اولا');
        controller.reverse();
        showUnSelectedCoursesError = true;
        setState(() {});
        return;
      }

      controller.forward();
      showUnSelectedCoursesError = false;
      setState(() {});

      // check if this std exist or not
      bool isStdExist = await FirebaseUtils.doesObjectExist(
        username: doctorCodeController.text,
        collection: 'Doctors',
      );

      if (isStdExist) {
        AppUtils.showToast(msg: 'هذا الدكتور موجود بالفعل');
        controller.reverse();
        return;
      }

      List<String> sub = List<String>();
      for (String item in selected) {
        sub.add(item);
      }
      // save doctor data
      Doctor newStd = Doctor(
        name: doctorNameController.text,
        id: doctorCodeController.text,
        password: passwordController.text,
        email: emailController.text,
        image: '',
        phone: phoneController.text,
        ssn: identityNumberController.text,
        subjects: sub,
      );

      // upload doctor data
      await Firestore.instance
          .collection('Doctors')
          .document(courseCode)
          .setData(
            newStd.toMap(),
          );

      // clear fields
      doctorCodeController.clear();
      doctorNameController.clear();
      passwordController.clear();
      passwordController.clear();
      identityNumberController.clear();
      selected.clear();

      AppUtils.showToast(msg: 'تمت الاضافة');
      controller.reverse();
    }
  }

  void getSubjects() async {
    subjects.clear();
    QuerySnapshot querySnapshot = await _firestore
        .collection('Subjects')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      // move inside each subject
      DocumentSnapshot currentSubject = querySnapshot.documents[i];
      subjects.add({
        'value': currentSubject.data['code'],
        'display': currentSubject.data['name'],
      });
    }

    setState(() {});
  }
}
