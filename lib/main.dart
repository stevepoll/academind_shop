import 'package:academind_shop/pages/cart_page.dart';
import 'package:academind_shop/pages/orders_page.dart';
import 'package:academind_shop/pages/product_detail_page.dart';
import 'package:academind_shop/providers/cart.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:academind_shop/providers/orders.dart';
import 'package:academind_shop/providers/products.dart';
import 'package:academind_shop/pages/products_overview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsOverviewPage(),
        routes: {
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrdersPage.routeName: (ctx) => OrdersPage(),
        },
      ),
    );
  }
}
