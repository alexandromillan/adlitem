import 'package:adlitem_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class AppMessage {
  static ShowInfo(message, context) {
    //Size size = MediaQuery.of(context).size;
    var snackBar = SnackBar(
      content: GestureDetector(
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            message,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
      showCloseIcon: true,
      elevation: 3,
      duration: Duration(seconds: 2),
      backgroundColor: APP_COLORS.Primary,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.startToEnd,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static ShowError(message, context) {
    //Size size = MediaQuery.of(context).size;
    var snackBar = SnackBar(
      content: GestureDetector(
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            message,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
      showCloseIcon: true,
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.startToEnd,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
