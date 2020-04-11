import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowAllStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'كل الطلاب',
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
              ? StreamBuilder(
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          DocumentSnapshot currentStudent =
                              snapshot.data.documents[index];
                          return ListTile(
                            onTap: () {},
                            title: Text(
                              '${currentStudent.data['name']}',
                              textAlign: TextAlign.right,
                            ),
                            subtitle: Text(
                              '${currentStudent.data['id']}',
                              textAlign: TextAlign.right,
                            ),
                            leading: currentStudent.data['level'] == ''
                                ? Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  )
                                : Text(
                                    'المستوي:  ${currentStudent.data['level']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                          );
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  stream: Firestore.instance.collection('Students').snapshots(),
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
