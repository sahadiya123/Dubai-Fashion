// ignore_for_file: unnecessary_underscores, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/banner_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Dubai Fashion', style: AppTextStyles.heading2),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          final docs = snapshot.data?.docs ?? [];
          final products = docs
              .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          final featured = products.where((p) => p.isFeatured).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: AppDummyData.banners.length,
                    itemBuilder: (_, i) =>
                        BannerCard(data: AppDummyData.banners[i]),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: SmoothPageIndicator(
                    controller: _bannerController,
                    count: AppDummyData.banners.length,
                    effect: const WormEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      activeDotColor: AppColors.accent,
                      dotColor: AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Show prompt if database is empty
                if (products.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off_outlined, size: 64, color: AppColors.textGrey),
                          const SizedBox(height: AppSpacing.md),
                          const Text(
                            'No products in the database.',
                            style: AppTextStyles.heading3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: const Text('Featured', style: AppTextStyles.heading2),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (_, i) => ProductCard(
                        product: featured[i],
                        onTap: () => context.push(
                          '/product/${featured[i].id}',
                          extra: featured[i],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text('All Products', style: AppTextStyles.heading2),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, i) => ProductCard(
                        product: products[i],
                        onTap: () => context.push(
                          '/product/${products[i].id}',
                          extra: products[i],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
