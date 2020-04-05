import 'package:flutter/material.dart';

Widget buildAppBar({
  BuildContext context,
  String title,
  Function onTap,
}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Tajawal',
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        onTap ?? Navigator.of(context).pop();
      },
    ),
  );
}
