// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  final String category;
  const ProductListingScreen({super.key, required this.category});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String _selectedCategory = 'All';
  final _categories = [
    'All',
    'Women',
    'Men',
    'Kids',
    'Footwear',
    'Bags',
    'Watches',
    'Jewelry'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Products', style: AppTextStyles.heading3),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          final docs = snapshot.data?.docs ?? [];
          final allProducts = docs
              .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          final products = _selectedCategory == 'All'
              ? allProducts
              : allProducts.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

          return Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final selected = _categories[i] == _selectedCategory;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = _categories[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          _categories[i],
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.textGrey,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Text('${products.length} items', style: AppTextStyles.bodyGrey),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text('No products found',
                            style: AppTextStyles.bodyGrey))
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) => ProductCard(
                          product: products[i],
                          onTap: () => context.push('/product/${products[i].id}',
                              extra: products[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
