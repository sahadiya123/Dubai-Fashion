import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: location == '/home'
            ? 0
            : location == '/cart'
            ? 1
            : 2,
        onDestinationSelected: (i) {
          if (i == 0) context.go('/home');
          if (i == 1) context.go('/cart');
          if (i == 2) context.go('/profile');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
