import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/card_model.dart';
import '../providers/auth_provider.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _holderNameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _showAddCardSheet(BuildContext context) {
    _holderNameController.clear();
    _cardNumberController.clear();
    _expiryController.clear();
    _cvvController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Payment Card', style: AppTextStyles.heading2),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _holderNameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.trim().isEmpty ? 'Enter cardholder name' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '16-digit card number',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.length < 16 ? 'Enter valid 16-digit number' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) {
                          if (v!.isEmpty || !v.contains('/')) return 'Invalid';
                          return null;
                        },
                        onChanged: (val) {
                          if (val.length == 2 && !_expiryController.text.contains('/')) {
                            _expiryController.text = '$val/';
                            _expiryController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _expiryController.text.length),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v!.length < 3 ? 'Enter CVV' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final card = CardModel(
                        id: '',
                        cardHolderName: _holderNameController.text.trim().toUpperCase(),
                        cardNumber: _cardNumberController.text.trim(),
                        expiryDate: _expiryController.text.trim(),
                        cvv: _cvvController.text.trim(),
                      );
                      context.read<AuthProvider>().addCard(card);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Card', style: AppTextStyles.button),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = context.watch<AuthProvider>().cards;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Cards', style: AppTextStyles.heading3),
        elevation: 0,
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.credit_card_outlined, size: 64, color: AppColors.textGrey),
                  const SizedBox(height: AppSpacing.md),
                  const Text('No cards saved yet', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('Add a card to complete checkouts instantly', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCardSheet(context),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Card', style: AppTextStyles.button),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: cards.length,
              itemBuilder: (context, i) {
                final card = cards[i];
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accentDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('DUBAI FASHION PREMIUM',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                              Icon(
                                card.cardNumber.startsWith('4')
                                    ? Icons.credit_card
                                    : Icons.credit_card,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                          Text(
                            card.maskedNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CARDHOLDER',
                                      style: TextStyle(color: Colors.white54, fontSize: 9)),
                                  const SizedBox(height: 4),
                                  Text(card.cardHolderName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('EXPIRES',
                                      style: TextStyle(color: Colors.white54, fontSize: 9)),
                                  const SizedBox(height: 4),
                                  Text(card.expiryDate,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white24,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                          onPressed: () => context.read<AuthProvider>().deleteCard(card.id),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: cards.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.accent,
              onPressed: () => _showAddCardSheet(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
