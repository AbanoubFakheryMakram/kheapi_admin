import 'package:admin/pages/auth/home/add/add_course.dart';
import 'package:admin/pages/auth/home/add/add_doctor.dart';
import 'package:admin/pages/auth/home/add/add_files.dart';
import 'package:admin/pages/auth/home/add/add_std.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة',
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
                      Hero(
                        tag: 'assets/images/add.png',
                        child: Image.asset('assets/images/add.png'),
                      ),
                      buildOption(
                        title: 'اضافة كورس',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: AddCourse(),
                              type: PageTransitionType.upToDown,
                            ),
                          );
                        },
                      ),
                      buildOption(
                        title: 'اضافة طالب',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: AddStd(),
                              type: PageTransitionType.upToDown,
                            ),
                          );
                        },
                      ),
                      buildOption(
                        title: 'اضافة دكتور',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: AddDoctor(),
                              type: PageTransitionType.upToDown,
                            ),
                          );
                        },
                      ),
                      buildOption(
                        title: 'اضافة ملف بيانات',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: AddFilesPage(),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        },
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
}

Widget buildOption({Function onTap, String title}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10),
          vertical: ScreenUtil().setHeight(10)),
      color: Const.mainColor,
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(16),
        right: ScreenUtil().setWidth(16),
        top: ScreenUtil().setHeight(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}
