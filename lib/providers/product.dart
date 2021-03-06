import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;

  final String imageUrl;

  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.desc,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});
  //set new favorite status
  void _setFavValue(bool newSattus) {
    isFavorite = newSattus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      isFavorite = oldStatus;
    }
  }
}
