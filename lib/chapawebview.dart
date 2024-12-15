import 'dart:async';
import 'package:chapasdk/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'constants/common.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String ttx;

  const ChapaWebView(
      {Key? key, required this.url, required this.fallBackNamedUrl, required this.ttx})
      : super(key: key);

  @override
  State<ChapaWebView> createState() => _ChapaWebViewState();
}

class _ChapaWebViewState extends State<ChapaWebView> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  StreamSubscription? connection;
  bool isOffline = false;

  @override
  void initState() {
    checkConnectivity();

    super.initState();
  }


  void checkConnectivity() {
    connection = Connectivity().onConnectivityChanged.listen((dynamic result) {
      if (result is ConnectivityResult) {
        handleConnectivityChange(result);
      } else if (result is List<ConnectivityResult>) {
        for (var res in result) {
          handleConnectivityChange(res);
        }
      }
    });
  }

  void handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
      showErrorToast(ChapaStrings.connectionError);
      exitPaymentPage(ChapaStrings.connectionError, widget.ttx);
    }
    else if (result == ConnectivityResult.mobile) {
      setState(() {
        isOffline = false;
      });
    }
    else if (result == ConnectivityResult.wifi) {
      setState(() {
        isOffline = false;
      });
    } else if (result == ConnectivityResult.ethernet) {
      setState(() {
        isOffline = false;
      });
    }
    else if (result == ConnectivityResult.bluetooth) {
      setState(() {
        isOffline = false;
      });
      exitPaymentPage(ChapaStrings.connectionError, widget.ttx);
    }
  }

  void exitPaymentPage(String message, String ttx) {
    Navigator.pushNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {'message': message,'ttx':ttx},
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url:WebUri(widget.url)),
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(ChapaStrings.paymentCancelled, "");
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  Uri? uri, androidIsReload) async {

                if (uri.toString() == 'https://chapa.co') {
                  exitPaymentPage(ChapaStrings.paymentSuccessful, widget.ttx);
                }
                if (uri.toString().contains('checkout/payment-receipt/')) {
                  await delay();
                  exitPaymentPage(ChapaStrings.paymentSuccessful, widget.ttx);
                }
                if(uri.toString().contains('checkout/test-payment-receipt/')){
                  await delay();
                  exitPaymentPage(ChapaStrings.paymentSuccessful, widget.ttx);

                }
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.handlerArgs,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.failed) {
                        await delay();
                        exitPaymentPage(ChapaStrings.payementFailed,"");
                      }
                      if (args[2][1] == ChapaStrings.success) {
                        await delay();
                        exitPaymentPage(ChapaStrings.paymentSuccessful, widget.ttx);
                      }
                      return args.reduce((curr, next) => curr + next);
                    });

                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(ChapaStrings.paymentCancelled,"");
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
