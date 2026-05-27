import 'package:dubai_fashion/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_listing_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/main_shell.dart';
import '../models/product_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Full-screen routes (outside shell so back button works cleanly)
      GoRoute(
        path: '/products',
        builder: (context, state) {
          final category = state.queryParameters['category'] ?? 'All';
          return ProductListingScreen(category: category);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final extraProduct = state.extra;
          if (extraProduct is ProductModel) {
            return ProductDetailScreen(product: extraProduct);
          }

          // Fallback — shouldn't happen with our navigation pattern
          return const Scaffold(
            body: Center(child: Text('Product not found')),
          );
        },
      ),

      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      // Edit profile full-screen route (outside shell)
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}
