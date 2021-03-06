import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final url =
        'https://flutter-shop-dca7d.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    final tempFav = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = tempFav;
        notifyListeners();
        throw HttpException('Could not Change the favourite status.');
      }
    } catch (error) {
      throw (error);
    }
  }
}
