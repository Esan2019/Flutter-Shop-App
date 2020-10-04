import 'package:flutter/foundation.dart';

class Product {
  @required
  final int _id;
  @required
  final String _title;
  @required
  final String _description;
  @required
  final double _price;
  @required
  final String _imageUrl;
  bool _isFavorite;

  Product({
    @required int id,
    @required String title,
    @required String description,
    double price,
    @required String imageUrl,
    bool isFavorite,
  })  : _id = id,
        _title = title,
        _description = description,
        _price = price ?? 0.0,
        _imageUrl = imageUrl,
        _isFavorite = isFavorite ?? false;

  int get id => _id;

  String get title => _title;

  String get description => _description;

  double get price => _price;

  String get imageUrl => _imageUrl;

  bool get isFavorite => _isFavorite;

  void toggleFavoriteStatus() {
    _isFavorite = !_isFavorite;
  }
}
