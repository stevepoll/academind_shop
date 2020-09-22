import 'package:academind_shop/helpers/custom_route.dart';
import 'package:academind_shop/pages/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:academind_shop/providers/auth.dart';
import 'package:academind_shop/providers/cart.dart';
import 'package:academind_shop/providers/orders.dart';
import 'package:academind_shop/providers/products.dart';
import 'package:academind_shop/pages/products_overview_page.dart';
import 'package:academind_shop/pages/edit_product_page.dart';
import 'package:academind_shop/pages/product_detail_page.dart';
import 'package:academind_shop/pages/manage_products_page.dart';
import 'package:academind_shop/pages/orders_page.dart';
import 'package:academind_shop/pages/cart_page.dart';
import 'package:academind_shop/pages/auth_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, prevProducts) => Products(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.items,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, prevOrders) => Orders(
            auth.token,
            auth.userId,
            prevOrders == null ? [] : prevOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isLoggedIn
              ? ProductsOverviewPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthPage(),
                ),
          routes: {
            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartPage.routeName: (ctx) => CartPage(),
            OrdersPage.routeName: (ctx) => OrdersPage(),
            ManageProductsPage.routeName: (ctx) => ManageProductsPage(),
            EditProductPage.routeName: (ctx) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
