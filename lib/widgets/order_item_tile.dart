import 'package:academind_shop/providers/cart.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  final CartItem item;

  OrderItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
      trailing: Text(item.quantity.toString()),
      dense: true,
    );
  }
}
