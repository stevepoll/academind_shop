import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:academind_shop/providers/orders.dart';
import 'package:academind_shop/widgets/app_drawer.dart';
import 'package:academind_shop/widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              // Do error handling here
              return Center(child: Text('An error occurred'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, _) => ListView.builder(
                  itemBuilder: (ctxx, i) => OrderCard(orderData.orders[i]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          },
        ));
  }
}
