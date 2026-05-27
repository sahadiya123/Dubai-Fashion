import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  final String selectedSize;
  final int selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
