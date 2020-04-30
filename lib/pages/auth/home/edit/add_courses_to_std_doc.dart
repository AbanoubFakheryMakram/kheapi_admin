import 'package:admin/models/doctor.dart';
import 'package:admin/models/student.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

class AddCoursesToStdDoc extends StatefulWidget {
  final Student student;
  final Doctor doctor;

  const AddCoursesToStdDoc({
    Key key,
    @required this.student,
    @required this.doctor,
  }) : super(key: key);

  @override
  _AddCoursesToStdDocState createState() => _AddCoursesToStdDocState();
}

class _AddCoursesToStdDocState extends State<AddCoursesToStdDoc> {
  var subjects = [];
  var selected = [];

  bool showUnSelectedCoursesError = false;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection &&
        !loaded) {
      getSubjects();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'تحديد المقررات',
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
              ? subjects.isEmpty && !loaded
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : subjects.isEmpty && loaded
                      ? Center(
                          child: Text('قم باضافة مواد اولا'),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil().setHeight(15),
                                ),
                                Text(
                                  widget.doctor == null
                                      ? widget.student.name
                                      : widget.doctor.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Const.mainColor,
                                  ),
                                ),
                                MultiSelectFormField(
                                  titleText: 'المقررات',
                                  autovalidate: showUnSelectedCoursesError,
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'من فضلك قم بتحديد المقررات';
                                    } else {
                                      return null;
                                    }
                                  },
                                  dataSource: subjects,
                                  textField: 'display',
                                  valueField: 'value',
                                  okButtonLabel: 'تم',
                                  cancelButtonLabel: 'الغاء',
                                  // required: true,
                                  hintText: 'من فضلك قم بتحديد المقررات',
                                  value: selected,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    selected = value;
                                    showUnSelectedCoursesError = false;
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(26),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                    right: ScreenUtil().setWidth(20),
                                    bottom: ScreenUtil().setWidth(30),
                                  ),
                                  height: ScreenUtil().setHeight(48),
                                  child: ProgressButton(
                                    color: Const.mainColor,
                                    child: Text(
                                      'تسجيل',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    onPressed:
                                        (AnimationController controller) {
                                      validateAndSave(controller);
                                    },
                                  ),
                                ),
                              ],
                            ),
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

  void validateAndSave(AnimationController controller) async {
    if (selected.isEmpty) {
      AppUtils.showToast(msg: 'قم بتحديد المقررات اولا');
      controller.reverse();
      showUnSelectedCoursesError = true;
      setState(() {});
      return;
    }

    controller.forward();
    showUnSelectedCoursesError = false;
    setState(() {});

    // register std in the courses
    if (widget.student != null) {
      for (int i = 0; i < selected.length; i++) {
        await Firestore.instance
            .collection('Subjects')
            .document(selected[i])
            .collection('Students')
            .document(widget.student.id)
            .setData(
          {
            'Last attendance': '',
            'attendenc': <String>[],
            'id': widget.student.id,
            'numberOfTimes': '0',
            'std_name': widget.student.name,
          },
        );
      }
    } else {
      for (int i = 0; i < selected.length; i++) {
        await Firestore.instance
            .collection('Doctors')
            .document(widget.doctor.id)
            .updateData(
          {
            'subjects': FieldValue.arrayUnion([selected[i]]),
          },
        );

        await Firestore.instance
            .collection('Subjects')
            .document(selected[i])
            .updateData(
          {
            'profID': '${widget.doctor.id}',
            'profName': '${widget.doctor.name}',
            'currentCount': '0',
          },
        );
      }
    }

    selected.clear();
    AppUtils.showToast(msg: 'تمت الاضافة');
    controller.reverse();
    setState(() {});
  }

  void getSubjects() async {
    subjects.clear();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Subjects')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      // move inside each subject
      DocumentSnapshot currentSubject = querySnapshot.documents[i];
      subjects.add(
        {
          'value': currentSubject.data['code'],
          'display': currentSubject.data['name'],
        },
      );
    }

    loaded = true;
    setState(() {});
  }
}
