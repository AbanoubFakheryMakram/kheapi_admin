import 'package:admin/pages/auth/login_page.dart';
import 'package:admin/providers/network_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth/home/admin_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  SharedPreferences.getInstance().then(
    (pref) {
      runApp(
        MyApp(
          username: pref.getString('username') ?? '',
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final String username;

  const MyApp({
    Key key,
    this.username,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NetworkProvider(),
        )
      ],
      child: MaterialApp(
        title: 'غيابي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: username == '' ? LoginPage() : AdminHomePage(username: username),
      ),
    );
  }
}
