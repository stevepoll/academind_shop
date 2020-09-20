import 'dart:convert';

import 'package:academind_shop/models/http_exception.dart';
import 'package:academind_shop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Order.fromJson(String key, Map<String, dynamic> jsonMap)
      : id = key,
        amount = jsonMap['amount'] as double,
        dateTime = DateTime.parse(jsonMap['dateTime']),
        cartItems = (jsonMap['cartItems'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'cartItems': cartItems != null
            ? cartItems.map((e) => e.toJson()).toList()
            : null,
        'dateTime': dateTime.toIso8601String(),
      };
}

class Orders with ChangeNotifier {
  static const BASE_URL = 'https://academind-flutter-shop.firebaseio.com';

  List<Order> _orders = [];
  final String userId;
  final String authToken;

  Orders(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  String get url {
    return '$BASE_URL/orders/$userId.json?auth=$authToken';
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    final newOrder = Order(
      id: null,
      amount: amount,
      dateTime: DateTime.now(),
      cartItems: cartItems,
    );

    final response = await http.post(url, body: json.encode(newOrder));
    if (response.statusCode > 400) {
      throw HttpException('Error adding order');
    } else {
      _orders.add(newOrder);
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    List<Order> fetchedOrders = [];

    try {
      final response = await http.get(url);
      Map<String, dynamic> data = json.decode(response.body);

      if (data != null) {
        data.entries.forEach((order) {
          fetchedOrders.add(Order.fromJson(order.key, order.value));
        });

        _orders = fetchedOrders.reversed.toList();
        notifyListeners();
      }
    } on HttpException catch (e) {
      print(e);
      throw HttpException('Error fetching orders');
    }
  }
}
