import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUtils {
  static Future<bool> getConnectionState() async {
    return await DataConnectionChecker().hasConnection;
  }

  static void showDialog({
    @required BuildContext context,
    @required String title,
    @required String negativeText,
    @required String positiveText,
    @required Function onPositiveButtonPressed,
    Function onNegativeButtonPressed,
    @required String contentText,
    bool dismissWhenClickOutsideDialog,
    DialogTransitionType type,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: dismissWhenClickOutsideDialog ?? true,
      animationType: type ?? DialogTransitionType.scale,
      duration: Duration(
        milliseconds: 400,
      ),
      builder: (context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          negativeText: negativeText,
          positiveText: (positiveText == '' || positiveText == null)
              ? null
              : positiveText,
          onNegativeClick: onNegativeButtonPressed,
          contentText: contentText,
          onPositiveClick: onPositiveButtonPressed ??
              () {
                Navigator.of(context).pop();
              },
        );
      },
    );
  }

  static hidwKeyboared(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static showToast({@required msg, int timeInSeconds, Color backgroundColor}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? Color(0xff1E1E1E),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // true if granted : false if denied
  static Future<bool> askPhotosPermission() async {
    bool permissionState = false;
    await PermissionHandler().requestPermissions([
      Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos,
    ]).then(
      (Map<PermissionGroup, PermissionStatus> map) {
        if (map[PermissionGroup.storage] == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );

    print('state of permission >>>> $permissionState');
    return permissionState;
  }

  static bool getNetworkState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
        return false;
      default:
        return false;
    }
  }
}
