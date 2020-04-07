import 'package:admin/pages/auth/home/add/add_course_file.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class AddFilesPage extends StatefulWidget {
  @override
  _AddFilesPageState createState() => _AddFilesPageState();
}

class _AddFilesPageState extends State<AddFilesPage> {
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
              ? Column(
                  children: <Widget>[
                    Hero(
                      tag: 'assets/images/add.png',
                      child: Image.asset('assets/images/add.png'),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(60),
                    ),
                    Text(
                      'الملفات المدعومة هي ملفات  CSV  فقط',
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(35),
                      ),
                      child: RaisedButton(
                        color: Const.mainColor,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddCourseFile(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'اضافة كورس',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(35),
                      ),
                      child: RaisedButton(
                        color: Const.mainColor,
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            'اضافة طالب',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(35),
                      ),
                      child: RaisedButton(
                        color: Const.mainColor,
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            'اضافة دكتور',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
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
