import 'package:admin/animations/splash_tap.dart';
import 'package:admin/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCards({
  String imageAsset,
  String text,
  Function onTap,
  BoxFit boxFit,
}) {
  return Splash(
    onTap: onTap,
    maxRadius: 180,
    splashColor: Const.mainColor,
    child: Container(
      height: ScreenUtil().setHeight(
        190,
      ),
      margin: EdgeInsets.all(
        ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(0, 3),
            blurRadius: 3,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Hero(
            tag: imageAsset,
            child: Image.asset(
              imageAsset,
              fit: boxFit ?? BoxFit.cover,
              height: ScreenUtil().setHeight(
                130,
              ),
              width: ScreenUtil.screenWidth,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(4),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Changa',
                fontWeight: FontWeight.bold,
                color: Const.mainColor,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
