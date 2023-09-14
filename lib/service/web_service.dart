import 'dart:convert';
import 'package:chapasdk/chapawebview.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:chapasdk/constants/utils.dart';
import 'package:chapasdk/model/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
Future<Object> intilizeMyPayment(
  BuildContext context,
  String authorization,
  String email,
  String amount,
  String currency,
  String firstName,
  String lastName,
  String transactionReference,
  String customTitle,
  String customDescription,
  String fallBackNamedRoute,
) async {
  final http.Response response = await http.post(
    Uri.parse(ChapaUrl.baseUrl),
    headers: {
      'Authorization': 'Bearer $authorization',
    },
    body: {
      'email': email,
      'amount': amount,
      'currency': currency.toUpperCase(),
      'first_name': firstName,
      'last_name': lastName,
      'tx_ref': transactionReference,
      'customization[title]': customTitle,
      'customization[description]': customDescription
    },
  );
  var jsonResponse = json.decode(response.body);

  if (response.statusCode == 400) {
    showToast(jsonResponse);
  } else if (response.statusCode == 200) {
    ResponseData res = ResponseData.fromJson(jsonResponse);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChapaWebView(
                url: res.data.checkoutUrl.toString(),
                fallBackNamedUrl: fallBackNamedRoute,
              )),
    );

    return res.data.checkoutUrl.toString();
  }

  return showToast(jsonResponse['message'].toString());
}

