class ProductModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;
  final String category;
  final String image;
  final List<String> images;
  final List<String> sizes;
  final List<int> colors;
  final String description;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.image,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.description,
    required this.isFeatured,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      price: (map['price'] as num).toDouble(),
      oldPrice: (map['oldPrice'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      reviews: map['reviews'] as int,
      category: map['category'] as String,
      image: map['image'] as String,
      images: List<String>.from(map['images'] as List),
      sizes: List<String>.from(map['sizes'] as List),
      colors: List<int>.from(map['colors'] as List),
      description: map['description'] as String,
      isFeatured: map['isFeatured'] as bool,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'brand': brand,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'reviews': reviews,
        'category': category,
        'image': image,
        'images': images,
        'sizes': sizes,
        'colors': colors,
        'description': description,
        'isFeatured': isFeatured,
      };
}
