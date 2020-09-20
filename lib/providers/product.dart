import 'dart:convert';

import 'package:academind_shop/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  static const PRODUCTS_URL =
      'https://academind-flutter-shop.firebaseio.com/products';

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    var prod = Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );

    return prod;
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'];
  // isFavorite = json['isFavorite'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        // 'isFavorite': isFavorite,
      };

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;

    // Optimistic updating
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://academind-flutter-shop.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        throw HttpException('Error updating favorite status');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
