import 'package:example2/provider/cart_provider.dart';
import 'package:example2/screens/cart_screen.dart';
import 'package:example2/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/checkoutPage':(context)=>const CartScreen()
          },
          home: const ProductList(),
        );
      }),
    );
  }
}
