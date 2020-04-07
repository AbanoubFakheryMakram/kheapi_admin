import 'package:admin/animations/fade_animation.dart';
import 'package:admin/models/subject.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/widgets/my_drop_down_form_field.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Map<String, String>> subjects = [];
  List<Subject> subjectsData = [];
  List<String> students;
  final Firestore _firestore = Firestore.instance;
  String subject = '';
  String doctorName = 'اسم الدكتور';

  bool searching = false;

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection) {
      if (subjects.isEmpty) {
        getSubjects();
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'مراجعة',
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
                      tag: 'assets/images/review.png',
                      child: Image.asset('assets/images/review.png'),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(18),
                      ),
                      child: MyFadeAnimation(
                        delayinseconds: 1,
                        child: MyDropDownFormField(
                          titleStyle: TextStyle(
                            color: Const.mainColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Const.mainColor,
                            ),
                          ),
                          titleText: 'المواد',
                          hintText: 'اختر المادة',
                          itemStyle: TextStyle(
                            color: Colors.black,
                          ),
                          value: subject,
                          onSaved: (value) {
                            handleSelection(value);
                          },
                          onChanged: (value) {
                            handleSelection(value);
                          },
                          dataSource: subjects,
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 1.5,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(18)),
                        width: double.infinity,
                        height: ScreenUtil().setHeight(40),
                        decoration: BoxDecoration(
                          color: Const.mainColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            doctorName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    subject.isEmpty
                        ? SizedBox.shrink()
                        : students.isEmpty && !searching
                            ? Container(
                                height: ScreenUtil().setHeight(100),
                                child: Center(
                                  child: Text(
                                    'لا يوجد طلاب تم تسجيلهم لهذا المقرر',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            : students.isEmpty && searching
                                ? Container(
                                    height: ScreenUtil().setHeight(100),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return SlideInRight(
                                            child: ListTile(
                                              onTap: () {},
                                              trailing: Icon(
                                                Icons.verified_user,
                                                color: Const.mainColor,
                                              ),
                                              title: Text(
                                                students[index],
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: students.length,
                                      ),
                                    ),
                                  )
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

  void getSubjects() async {
    subjects.clear();
    QuerySnapshot querySnapshot = await _firestore
        .collection('Subjects')
        .getDocuments(); // fetch all subjects

    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      DocumentSnapshot currentSubject = querySnapshot.documents[i];

      Subject subject = Subject(
        name: currentSubject.data['name'],
        code: currentSubject.data['code'],
        currentCount: currentSubject.data['currentCount'],
        profID: currentSubject.data['profID'],
        profName: currentSubject.data['profName'],
      );

      if (!subjectsData.contains(subject)) {
        subjectsData.add(subject);
        subjects.add(
          {
            'display':
                '   ${currentSubject.data['code']}                  ${currentSubject.data['name']}',
            'value': currentSubject.data['code'],
          },
        );
      }
    }

    setState(() {});
  }

  void handleSelection(value) async {
    subject = value;
    searching = true;
    setState(() {});
    // get doctor name for this course
    doctorName = subjectsData
        .firstWhere((currentSub) => currentSub.code == subject)
        .profName;
    students = [];

    setState(() {});

    // fetch students in that course
    var docs = await _firestore
        .collection('Subjects')
        .document(subject)
        .collection('Students')
        .getDocuments()
        .catchError((error) {
      print('$error');
    });

    for (int i = 0; i < docs.documents.length; i++) {
      students.add(docs.documents[i].data['std_name']);
    }

    searching = false;
    setState(() {});
  }
}
