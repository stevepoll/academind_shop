import 'package:flutter/material.dart';

import 'package:academind_shop/providers/cart.dart' as model;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final model.CartItem item;

  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Provider.of<model.Cart>(context, listen: false).removeItem(item.productId);
      },
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('\$${item.price}'),
                ),
              ),
            ),
            title: Text('${item.title}'),
            subtitle: Text('Total: \$${item.price * item.quantity}'),
            trailing: Text('${item.quantity} x'),
          ),
        ),
      ),
    );
  }
}
