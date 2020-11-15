import '../models/product.dart';

class CartItem {
  final Product _product;
  int _quantity;
  CartItem(this._product) : this._quantity = 1;
  CartItem.fromMap(Map<String, dynamic> map)
      : this._product = Product.fromMap(map['product']),
        this._quantity = map['quantity'];

  double get totalValue => _product.price * _quantity;

  Product get product => _product;

  String get id => _product.id;

  int get quantity => _quantity;

  void increaseQuantity() => _quantity++;

  void decreaseQuantity() {
    if (_quantity > 1) _quantity--;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'totalValue': totalValue,
    };
  }
}
