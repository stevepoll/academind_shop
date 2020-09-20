import 'dart:convert';

import 'package:academind_shop/models/http_exception.dart';
import 'package:academind_shop/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  static const BASE_URL =
      'https://academind-flutter-shop.firebaseio.com/products';

  final authToken;
  final String userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  String productsUrl({String productId, bool filterByUser = false}) {
    if (productId != null) {
      return '$BASE_URL/$productId.json?auth=$authToken';
    }
    final filter = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    return '$BASE_URL.json?$filter&auth=$authToken';
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      final response = await http.get(productsUrl(filterByUser: filterByUser));
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        final favoritesUrl =
            'https://academind-flutter-shop.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
        final favoritesResponse = await http.get(favoritesUrl);
        final favoritesMap = json.decode(favoritesResponse.body);
        _items = data.entries
            .map((el) => Product(
                  id: el.key,
                  title: el.value['title'],
                  description: el.value['description'],
                  price: el.value['price'],
                  imageUrl: el.value['imageUrl'],
                  isFavorite: favoritesMap == null
                      ? false
                      : favoritesMap[el.key] ?? false,
                ))
            .toList();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(productsUrl(),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct =
          product.copyWith(id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final id = updatedProduct.id;
    final index = _items.indexWhere((item) => item.id == id);

    if (index > -1) {
      await http.patch(productsUrl(productId: id),
          body: json.encode(updatedProduct));
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    var product = _items[index];

    // Optimistic updating
    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(productsUrl(productId: id));
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
