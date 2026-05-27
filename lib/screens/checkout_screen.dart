import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/address_model.dart';
import '../models/card_model.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'card';
  AddressModel? _selectedAddress;
  CardModel? _selectedCard;
  bool _isSubmitting = false;

  void _showAddressesDialog(List<AddressModel> addresses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Shipping Address', style: AppTextStyles.heading3),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (context, i) {
              final addr = addresses[i];
              return ListTile(
                title: Text(addr.fullName, style: AppTextStyles.body),
                subtitle: Text('${addr.addressLine}, ${addr.city}', style: AppTextStyles.bodyGrey),
                trailing: addr.isDefault
                    ? const Icon(Icons.check_circle, color: AppColors.accent)
                    : null,
                onTap: () {
                  setState(() => _selectedAddress = addr);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCardsDialog(List<CardModel> cards) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Payment Card', style: AppTextStyles.heading3),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cards.length,
            itemBuilder: (context, i) {
              final card = cards[i];
              return ListTile(
                title: Text(card.cardHolderName, style: AppTextStyles.body),
                subtitle: Text(card.maskedNumber, style: AppTextStyles.bodyGrey),
                onTap: () {
                  setState(() => _selectedCard = card);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _completeOrder(
      AuthProvider authProvider, CartProvider cartProvider) async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or add a shipping address'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedPayment == 'card' && _selectedCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or add a payment card'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final uid = authProvider.user!.uid;

      final orderItems = cartProvider.items.map((cartItem) {
        return OrderItem(
          product: cartItem.product,
          selectedSize: cartItem.selectedSize,
          selectedColor: cartItem.selectedColor,
          quantity: cartItem.quantity,
          price: cartItem.product.price,
        );
      }).toList();

      final order = OrderModel(
        id: '', // Firestore will auto-generate
        userId: uid,
        items: orderItems,
        totalPrice: cartProvider.totalPrice,
        address: _selectedAddress!,
        paymentMethod: _selectedPayment == 'card' ? 'Credit Card' : 'Cash on Delivery',
        paymentCardNumber: _selectedPayment == 'card' ? _selectedCard!.maskedNumber : '',
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      await firestore.collection('orders').add(order.toMap());
      
      // Clear Cart
      cartProvider.clearCart();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.md),
                const Icon(Icons.check_circle_outline, size: 72, color: AppColors.success),
                const SizedBox(height: AppSpacing.md),
                const Text('Order Placed!', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Your order has been submitted successfully.',
                  style: AppTextStyles.bodyGrey,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // dismiss dialog
                    context.go('/profile'); // Redirect to profile to see order history!
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('View Order History', style: AppTextStyles.button),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit order: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();

    // Dynamically set default selected values if not set yet
    if (_selectedAddress == null && authProvider.addresses.isNotEmpty) {
      _selectedAddress = authProvider.addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => authProvider.addresses.first,
      );
    }
    if (_selectedCard == null && authProvider.cards.isNotEmpty) {
      _selectedCard = authProvider.cards.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: AppTextStyles.heading2),
        elevation: 0,
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.accent),
                  SizedBox(height: AppSpacing.md),
                  Text('Processing your order...', style: AppTextStyles.bodyGrey),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- SECTION 1: SHIPPING ADDRESS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping Address', style: AppTextStyles.heading3),
                      if (authProvider.addresses.isNotEmpty)
                        TextButton(
                          onPressed: () => _showAddressesDialog(authProvider.addresses),
                          child: const Text('Change', style: TextStyle(color: AppColors.accent)),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (_selectedAddress != null)
                    Card(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_selectedAddress!.fullName, style: AppTextStyles.heading3),
                            const SizedBox(height: 4),
                            Text(_selectedAddress!.addressLine, style: AppTextStyles.body),
                            Text(_selectedAddress!.city, style: AppTextStyles.bodyGrey),
                            Text('Phone: ${_selectedAddress!.phone}', style: AppTextStyles.bodyGrey),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            const Text('No shipping addresses saved.', style: AppTextStyles.bodyGrey),
                            const SizedBox(height: AppSpacing.sm),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.go('/profile');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add a delivery address under your Profile.'),
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text('Add Address', style: AppTextStyles.button),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: AppSpacing.lg),

                  // --- SECTION 2: PAYMENT METHOD ---
                  const Text('Payment Method', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Credit Card', style: AppTextStyles.body),
                          value: 'card',
                          groupValue: _selectedPayment,
                          activeColor: AppColors.accent,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                        ),
                        RadioListTile<String>(
                          title: const Text('Cash on Delivery', style: AppTextStyles.body),
                          value: 'cod',
                          groupValue: _selectedPayment,
                          activeColor: AppColors.accent,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Selected Card Info
                  if (_selectedPayment == 'card') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment Card', style: AppTextStyles.heading3),
                        if (authProvider.cards.isNotEmpty)
                          TextButton(
                            onPressed: () => _showCardsDialog(authProvider.cards),
                            child: const Text('Change', style: TextStyle(color: AppColors.accent)),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_selectedCard != null)
                      Card(
                        color: AppColors.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.credit_card, color: AppColors.primary),
                          title: Text(_selectedCard!.cardHolderName, style: AppTextStyles.body),
                          subtitle: Text(_selectedCard!.maskedNumber, style: AppTextStyles.bodyGrey),
                        ),
                      )
                    else
                      Card(
                        color: AppColors.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            children: [
                              const Text('No payment cards saved.', style: AppTextStyles.bodyGrey),
                              const SizedBox(height: AppSpacing.sm),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.go('/profile');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please add a payment card under your Profile.'),
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text('Add Card', style: AppTextStyles.button),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // --- SECTION 3: ORDER SUMMARY ---
                  const Text('Order Summary', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal', style: AppTextStyles.bodyGrey),
                              Text('Rs.${cartProvider.totalPrice.toStringAsFixed(2)}', style: AppTextStyles.body),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery', style: AppTextStyles.bodyGrey),
                              Text('Free', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: AppTextStyles.heading3),
                              Text(
                                'Rs.${cartProvider.totalPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.priceSmall.copyWith(fontSize: 18, color: AppColors.accentDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // --- SECTION 4: COMPLETE ORDER BUTTON ---
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _completeOrder(authProvider, cartProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Complete Order', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
