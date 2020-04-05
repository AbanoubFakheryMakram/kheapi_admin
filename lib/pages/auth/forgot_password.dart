import 'package:admin/pages/auth/update_password.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:admin/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String username;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'نسيت كلمة المرور'),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16.0),
              vertical: ScreenUtil().setHeight(18),
            ),
            child: Image.asset(
              'assets/images/forgot_password.jpg',
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(220),
              width: ScreenUtil.screenWidth,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Center(
            child: Text(
              'قم بادخال اسم المستحدم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 19,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: _buildTextInputFeild(
              label: 'اسم المستحدم',
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(48),
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setWidth(30),
              top: ScreenUtil().setHeight(18.0),
            ),
            child: ProgressButton(
              color: Const.mainColor,
              progressIndicatorColor: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              child: Text(
                "بحث",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Tajawal',
                ),
              ),
              onPressed: (AnimationController controller) async {
                processData(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  void processData(AnimationController controller) async {
    if (_formKey.currentState.validate()) {
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

      bool isExist;
      String collection = 'Admins';
      isExist = await FirebaseUtils.doesObjectExist(
        username: username,
        collection: collection,
      );

      if (isExist) {
        controller.reverse();
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.scale,
            child: UpdatePassword(
              username: username,
              collection: collection,
            ),
          ),
        );
      } else {
        controller.reverse();
        AppUtils.showToast(
          msg: 'اسم المستخدم غير موجود',
          timeInSeconds: 2,
        );
      }
    }
  }

  Widget _buildTextInputFeild({
    String label,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(18.0),
        right: ScreenUtil().setWidth(18.0),
        bottom: ScreenUtil().setHeight(14.0),
        top: ScreenUtil().setHeight(22.0),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        enableSuggestions: true,
        enableInteractiveSelection: true,
        style: TextStyle(
          color: Colors.white,
        ),
        autocorrect: true,
        validator: (input) {
          if (input.isEmpty)
            return 'ادخل اسم المستخدم';
          else {
            return null;
          }
        },
        onSaved: (input) {
          username = input;
        },
        onChanged: (input) {
          username = input;
        },
        textAlign: TextAlign.right,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Const.mainColor,
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
          hintText: label,
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
}
