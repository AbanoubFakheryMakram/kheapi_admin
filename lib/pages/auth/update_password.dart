import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';

import 'login_page.dart';

class UpdatePassword extends StatefulWidget {
  final String username;
  final String collection;

  const UpdatePassword({Key key, this.username, this.collection})
      : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  String newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: 'تحديث كلمة المرور',
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Image.asset(
            'assets/images/verify.png',
            fit: BoxFit.fitHeight,
            height: ScreenUtil().setHeight(190),
            width: ScreenUtil.screenWidth,
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Center(
            child: Text(
              'قم بادخال كلمة المرور الجديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 19,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Form(
            key: _formKey,
            child: _buildTextInputFeild(label: 'كلمة المرور'),
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
                "تحديث",
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

      await Firestore.instance
          .collection(widget.collection)
          .document(widget.username)
          .updateData(
        {
          'password': newPassword,
        },
      );
      AppUtils.showToast(
        msg: 'تم التحديث',
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ),
      );
    }
  }

  Widget _buildTextInputFeild({
    String label,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setHeight(14.0),
        right: ScreenUtil().setHeight(14.0),
        bottom: ScreenUtil().setHeight(14.0),
        top: ScreenUtil().setHeight(18.0),
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
          if (input.isEmpty) {
            return 'ادخل كلمة السر الجديدة';
          } else if (input.length < 8) {
            return 'كلمة المرور يجب ان تكون اكبر من 8 حروف او ارقام';
          } else {
            return null;
          }
        },
        onSaved: (input) {
          newPassword = input;
        },
        onChanged: (input) {
          newPassword = input;
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
