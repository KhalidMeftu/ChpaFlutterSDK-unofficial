import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

String generateTransactionReference(String companyName) {
  var uuid = Uuid();
  String uniqueId = uuid.v4();
  DateTime now = DateTime.now();
  String timestamp = now.millisecondsSinceEpoch.toString();
  String transactionReference = '$companyName-$uniqueId-$timestamp';
  return transactionReference;
}

