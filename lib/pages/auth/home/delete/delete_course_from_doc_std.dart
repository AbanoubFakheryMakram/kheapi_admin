import 'package:admin/models/doctor.dart';
import 'package:admin/models/student.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class DeleteCourseFromStdOrDoc extends StatefulWidget {
  final String type;
  final Student student;
  final Doctor doctor;

  const DeleteCourseFromStdOrDoc(
      {Key key, this.type, this.doctor, this.student})
      : super(key: key);

  @override
  _DeleteCourseFromStdOrDocState createState() =>
      _DeleteCourseFromStdOrDocState();
}

class _DeleteCourseFromStdOrDocState extends State<DeleteCourseFromStdOrDoc> {
  List<String> doctorCourses;
  String type;

  @override
  void initState() {
    super.initState();

    doctorCourses = widget.doctor.subjects ?? null;
    type = widget.type;
    if (type == 'Students') {
      getStudentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'حذف',
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
                      tag: 'assets/images/delete.png',
                      child: Image.asset('assets/images/delete.png'),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Text(
                      '${doctorCourses != null && doctorCourses.isNotEmpty && widget.type == 'Doctors' ? widget.doctor.name : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Const.mainColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    doctorCourses != null && widget.type == 'Doctors'
                        ? Expanded(
                            child: ListView.builder(
                              addAutomaticKeepAlives: true,
                              itemCount: widget.doctor.subjects.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    deleteCourseFromDoctor(
                                        context, '${doctorCourses[index]}');
                                  },
                                  leading: Text(
                                    'X',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.description,
                                    color: Const.mainColor,
                                  ),
                                  title: Text(
                                    '${doctorCourses[index]}',
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink()
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

  void deleteCourseFromDoctor(BuildContext context, String code) {
    AppUtils.showDialog(
      context: context,
      title: 'تحذير',
      negativeText: 'الغاء',
      positiveText: 'تاكيد',
      onNegativeButtonPressed: () {
        Navigator.of(context).pop();
      },
      onPositiveButtonPressed: () async {
        doctorCourses.remove('$code');
        Navigator.of(context).pop();
        setState(() {});
        AppUtils.showToast(msg: 'تم مسج الكورس');
        await Firestore.instance
            .collection('Doctors')
            .document(widget.doctor.id)
            .updateData(
          {
            'subjects': FieldValue.arrayRemove(['$code']),
          },
        );
      },
      contentText: 'هل تريد مسح الكورس؟',
    );
  }

  void getStudentData() async {
//    var stdDataDoc = await Firestore.instance
//        .collection('Students')
//        .document(widget.id)
//        .get();
//
//    Student currentStd = Student.fromMap(stdDataDoc.data);
  }
}
