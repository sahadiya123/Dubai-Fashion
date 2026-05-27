import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Shopping Cart', style: AppTextStyles.heading2),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => cart.items.isEmpty
                ? const SizedBox()
                : TextButton(
                    onPressed: () => cart.clearCart(),
                    child: const Text('Clear', style: TextStyle(color: AppColors.accent)),
                  ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 56, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Your cart is empty', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Add items to get started',
                    style: AppTextStyles.bodyGrey,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.storefront_outlined, color: Colors.white),
                    label: const Text('Continue Shopping', style: AppTextStyles.button),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ─── Item count bar ───────────────────────────────────────────
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Text(
                      '${cartProvider.itemCount} item${cartProvider.itemCount == 1 ? '' : 's'}',
                      style: AppTextStyles.bodyGrey,
                    ),
                  ],
                ),
              ),

              // ─── Cart items list ──────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: cartProvider.items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final item = cartProvider.items[i];
                    return Dismissible(
                      key: Key('${item.product.id}_${item.selectedSize}_${item.selectedColor}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 28),
                      ),
                      onDismissed: (_) => cartProvider.removeItem(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ─── Product Image ──────────────────────────────
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppRadius.md),
                                bottomLeft: Radius.circular(AppRadius.md),
                              ),
                              child: Image.network(
                                item.product.image,
                                width: 110,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 110,
                                  height: 130,
                                  color: AppColors.border,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.textGrey,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),

                            // ─── Product Info ───────────────────────────────
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Brand
                                    Text(
                                      item.product.brand,
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.accent),
                                    ),
                                    const SizedBox(height: 2),
                                    // Name
                                    Text(
                                      item.product.name,
                                      style: AppTextStyles.heading3,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),

                                    // Size & Color chips
                                    Row(
                                      children: [
                                        _Chip(label: item.selectedSize),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(item.selectedColor),
                                            border: Border.all(
                                                color: AppColors.border,
                                                width: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.sm),

                                    // Price + Qty controls
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Rs.${(item.product.price * item.quantity).toStringAsFixed(0)}',
                                          style: AppTextStyles.price,
                                        ),
                                        // Qty stepper
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.sm),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _QtyButton(
                                                icon: Icons.remove,
                                                onTap: () =>
                                                    cartProvider.decreaseQty(i),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              _QtyButton(
                                                icon: Icons.add,
                                                onTap: () =>
                                                    cartProvider.increaseQty(i),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ─── Order Summary & Checkout ──────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal (${cartProvider.itemCount} items)',
                          style: AppTextStyles.bodyGrey,
                        ),
                        Text(
                          'Rs.${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery', style: AppTextStyles.bodyGrey),
                        Text('FREE',
                            style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: AppTextStyles.heading3),
                        Text(
                          'Rs.${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.price,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/checkout'),
                        icon: const Icon(Icons.lock_outline,
                            color: Colors.white, size: 18),
                        label: const Text('Proceed to Checkout',
                            style: AppTextStyles.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label,
          style: AppTextStyles.caption.copyWith(
              fontSize: 11, color: AppColors.textDark)),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 14, color: AppColors.textDark),
      ),
    );
  }
}
