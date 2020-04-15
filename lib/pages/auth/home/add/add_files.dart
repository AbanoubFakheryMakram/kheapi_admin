import 'dart:io';

import 'package:admin/pages/auth/home/add/add_course_file.dart';
import 'package:admin/pages/auth/home/add/add_doctors_file.dart';
import 'package:admin/pages/auth/home/add/add_file_info.dart';
import 'package:admin/pages/auth/home/add/add_stds_file.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class AddFilesPage extends StatefulWidget {
  @override
  _AddFilesPageState createState() => _AddFilesPageState();
}

class _AddFilesPageState extends State<AddFilesPage> {
  File selectedFile;

  Future<void> pickCSVFile() async {
    try {
      selectedFile = await FilePicker.getFile(
        type: FileType.custom,
        fileExtension: "csv",
      );

      setState(() {});
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddFileInfo(),
                ),
              );
            },
          ),
        ],
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
                    Image.asset('assets/images/add.png'),
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
                        onPressed: () async {
                          await pickCSVFile();
                          if (selectedFile == null) {
                            AppUtils.showToast(msg: 'قم باختيار الملف اولا');
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddCourseFile(selectedFile: selectedFile),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'اضافة كورسات',
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
                        onPressed: () async {
                          await pickCSVFile();
                          if (selectedFile == null) {
                            AppUtils.showToast(msg: 'قم باختيار الملف اولا');
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddStudentsFile(
                                selectedFile: selectedFile,
                              ),
                            ),
                          );
                          selectedFile = null;
                        },
                        child: Center(
                          child: Text(
                            'اضافة طلاب',
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
                        onPressed: () async {
                          await pickCSVFile();
                          if (selectedFile == null) {
                            AppUtils.showToast(msg: 'قم باختيار الملف اولا');
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddDoctorsFile(
                                selectedFile: selectedFile,
                              ),
                            ),
                          );
                          selectedFile = null;
                        },
                        child: Center(
                          child: Text(
                            'اضافة دكاترة',
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
