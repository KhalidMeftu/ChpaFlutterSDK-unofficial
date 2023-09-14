import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
Future<bool?> showToast(jsonResponse) {
  return Fluttertoast.showToast(
      msg: jsonResponse,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
