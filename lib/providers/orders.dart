import 'package:academind_shop/providers/cart.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double amount) {
    _orders.add(
      Order(
        id: DateTime.now().toString(),
        amount: amount,
        dateTime: DateTime.now(),
        cartItems: cartItems,
      ),
    );
    notifyListeners();
  }
}
