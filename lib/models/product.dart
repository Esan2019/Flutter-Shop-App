class Product {
  final String _id;
  final String _title;
  final String _description;
  final double _price;
  final String _imageUrl;
  bool _isFavorite;

  Product({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  })  : _id = id,
        _title = title,
        _description = description,
        _price = price ?? 0.0,
        _imageUrl = imageUrl,
        _isFavorite = isFavorite ?? false;

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get id => _id;

  String get title => _title;

  String get description => _description;

  double get price => _price;

  String get imageUrl => _imageUrl;

  bool get isFavorite => _isFavorite;

  void toggleFavoriteStatus() {
    _isFavorite = !_isFavorite;
  }
}
