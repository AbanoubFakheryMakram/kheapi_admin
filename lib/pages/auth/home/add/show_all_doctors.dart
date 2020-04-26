import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowAllDoctors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        title: Text(
          'كل الدكاترة',
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
                          DocumentSnapshot currentDoctor =
                              snapshot.data.documents[index];
                          return ListTile(
                            onTap: () {},
                            title: Text(
                              '${currentDoctor.data['name']}',
                              textAlign: TextAlign.right,
                            ),
                            subtitle: Text(
                              '${currentDoctor.data['id']}  :كود',
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(Icons.person_outline),
                            leading: currentDoctor.data['ssn'] == ''
                                ? Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  )
                                : Text(
                                    '${currentDoctor.data['ssn']}',
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
                  stream: Firestore.instance.collection('Doctors').snapshots(),
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
