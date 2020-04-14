import 'dart:io';

import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class AddStudentsFile extends StatefulWidget {
  final File selectedFile;

  const AddStudentsFile({Key key, this.selectedFile}) : super(key: key);

  @override
  _AddStudentsFileState createState() => _AddStudentsFileState();
}

class _AddStudentsFileState extends State<AddStudentsFile> {
  List<List<dynamic>> loadedData;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();

    loadCSVFile();
  }

  loadCSVFile() async {
    final data = await rootBundle.loadString('assets/csv/std.csv');
    loadedData = CsvToListConverter().convert(data);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      isDismissible: false,
      showLogs: false,
    );
    pr.style(
        message: 'Uploading data...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    hideLoadingHud(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              uploadToDatabase(context);
            },
          ),
        ],
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة ملف طلاب',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: networkProvider.hasNetworkConnection == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : networkProvider.hasNetworkConnection
              ? loadedData == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Table(
                            border: TableBorder.all(
                              width: 1,
                            ),
                            children: loadedData.map(
                              (itemList) {
                                return TableRow(
                                    children: itemList.map(
                                  (row) {
                                    return Text(
                                      row == null || row.toString().isEmpty
                                          ? 'null'
                                          : row.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: row == null ||
                                                row.toString().isEmpty
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    );
                                  },
                                ).toList());
                              },
                            ).toList(),
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

  showLoadingHud(BuildContext context) async {
    pr.show();
  }

  hideLoadingHud(BuildContext context) {
    pr.dismiss();
    pr.hide();
    setState(() {});
  }

  void uploadToDatabase(BuildContext context) async {
    showLoadingHud(context);
    var firetore = Firestore.instance.collection('Students');
    for (int i = 0; i < loadedData.length; i = i + 8) {
      pr.update(
        progress: i.toDouble(),
        message: "...جاري الرفع",
        progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
        maxProgress: loadedData.length.toDouble(),
        progressTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
        ),
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
          fontWeight: FontWeight.w600,
        ),
      );

      await firetore.document('${loadedData[i][1]}').setData(
        {
          'image': '',
          'semester': '',
          'name': '${loadedData[i][0]}',
          'id': '${loadedData[i][1]}',
          'password': '${loadedData[i][2]}',
          'level': '${loadedData[i][3]}',
          'email': '${loadedData[i][4]}',
          'phone': '${loadedData[i][5]}',
          'ssn': '${loadedData[i][6]}',
          'academicYear': '${loadedData[i][7]}',
        },
      );

      // get all subjects
      var allSubjects =
          await Firestore.instance.collection('Subjects').getDocuments();
      // loop thought each subject
      for (int j = 0; j < allSubjects.documents.length; j++) {
        // if current subject's code == the current doctor's subject code then register(bind) doctor with this subject
        if (allSubjects.documents[j].documentID == '${loadedData[i + 1][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 2][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'Last attendance': '',
              'numberOfTimes': '0',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 3][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 4][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 5][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 6][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
        if (allSubjects.documents[j].documentID == '${loadedData[i + 7][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .collection('Students')
              .document('${loadedData[i][1]}')
              .setData(
            {
              'std_name': '${loadedData[i][0]}',
              'id': '${loadedData[i][1]}',
              'numberOfTimes': '0',
              'Last attendance': '',
              'attendenc': <String>[],
            },
          );
        }
      }
    }

    hideLoadingHud(context);
    AppUtils.showToast(msg: 'تم الرفع');
  }
}
