import 'dart:math';

import 'package:admin/animations/fade_animation.dart';
import 'package:admin/clips/login_clipper.dart';
import 'package:admin/models/admins.dart';
import 'package:admin/pages/auth/home/admin_home.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAdminAccount extends StatefulWidget {
  @override
  _CreateAdminAccountState createState() => _CreateAdminAccountState();
}

class _CreateAdminAccountState extends State<CreateAdminAccount> {
  bool hidePassword = true;
  String username, userPassword, rePassword, name, code;

  Rect rect;
  double width = double.infinity;

  var globalKey = RectGetter.createGlobalKey();
  final formKey = GlobalKey<FormState>();
  GlobalKey buttonKey = GlobalKey();

  // The ripple animation time (1 second)
  Duration animationDuration = Duration(milliseconds: 500);
  Duration delayTime = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text('انشاء حساب'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: ScreenUtil().setHeight(188),
                    color: Const.mainColor,
                    child: Center(
                      child: MyFadeAnimation(
                        delayinseconds: 1,
                        child: Text(
                          'انشاء حساب',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(18.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(16)),
                      child: Column(
                        children: <Widget>[
                          MyFadeAnimation(
                            delayinseconds: 1.5,
                            child: _buildInputField(
                              hintText: 'الاسم كاملا',
                              validator: (String input) {
                                if (input.isEmpty) {
                                  return 'مطلوب';
                                } else if (input.length <= 3) {
                                  return 'اسم غير صحيح';
                                } else {
                                  return null;
                                }
                              },
                              isPassword: false,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(18),
                          ),
                          MyFadeAnimation(
                            delayinseconds: 2,
                            child: _buildInputField(
                              hintText: 'اسم المستخدم',
                              validator: (String input) {
                                if (input.isEmpty) {
                                  return 'مطلوب';
                                } else if (username.length <= 7) {
                                  return 'اسم المستخدم لا يجب ان يقل عن 7 ارقام';
                                } else {
                                  return null;
                                }
                              },
                              isPassword: false,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(18),
                          ),
                          MyFadeAnimation(
                            delayinseconds: 2.5,
                            child: _buildInputField(
                              hintText: 'كلمة المرور',
                              validator: (String input) {
                                if (input.isEmpty) {
                                  return 'مطلوب';
                                } else if (userPassword.length < 6) {
                                  return 'كلمة المرور يجب الا تقل عن 6 حروف او ارقام';
                                } else {
                                  return null;
                                }
                              },
                              isPassword: true,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(18),
                          ),
                          MyFadeAnimation(
                            delayinseconds: 3,
                            child: _buildInputField(
                              validator: (String input) {
                                if (input.isEmpty) {
                                  return 'مطلوب';
                                } else {
                                  return null;
                                }
                              },
                              hintText: 'كود الانشاء',
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(18),
                          ),
                          MyFadeAnimation(
                            delayinseconds: 3.5,
                            child: Container(
                              key: buttonKey,
                              margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),
                                right: ScreenUtil().setWidth(20),
                                bottom: ScreenUtil().setWidth(30),
                                top: ScreenUtil().setHeight(30.0),
                              ),
                              height: ScreenUtil().setHeight(48),
                              width: width,
                              child: RectGetter(
                                key: globalKey,
                                child: ProgressButton(
                                  color: Const.mainColor,
                                  child: Text(
                                    'انشاء الحساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  onPressed: (AnimationController controller) {
                                    animatedButton(controller);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _ripple(),
        ],
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }

    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Const.mainColor,
        ),
      ),
    );
  }

  Widget _buildInputField(
      {@required hintText, bool isPassword = false, validator}) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setHeight(8.0),
        right: ScreenUtil().setHeight(8.0),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: isPassword ? hidePassword : false,
        enableSuggestions: true,
        enableInteractiveSelection: true,
        style: TextStyle(
          color: Colors.white,
        ),
        autocorrect: true,
        validator: validator,
        onSaved: (input) {
          hintText == 'اسم المستخدم'
              ? username = input
              : hintText == 'الاسم كاملا'
                  ? name = input
                  : hintText == 'كلمة المرور'
                      ? userPassword = input
                      : code = input;
        },
        onChanged: (input) {
          hintText == 'اسم المستخدم'
              ? username = input
              : hintText == 'الاسم كاملا'
                  ? name = input
                  : hintText == 'كلمة المرور'
                      ? userPassword = input
                      : code = input;
        },
        textAlign: TextAlign.right,
        keyboardType: hintText == 'اسم المستخدم' || hintText == 'كود الانشاء'
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Const.mainColor,
          prefixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        hidePassword = !hidePassword;
                      },
                    );
                  },
                )
              : null,
          filled: true,
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: Const.mainColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: Const.mainColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          hintText: hintText,
          contentPadding: EdgeInsets.all(
            ScreenUtil().setHeight(12),
          ),
          labelStyle: TextStyle(
            fontFamily: 'Changa',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void animatedButton(AnimationController controller) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      controller.forward();

      if (!await AppUtils.getConnectionState()) {
        AppUtils.showDialog(
          context: context,
          title: 'تنبيه',
          negativeText: 'حسنا',
          positiveText: '',
          onPositiveButtonPressed: null,
          contentText: 'لا يوجد اتصال بالانترنت',
        );

        controller.reverse();
        return;
      }

      bool isUsernameExist = await FirebaseUtils.doesObjectExist(
        username: username,
        collection: 'Admins',
      );

      if (isUsernameExist) {
        controller.reverse();
        AppUtils.showToast(msg: 'اسم المستخدم موجود بالفعل');
        return;
      }

      bool isCodeExist = await FirebaseUtils.doesObjectExist(
        username: code,
        collection: 'Codes',
      );

      if (!isCodeExist) {
        controller.reverse();
        AppUtils.showToast(msg: 'هذا الكود غير موجود !');
        return;
      }

      var codeData =
          await Firestore.instance.collection('Codes').document(code).get();
      if (codeData.data['adminCode'] != null) {
        controller.reverse();
        AppUtils.showToast(msg: 'هذا الكود تم استخدامه بالفعل');
        return;
      }

      Admin admin = Admin(
        name: name,
        code: code,
        password: userPassword,
        username: username,
      );

      // create new admin
      await Firestore.instance.collection('Admins').document(username).setData(
            admin.adminToMap(),
          );

      // register code for current admin
      await Firestore.instance.collection('Codes').document(code).updateData(
        {
          'adminCode': '$username',
        },
      );

      // create new code
      String newCode = '${getRandomCode()}';
      await Firestore.instance.collection('Codes').document(newCode).setData(
        {
          'code': newCode,
        },
      );

      controller.reverse();
      _onTap();
    }
  }

  int getRandomCode() {
    Random random = Random();
    return random.nextInt(100000) + 1000;
  }

  void _onTap() {
    setState(
      () => rect = RectGetter.getRectFromKey(globalKey),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(
          () => rect =
              rect.inflate(1.3 * MediaQuery.of(context).size.longestSide),
        );

        Future.delayed(animationDuration + delayTime, goToNextPage);
      },
    );
  }

  void goToNextPage() async {
    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setString(
          'username',
          username,
        );
      },
    );
    Navigator.of(context)
        .pushReplacement(
          PageTransition(
            child: AdminHomePage(
              username: username,
            ),
            type: PageTransitionType.fade,
          ),
        )
        .then(
          (_) => setState(
            () => rect = null,
          ),
        );
  }
}
