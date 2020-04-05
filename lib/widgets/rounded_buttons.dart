import 'package:admin/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButtons extends StatefulWidget {
  final Widget child;
  final Function function;

  const RoundedButtons({Key key, this.function, this.child}) : super(key: key);

  @override
  _RoundedButtonsState createState() => _RoundedButtonsState();
}

class _RoundedButtonsState extends State<RoundedButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        height: ScreenUtil().setHeight(40),
        width: ScreenUtil.screenWidth,
        margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(10),
          right: ScreenUtil().setHeight(30),
          left: ScreenUtil().setHeight(30),
        ),
        decoration: BoxDecoration(
          color: Const.mainColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
