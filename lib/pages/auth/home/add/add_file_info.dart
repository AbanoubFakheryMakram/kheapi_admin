import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AddFileInfo extends StatefulWidget {
  @override
  _AddFileInfoState createState() => _AddFileInfoState();
}

class _AddFileInfoState extends State<AddFileInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'كيفية شكل ملف البيانات',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            Text(
              'ملاحظات كتابة ملف البيانات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '1- امتداد الملف يجب ان يكون .CSV',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Text(
              '2- يتم كتابة البيانات مباشرة بدون عناوين',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Text(
              '3- لا يجب ان يتم ترك صف كاملا خالي',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Text(
              '4- ينصح بادخال المواد اولا ثم الطلاب والدكاترة',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Text(
              '5- شكل البيانات عند انشاء ملف للمواد يجب ان يكون بنفس النسق',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text('Java'),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                  )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text('Comp101'),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text('2020-2021'),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            Text(
              '6- شكل البيانات عند انشاء ملف للطلاب يجب ان يكون بنفس النسق',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Image.asset(
              'assets/images/std_sample.png',
              width: MediaQuery.of(context).size.width * .9,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Text(
              '*  مواد الطالب لا تقل عن 7 مواد او تزيد عنه',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            Text(
              '7- شكل البيانات عند انشاء ملف للطلاب يجب ان يكون بنفس النسق',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Image.asset(
              'assets/images/doc_sample.png',
              width: MediaQuery.of(context).size.width * .9,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Text(
              '* مواد الدكتور لا تقل عن 3 مواد او تزيد عنه',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
          ],
        ),
      ),
    );
  }
}
