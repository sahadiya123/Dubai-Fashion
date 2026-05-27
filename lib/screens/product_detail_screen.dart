// ignore_for_file: unnecessary_underscores, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedSize;
  int? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor =
        widget.product.colors.isNotEmpty ? widget.product.colors[0] : null;
  }

  void _addToCart() {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a size'),
            backgroundColor: AppColors.accent),
      );
      return;
    }
    context
        .read<CartProvider>()
        .addItem(widget.product, _selectedSize!, _selectedColor ?? 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final discount = (((p.oldPrice - p.price) / p.oldPrice) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ]),
            child: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textDark, size: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 340,
                width: double.infinity,
                child: Image.network(
                  p.images[_selectedImageIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      color: AppColors.border,
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: AppColors.textGrey)),
                ),
              ),
              if (discount > 0)
                Positioned(
                  top: 90,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: Text('-$discount%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
                ),
              if (p.images.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        p.images.length,
                        (i) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedImageIndex = i),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: i == _selectedImageIndex
                                          ? AppColors.accent
                                          : Colors.transparent,
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(p.images[i],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            )),
                  ),
                ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.brand,
                                style: AppTextStyles.caption
                                    .copyWith(color: AppColors.accent)),
                            Text(p.name, style: AppTextStyles.heading2),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Rs. ${p.price.toStringAsFixed(2)}',
                              style: AppTextStyles.price),
                          Text('Rs. ${p.oldPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.caption.copyWith(
                                  decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Select Size', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: p.sizes.map((size) {
                      final selected = size == _selectedSize;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color:
                                  selected ? Colors.white : AppColors.textDark,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Select Color', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: p.colors.map((color) {
                      final selected = color == _selectedColor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(color),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.border,
                              width: selected ? 2.5 : 1,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Description', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    p.description,
                    style: AppTextStyles.bodyGrey.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white),
                label: const Text('Add to Cart', style: AppTextStyles.button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
