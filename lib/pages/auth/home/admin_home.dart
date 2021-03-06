import 'package:admin/models/admins.dart';
import 'package:admin/models/pointer.dart';
import 'package:admin/pages/auth/home/add/add_page.dart';
import 'package:admin/pages/auth/home/delete/delete_page.dart';
import 'package:admin/pages/auth/home/edit/edit_page.dart';
import 'package:admin/pages/auth/home/review/review_page.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:admin/utils/app_utils.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/firebase_methods.dart';
import 'package:admin/widgets/card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';

class AdminHomePage extends StatefulWidget {
  final String username;

  const AdminHomePage({Key key, this.username}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();

    Pointer.currentAdmin = null;
  }

  void loadUserData() async {
    DocumentSnapshot snapshot = await FirebaseUtils.getCurrentUserData(
      username: widget.username,
      collection: 'Admins',
    );

    Admin currentUser = Admin.fromMap(snapshot.data);
    Pointer.currentAdmin = currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      allowFontScaling: true,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );

    var networkProvider = Provider.of<NetworkProvider>(context);

    if (networkProvider.hasNetworkConnection != null &&
        networkProvider.hasNetworkConnection) {
      if (Pointer.currentAdmin == null || Pointer.currentDoctor.name == null) {
        loadUserData();
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              AppUtils.showDialog(
                context: context,
                title: 'تسجيل الخروج',
                negativeText: 'تاكيد',
                positiveText: 'الغاء',
                onPositiveButtonPressed: () {
                  Navigator.of(context).pop();
                },
                onNegativeButtonPressed: () {
                  SharedPreferences.getInstance().then(
                    (pref) {
                      pref.clear();
                      Pointer.currentAdmin = null;
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => LoginPage(),
                        ),
                      );
                    },
                  );
                },
                contentText: 'هل تريد تسجيل الخروج؟',
              );
            },
          ),
        ],
        backgroundColor: Const.mainColor,
        leading: SizedBox.shrink(),
        title: Text(
          'غيابي ادمن',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: networkProvider.hasNetworkConnection == null ||
              Pointer.currentAdmin == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : networkProvider.hasNetworkConnection
              ? Center(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            20,
                          ),
                        ),
                        Pointer.currentAdmin.name == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SlideInDown(
                                child: Text(
                                  '${Pointer.currentAdmin.name ?? ''}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold,
                                    color: Const.mainColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            15,
                          ),
                        ),
                        FadeInLeft(
                          child: buildCards(
                            imageAsset: 'assets/images/add.png',
                            text: 'اضافة',
                            onTap: Pointer.currentAdmin.name == null ||
                                    Pointer.currentAdmin.name.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: AddPage(),
                                        type: PageTransitionType.downToUp,
                                      ),
                                    );
                                  },
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            15,
                          ),
                        ),
                        FadeInRight(
                          child: buildCards(
                            imageAsset: 'assets/images/delete.png',
                            text: 'حذف',
                            onTap: Pointer.currentAdmin.name == null ||
                                    Pointer.currentAdmin.name.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: DeletePage(),
                                        type: PageTransitionType.fade,
                                      ),
                                    );
                                  },
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            15,
                          ),
                        ),
                        FadeInRight(
                          child: buildCards(
                            imageAsset: 'assets/images/review.png',
                            text: 'مراجعة',
                            onTap: Pointer.currentAdmin.name == null ||
                                    Pointer.currentAdmin.name.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: ReviewPage(),
                                        type: PageTransitionType.scale,
                                      ),
                                    );
                                  },
                          ),
                        ),
                        FadeInLeft(
                          child: buildCards(
                            boxFit: BoxFit.fill,
                            imageAsset: 'assets/images/edit.jpg',
                            text: 'تعديل',
                            onTap: Pointer.currentAdmin.name == null ||
                                    Pointer.currentAdmin.name.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      PageTransition(
                                        child: EditPage(),
                                        type: PageTransitionType
                                            .leftToRightWithFade,
                                      ),
                                    );
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
}
