import 'package:academind_shop/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:academind_shop/providers/cart.dart' as m;
import 'package:academind_shop/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<m.Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('Order Now'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final item = cart.items.values.toList()[index];
                return CartItem(
                  m.CartItem(
                    id: item.id,
                    productId: item.productId,
                    title: item.title,
                    price: item.price,
                    quantity: item.quantity,
                  ),
                );
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
