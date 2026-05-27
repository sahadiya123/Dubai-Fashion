import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/address_model.dart';
import '../providers/auth_provider.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAddAddressSheet(BuildContext context) {
    _fullNameController.clear();
    _addressLineController.clear();
    _cityController.clear();
    _phoneController.clear();
    _isDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
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
                      const Text('Add New Address', style: AppTextStyles.heading2),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Enter full name' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _addressLineController,
                    decoration: InputDecoration(
                      labelText: 'Address Line',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Enter address' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) => v!.trim().isEmpty ? 'Enter city' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) => v!.trim().isEmpty ? 'Enter phone' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CheckboxListTile(
                    title: const Text('Set as default address', style: AppTextStyles.body),
                    value: _isDefault,
                    activeColor: AppColors.accent,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setSheetState(() => _isDefault = v ?? false),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final address = AddressModel(
                          id: '',
                          fullName: _fullNameController.text.trim(),
                          addressLine: _addressLineController.text.trim(),
                          city: _cityController.text.trim(),
                          phone: _phoneController.text.trim(),
                          isDefault: _isDefault,
                        );
                        context.read<AuthProvider>().addAddress(address);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Address', style: AppTextStyles.button),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<AuthProvider>().addresses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Addresses', style: AppTextStyles.heading3),
        elevation: 0,
      ),
      body: addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 64, color: AppColors.textGrey),
                  const SizedBox(height: AppSpacing.md),
                  const Text('No addresses saved yet', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('Add an address to speed up checkout', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAddressSheet(context),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Address', style: AppTextStyles.button),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: addresses.length,
              itemBuilder: (context, i) {
                final addr = addresses[i];
                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: addr.isDefault ? AppColors.accent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(addr.fullName, style: AppTextStyles.heading3),
                            if (addr.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Default',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.accentDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(addr.addressLine, style: AppTextStyles.body),
                        Text(addr.city, style: AppTextStyles.body),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone: ${addr.phone}', style: AppTextStyles.bodyGrey),
                            Row(
                              children: [
                                if (!addr.isDefault)
                                  TextButton(
                                    onPressed: () => context
                                        .read<AuthProvider>()
                                        .addAddress(addr.copyWith(isDefault: true)),
                                    child: const Text('Set Default', style: TextStyle(color: AppColors.accent)),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => context.read<AuthProvider>().deleteAddress(addr.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: addresses.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.accent,
              onPressed: () => _showAddAddressSheet(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
