import '../models/product.dart';

class CartItem {
  final Product _product;
  int _quantity;
  CartItem(this._product) : this._quantity = 1;

  double get totalValue => _product.price * _quantity;

  Product get product => _product;

  int get id => _product.id;

  int get quantity => _quantity;

  void increaseQuantity() => _quantity++;

  void decreaseQuantity() {
    if (_quantity > 1) _quantity--;
  }
}