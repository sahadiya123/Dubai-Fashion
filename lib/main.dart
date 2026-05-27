import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'constants/app_router.dart';
import 'constants/app_constants.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DubaiFashionApp());
}

class DubaiFashionApp extends StatelessWidget {
  const DubaiFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp.router(
        title: 'Dubai Fashion',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accent, // champagne gold
            primary: AppColors.primary,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.textDark),
            titleTextStyle: AppTextStyles.heading3,
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
