import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    return _items.values
        .fold(0, (prev, curr) => prev + (curr.price * curr.quantity));
  }

  void addItem(String productId, double price, String title) {
    _items.update(
      productId,
      (val) => CartItem(
        id: val.id,
        productId: val.productId,
        title: val.title,
        price: val.price,
        quantity: val.quantity + 1,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        productId: productId,
        title: title,
        price: price,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      // Reduce quantity by one
      _items.update(
        productId,
        (curr) => CartItem(
          id: curr.id,
          productId: productId,
          title: curr.title,
          quantity: curr.quantity - 1,
          price: curr.price,
        ),
      );
    } else {
      // Remove entire entry
      _items.remove(productId);
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
