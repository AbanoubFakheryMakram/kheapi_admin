import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddCourseFile extends StatefulWidget {
  @override
  _AddCourseFileState createState() => _AddCourseFileState();
}

class _AddCourseFileState extends State<AddCourseFile> {
  List<List<dynamic>> loadedData;

  @override
  void initState() {
    super.initState();

    loadCSVFile();
  }

  loadCSVFile() async {
    final data = await rootBundle.loadString('assets/csv/f1.csv');
    loadedData = CsvToListConverter().convert(data);
    print(loadedData);
  }

  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'اضافة ملف كورسات',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: loadedData == null
          ? SizedBox.shrink()
          : SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  width: 1,
                ),
                children: loadedData.map((currentItemList) {
                  return TableRow(
                      children: currentItemList.map((currentRow) {
                    return Text('test');
                  }).toList());
                }).toList(),
              ),
            ),
    );
  }
}
