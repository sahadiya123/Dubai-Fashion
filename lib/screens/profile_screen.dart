import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import 'orders_screen.dart';
import 'addresses_screen.dart';
import 'payments_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    final name =
        authProvider.name.isNotEmpty ? authProvider.name : 'Guest User';
    final email = user?.email ?? 'No email provided';

    final initials = name
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('My Profile', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Profile Hero ────────────────────────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Name & email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyles.heading2),
                        const SizedBox(height: 2),
                        Text(email, style: AppTextStyles.bodyGrey),
                      ],
                    ),
                  ),
                  // Edit icon
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.edit_outlined,
                          size: 18, color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ─── Account Section ─────────────────────────────────────────────
            _SectionHeader(label: 'My Account'),
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'Order History',
              subtitle: 'Track & view past orders',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen())),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              label: 'Delivery Addresses',
              subtitle: 'Manage shipping addresses',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddressesScreen())),
            ),
            _MenuItem(
              icon: Icons.credit_card_outlined,
              label: 'Payment Cards',
              subtitle: 'Manage saved cards',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PaymentsScreen())),
            ),

            const SizedBox(height: AppSpacing.md),

            // ─── Profile Section ─────────────────────────────────────────────
            _SectionHeader(label: 'Profile'),
            _MenuItem(
              icon: Icons.person_outline,
              label: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ─── Logout ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.signOut();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout_rounded,
                      color: Colors.white, size: 18),
                  label: const Text('Sign Out', style: AppTextStyles.button),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable section header ────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─── Reusable menu item ──────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        title: Text(label, style: AppTextStyles.body),
        subtitle: subtitle != null
            ? Text(subtitle!, style: AppTextStyles.bodyGrey.copyWith(fontSize: 12))
            : null,
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGrey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      ),
    );
  }
}
