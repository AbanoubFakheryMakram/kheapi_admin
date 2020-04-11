import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/student.dart';
import 'package:admin/pages/auth/home/add/show_add_stds.dart';
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

class AddStd extends StatefulWidget {
  @override
  _AddStdState createState() => _AddStdState();
}

class _AddStdState extends State<AddStd> {
  final _formKey = GlobalKey<FormState>();
  String courseName;
  String courseCode;
  String doctorCode;
  String doctorName;
  Firestore _firestore = Firestore.instance;

  var subjects = [];
  var selected = [];

  bool showUnSelectedCoursesError = false;

  TextEditingController stdNameController = TextEditingController();
  TextEditingController stdCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController levelController = TextEditingController();
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
          'اضافة طالب',
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
                                  hint: 'اسم الطالب',
                                  controller: stdNameController,
                                  onChange: (String input) {
                                    courseName = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 3) {
                                      return 'اسم الطالب لا يمكن ان يقل عن 3 حروف';
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
                                  controller: stdCodeController,
                                  hint: 'كود الطالب (اسم المستخدم)',
                                  onChange: (String input) {
                                    courseCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (input.length < 6) {
                                      return 'كود الطالب لا يمكن ان يقل عن 6 ارقام';
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
                                  hint: 'المستوي',
                                  controller: levelController,
                                  onChange: (String input) {
                                    doctorCode = input;
                                  },
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      return 'مطلوب';
                                    } else if (num.parse(input) > 4) {
                                      return 'لا يوجد مستوي اكبر من المستوي الرابع';
                                    } else if (num.parse(input) < 1) {
                                      return 'لا يوجد مستوي اقل من المستوي الاول';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 3,
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
                                delayinseconds: 3.5,
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
                                delayinseconds: 4,
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
                                      return 'رقم غير صحيح';
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
                                delayinseconds: 4.5,
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
                                      'عرض كل الطلاب',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ShowAllStudents(),
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
        username: stdCodeController.text,
        collection: 'Students',
      );

      if (isStdExist) {
        AppUtils.showToast(msg: 'هذا الطالب موجود بالفعل');
        controller.reverse();
        return;
      }

      // save std data
      Student newStd = Student(
        name: stdNameController.text,
        id: stdCodeController.text,
        password: passwordController.text,
        email: emailController.text,
        image: '',
        level: levelController.text,
        phone: phoneController.text,
        semester: '',
        ssn: identityNumberController.text,
        academicYear: '${DateTime.now().year}-${DateTime.now().year + 1}',
      );

      // upload std data
      await Firestore.instance
          .collection('Students')
          .document(courseCode)
          .setData(
            newStd.toMap(),
          );

      // register std in the courses
      for (int i = 0; i < selected.length; i++) {
        await Firestore.instance
            .collection('Subjects')
            .document(selected[i])
            .collection('Students')
            .document(stdCodeController.text)
            .setData(
          {
            'Last attendance': '',
            'attendenc': <String>[],
            'id': stdCodeController.text,
            'numberOfTimes': '0',
            'std_name': stdNameController.text,
          },
        );
      }

      // clear fields
      stdCodeController.clear();
      stdNameController.clear();
      passwordController.clear();
      passwordController.clear();
      identityNumberController.clear();
      levelController.clear();
      levelController.clear();
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
