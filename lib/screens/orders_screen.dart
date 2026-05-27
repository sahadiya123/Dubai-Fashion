import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/order_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order History', style: AppTextStyles.heading3),
        elevation: 0,
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to view order history', style: AppTextStyles.bodyGrey),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textGrey),
                        const SizedBox(height: AppSpacing.md),
                        const Text('No orders placed yet', style: AppTextStyles.heading3),
                        const SizedBox(height: AppSpacing.sm),
                        const Text('Start shopping and fill your bag!', style: AppTextStyles.bodyGrey),
                      ],
                    ),
                  );
                }

                // Sort locally to avoid needing Firestore index setup
                final orders = snapshot.data!.docs
                    .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    final order = orders[i];
                    return OrderCard(order: order);
                  },
                );
              },
            ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return AppColors.success;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final dateStr = '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')} ${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                          style: AppTextStyles.heading3),
                      const SizedBox(height: 4),
                      Text(dateStr, style: AppTextStyles.bodyGrey.copyWith(fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.items.length} items', style: AppTextStyles.bodyGrey),
                  Text(
                    'Rs.${order.totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.priceSmall.copyWith(color: AppColors.accentDark, fontSize: 16),
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const Divider(height: AppSpacing.lg),
                const Text('Items Ordered', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.sm),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, idx) {
                    final item = order.items[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 50,
                                height: 50,
                                color: AppColors.border,
                                child: const Icon(Icons.image_not_supported, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    style: AppTextStyles.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(
                                  'Size: ${item.selectedSize}  |  Color: 0x${item.selectedColor.toRadixString(16).toUpperCase()}',
                                  style: AppTextStyles.bodyGrey.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Rs.${item.price.toStringAsFixed(2)}', style: AppTextStyles.body),
                              Text('Qty: ${item.quantity}', style: AppTextStyles.bodyGrey.copyWith(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: AppSpacing.lg),
                const Text('Shipping Address', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.xs),
                Text(order.address.fullName, style: AppTextStyles.body),
                Text('${order.address.addressLine}, ${order.address.city}', style: AppTextStyles.bodyGrey),
                Text('Phone: ${order.address.phone}', style: AppTextStyles.bodyGrey),
                const Divider(height: AppSpacing.lg),
                const Text('Payment Details', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Method: ${order.paymentMethod}', style: AppTextStyles.body),
                    if (order.paymentCardNumber.isNotEmpty)
                      Text(order.paymentCardNumber, style: AppTextStyles.bodyGrey),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
              Center(
                child: Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
