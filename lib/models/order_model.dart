import 'product_model.dart';
import 'address_model.dart';

class OrderItem {
  final ProductModel product;
  final String selectedSize;
  final int selectedColor;
  final int quantity;
  final double price;

  OrderItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      selectedSize: map['selectedSize'] as String? ?? '',
      selectedColor: map['selectedColor'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 1,
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
      'price': price,
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final AddressModel address;
  final String paymentMethod;
  final String paymentCardNumber;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    required this.paymentCardNumber,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (map['totalPrice'] as num? ?? 0.0).toDouble(),
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>? ?? {}),
      paymentMethod: map['paymentMethod'] as String? ?? '',
      paymentCardNumber: map['paymentCardNumber'] as String? ?? '',
      status: map['status'] as String? ?? 'Pending',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'address': address.toMap(),
      'paymentMethod': paymentMethod,
      'paymentCardNumber': paymentCardNumber,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
