import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

const ordersJson = """
{
  "-MGzAFZJsqkwvj1-wZB7": 
    {
      "amount": 79.98, 
      "cartItems": [
        {
          "id": "2020-09-11 17:58:06.728708",
          "price": 59.99, 
          "productId": "p2", 
          "quantity": 1, 
          "title": "Trouser"
        }, 
        {
          "id": "2020-09-11 17:58:07.578086",
          "price": 19.99, 
          "productId": "p3", 
          "quantity": 1, 
          "title": "Yellow Scarfs"
        }
      ], 
      "dateTime": "2020-09-11T17:58:10.776567", 
      "id": "2020-09-11 17:58:10.776481"
    }, 
  "-MGzBSmf78bTkBdICMPO": 
    {
      "amount": 119.98, 
      "cartItems": [
        {
          "id": "2020-09-11 18:03:24.298501", 
          "price": 59.99, 
          "productId": "p2", 
          "quantity": 2, 
          "title": "Trouser"
        }
      ], 
      "dateTime": "2020-09-11T18:03:27.277057", 
      "id": "2020-09-11 18:03:27.276971"
    }
}
""";

class Order {
  String id;
  double amount;
  DateTime dateTime;
  List<CartItem> cartItems;

  Order.fromJson(String key, Map<String, dynamic> jsonMap)
      : id = key,
        amount = jsonMap['amount'] as double,
        dateTime = DateTime.parse(jsonMap['dateTime']),
        cartItems = (jsonMap['cartItems'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();
}

class CartItem {
  String id;
  String productId;
  String title;
  int quantity;
  double price;

  CartItem.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        price = jsonMap['price'],
        productId = jsonMap['productId'],
        quantity = jsonMap['quantity'],
        title = jsonMap['title'];
}

void main() {
  List<Order> orders = [];
  test('Test decoding json', () {
    var jsonDecoded = json.decode(ordersJson) as Map<String, dynamic>;
    jsonDecoded.keys.forEach((key) {
      var myMap = jsonDecoded[key] as Map<String, dynamic>;
      orders.add(Order.fromJson(key, myMap));
    });
    expect(orders.length, equals(2));
  });
}
