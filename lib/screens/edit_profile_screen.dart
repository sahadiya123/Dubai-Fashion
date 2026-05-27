import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final uid = auth.user?.uid;
      if (uid == null) return;

      final newName = _nameController.text.trim();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
      });

      // Reload user data so the provider reflects the change
      await auth.loadUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.user?.email ?? '';
    final initials = auth.name.isNotEmpty
        ? auth.name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile', style: AppTextStyles.heading3),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.accent),
                  )
                : const Text('Save',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Avatar Hero ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(auth.name.isNotEmpty ? auth.name : 'Your Name',
                      style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(email, style: AppTextStyles.bodyGrey),
                ],
              ),
            ),

            // ─── Form ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionHeader(title: 'Personal Information'),
                    const SizedBox(height: AppSpacing.md),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon:
                            const Icon(Icons.person_outline, color: AppColors.accent),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 1.5),
                        ),
                      ),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Name cannot be empty' : null,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Email (read only)
                    TextFormField(
                      initialValue: email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon:
                            const Icon(Icons.email_outlined, color: AppColors.textGrey),
                        filled: true,
                        fillColor:
                            AppColors.surface.withValues(alpha: 0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        suffixIcon: const Icon(Icons.lock_outline,
                            size: 16, color: AppColors.textGrey),
                        helperText: 'Email cannot be changed here',
                        helperStyle:
                            const TextStyle(color: AppColors.textGrey, fontSize: 11),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Save button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _save,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.check_rounded,
                                color: Colors.white),
                        label: Text(
                            _isLoading ? 'Saving...' : 'Save Changes',
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
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            )),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.heading3),
      ],
    );
  }
}
