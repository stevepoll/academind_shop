import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:academind_shop/providers/orders.dart';
import 'package:academind_shop/widgets/app_drawer.dart';
import 'package:academind_shop/widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderCard(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
