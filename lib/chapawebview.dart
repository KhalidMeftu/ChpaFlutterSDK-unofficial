import 'dart:async';
import 'package:chapasdk/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'constants/common.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;

  const ChapaWebView(
      {Key? key, required this.url, required this.fallBackNamedUrl})
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
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
        showErrorToast(ChapaStrings.connectionError);

        exitPaymentPage(ChapaStrings.connectionError);
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        setState(() {
          isOffline = false;
        });
        exitPaymentPage(ChapaStrings.connectionError);
      }
    });
  }

  void exitPaymentPage(String message) {
    Navigator.pushNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {'message': message},
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
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(ChapaStrings.paymentCancelled);
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  Uri? uri, androidIsReload) async {
                print("Next URL IS");
                print(uri.toString());
                if (uri.toString() == 'https://chapa.co') {
                  exitPaymentPage(ChapaStrings.paymentSuccessful);
                }
                if (uri.toString().contains('checkout/payment-receipt/')) {
                  await delay();
                  exitPaymentPage(ChapaStrings.paymentSuccessful);
                }
                if(uri.toString().contains('checkout/test-payment-receipt/')){
                  await delay();
                  exitPaymentPage(ChapaStrings.paymentSuccessful);

                }
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.handlerArgs,
                    callback: (args) async {
                      webViewController = controller;
                      print("Next URL IS2");
                      print(args[2][1]);
                      if (args[2][1] == ChapaStrings.failed) {
                        await delay();
                        exitPaymentPage(ChapaStrings.payementFailed);
                      }
                      if (args[2][1] == ChapaStrings.success) {
                        await delay();
                        exitPaymentPage(ChapaStrings.paymentSuccessful);
                      }
                      return args.reduce((curr, next) => curr + next);
                    });

                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;
                      print("Next URL IS3");
                      print(args[2][1]);
                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(ChapaStrings.paymentCancelled);
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
