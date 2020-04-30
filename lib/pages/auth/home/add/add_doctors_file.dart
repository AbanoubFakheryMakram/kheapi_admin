import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class AddDoctorsFile extends StatefulWidget {
  final File selectedFile;

  const AddDoctorsFile({Key key, this.selectedFile}) : super(key: key);

  @override
  _AddDoctorsFileState createState() => _AddDoctorsFileState();
}

class _AddDoctorsFileState extends State<AddDoctorsFile> {
  List<List<dynamic>> loadedData;

  ProgressDialog pr;

  String _extension;

  bool isCSVFile = false;

  @override
  void initState() {
    super.initState();

    _extension = path.extension(widget.selectedFile.path).split('?').first;

    if (_extension == '.csv' || _extension == '.CSV') {
      isCSVFile = true;
      print(_extension);
      loadCSVFile();
    } else {
      isCSVFile = false;
      loadedData = [[]];
    }
  }

  loadCSVFile() async {
    final data = await widget.selectedFile.readAsString();
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
              if (isCSVFile) {
                uploadToDatabase(context);
              } else {
                AppUtils.showToast(msg: 'ملف غير صحيح');
              }
            },
          ),
        ],
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة ملف دكاترة',
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
                  : isCSVFile
                      ? Stack(
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
                                            row == null ||
                                                    row.toString().isEmpty
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
                                      ).toList(),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'ملف غير صحيح يجب ان يكون امتداد الملف csv. وليس $_extension',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
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
    var firetore = Firestore.instance.collection('Doctors');
    for (int i = 0; i < loadedData.length; i = i + 4) {
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
          'email': '${loadedData[i][3]}',
          'id': '${loadedData[i][1]}',
          'image': '',
          'name': '${loadedData[i][0]}',
          'password': '${loadedData[i][2]}',
          'phone': '${loadedData[i][4]}',
          'ssn': '${loadedData[i][5]}',
        },
      );

      await firetore.document('${loadedData[i][1]}').updateData(
        {
          'subjects': FieldValue.arrayUnion(['${loadedData[i + 1][0]}']),
        },
      );
      await firetore.document('${loadedData[i][1]}').updateData(
        {
          'subjects': FieldValue.arrayUnion(['${loadedData[i + 2][0]}']),
        },
      );
      await firetore.document('${loadedData[i][1]}').updateData(
        {
          'subjects': FieldValue.arrayUnion(['${loadedData[i + 3][0]}']),
        },
      );

      // get all subjects
      var allSubjects =
          await Firestore.instance.collection('Subjects').getDocuments();
      // loop thought each subject
      for (int j = 0; j < allSubjects.documents.length; j++) {
        // if current subject's code == the current doctor's subject code then register(bind) doctor with this subject
        if ('${loadedData[i + 1][0]}' != null &&
            allSubjects.documents[j].documentID == '${loadedData[i + 1][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .updateData(
            {
              'profName': '${loadedData[i][0]}',
              'profID': '${loadedData[i][1]}',
            },
          );
        }
        if ('${loadedData[i + 2][0]}' != null &&
            allSubjects.documents[j].documentID == '${loadedData[i + 2][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .updateData(
            {
              'profName': '${loadedData[i][0]}',
              'profID': '${loadedData[i][1]}',
            },
          );
        }
        if ('${loadedData[i + 3][0]}' != null &&
            allSubjects.documents[j].documentID == '${loadedData[i + 3][0]}') {
          await Firestore.instance
              .collection('Subjects')
              .document(allSubjects.documents[j].documentID)
              .updateData(
            {
              'profName': '${loadedData[i][0]}',
              'profID': '${loadedData[i][1]}',
            },
          );
        }
      }
    }

    hideLoadingHud(context);
    AppUtils.showToast(msg: 'تم الرفع');
  }
}
