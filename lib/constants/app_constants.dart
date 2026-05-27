// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

// ─── Colours ────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0E0E10); // near-black
  static const Color accent = Color(0xFFC9A96E); // champagne gold
  static const Color accentLight = Color(0xFFE8D5B0); // light gold
  static const Color accentDark = Color(0xFF9A7A45); // deep gold
  static const Color background = Color(0xFFF7F4EF); // warm cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0E0E10);
  static const Color textGrey = Color(0xFF888883);
  static const Color textLight = Color(0xFFF7F4EF);
  static const Color border = Color(0xFFECE8E1);
  static const Color success = Color(0xFF4A9B7F);
  static const Color star = Color(0xFFC9A96E);
}

// ─── Text Styles ────────────────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.5,
  );
  static const TextStyle bodyGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
    height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
}

// ─── Spacing ────────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ─── Border Radius ──────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 20.0;
  static const double xl = 30.0;
  static const double full = 100.0;
}

// ─── Dummy Data ─────────────────────────────────────────────────────────────
class AppDummyData {
  AppDummyData._();

  static const List<Map<String, dynamic>> categories = const [
    const {'name': 'Women', 'icon': '👗', 'color': 0xFFFFE4E8},
    const {'name': 'Men', 'icon': '👔', 'color': 0xFFE4EDFF},
    const {'name': 'Kids', 'icon': '🧒', 'color': 0xFFE8FFE4},
    const {'name': 'Footwear', 'icon': '👟', 'color': 0xFFFFF4E4},
    const {'name': 'Bags', 'icon': '👜', 'color': 0xFFF4E4FF},
    const {'name': 'Watches', 'icon': '⌚', 'color': 0xFFE4FFFD},
    const {'name': 'Jewelry', 'icon': '👑', 'color': 0xFFE4FFFD},
  ];

  static const List<Map<String, dynamic>> banners = const [
    const {
      'title': 'New Season Drop',
      'subtitle': 'Up to 30% off',
      'image':
          'https://images.unsplash.com/photo-1758520388397-bf53b6e11bba?q=80&w=1032&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'color': 0xFF0E0E10,
    },
    const {
      'title': 'Dubai Fashion Picks',
      'subtitle': 'Curated just for you',
      'image':
          'https://images.unsplash.com/photo-1522684462852-01b24e76b77d?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'color': 0xFF9A7A45,
    },
    const {
      'title': 'Accessories',
      'subtitle': 'Complete the look',
      'image':
          'https://plus.unsplash.com/premium_photo-1681276170683-706111cf496e?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'color': 0xFF2D4A22,
    },
  ];

  static const List<Map<String, dynamic>> products = const [
    const {
      'id': '1',
      'name': 'Linen midi dress',
      'brand': 'Zara',
      'price': 4500,
      'oldPrice': 6650,
      'rating': 4.5,
      'reviews': 234,
      'category': 'Women',
      'image':
          'https://images.unsplash.com/photo-1746730921745-5f6afa4c56c3?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://plus.unsplash.com/premium_photo-1673481601147-ee95199d3896?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1659297949927-06fa02629af0?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['XS', 'S', 'M', 'L', 'XL'],
      'colors': const [0xFFFF6B9D, 0xFF4ECDC4, 0xFFFFE66D],
      'description':
          'Breathable linen dress with a sleek midi fit—comfortable, light, and effortlessly stylish.',
      'isFeatured': true,
    },
    const {
      'id': '2',
      'name': 'T-Shirt',
      'brand': 'HUGO BOSS',
      'price': 5250,
      'oldPrice': 8250,
      'rating': 4.2,
      'reviews': 89,
      'category': 'Men',
      'image':
          'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://plus.unsplash.com/premium_photo-1673356302067-aac3b545a362?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1562157873-818bc0726f68?q=80&w=327&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['30', '32', '34', '36', '38'],
      'colors': const [0xFF8B6914, 0xFF2C3E50, 0xFF7F8C8D],
      'description':
          'Chic and trendy shirt dress with a flattering fit and button details. Easy to style—pair with sneakers for a casual look or heels for a polished vibe..',
      'isFeatured': true,
    },
    const {
      'id': '3',
      'name': 'Footwear',
      'brand': 'Nike',
      'price': 19000,
      'oldPrice': 20000,
      'rating': 4.2,
      'reviews': 254,
      'category': 'Footwear',
      'image':
          'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?q=80&w=465&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['38', '39', '40', '41', '42', '43', '44'],
      'colors': const [0xFFFFFFFF, 0xFF1A1A2E, 0xFFE94560],
      'description':
          'A sleek and elegant pair of footwear crafted for a refined look. Offers all-day comfort while enhancing your overall style.',
      'isFeatured': false,
    },
    const {
      'id': '4',
      'name': 'Jewellery',
      'brand': 'Everest gold',
      'price': 50567,
      'oldPrice': 60000,
      'rating': 4.5,
      'reviews': 67,
      'category': 'Accessories',
      'image':
          'https://images.unsplash.com/photo-1721807644561-9efcabee5c42?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://plus.unsplash.com/premium_photo-1724762183134-c17cf5f5bed2?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['One Size'],
      'colors': const [0xFF8B4513, 0xFF1A1A2E, 0xFFBEBEBE],
      'description':
          'Exquisitely designed jewelry featuring fine craftsmanship and a luxurious finish. Made to elevate your style with elegance, grace, and lasting shine.',
      'isFeatured': true,
    },
    const {
      'id': '5',
      'name': 'Kids Denim Jacket',
      'brand': 'Signature',
      'price': 3440,
      'oldPrice': 9200,
      'rating': 4.3,
      'reviews': 63,
      'category': 'Kids',
      'image':
          'https://plus.unsplash.com/premium_photo-1707816508645-d229ddd3aa65?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8S2lkcyUyMERlbmltJTIwSmFja2V0fGVufDB8fDB8fHww',
      'images': const [
        'https://plus.unsplash.com/premium_photo-1682097397868-8702f82ce65e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEtpZHMlMjBEZW5pbSUyMEphY2tldHxlbnwwfHwwfHx8MA%3D%3D',
      ],
      'sizes': const ['3Y', '4Y', '5Y', '6Y', '7Y', '8Y'],
      'colors': const [0xFF4A90D9, 0xFF2C3E50],
      'description':
          'A trendy kids denim jacket made with soft, high-quality fabric for all-day comfort. Perfect for casual outings, it adds a cool and fashionable look to any outfit..',
      'isFeatured': false,
    },
    const {
      'id': '6',
      'name': 'Bags',
      'brand': 'Loewe',
      'price': 1540,
      'oldPrice': 2900,
      'rating': 4.3,
      'reviews': 431,
      'category': 'Bags',
      'image':
          'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?q=80&w=457&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://images.unsplash.com/photo-1597633125184-9fd7e54f0ff7?q=80&w=435&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['small', 'medium', 'large'],
      'colors': const [0xFF4A90D9, 0xFF2C3E50],
      'description':
          'A trendy kids denim jacket made with soft, high-quality fabric for all-day comfort. Perfect for casual outings, it adds a cool and fashionable look to any outfit..',
      'isFeatured': false,
    },
    const {
      'id': '7',
      'name': 'Classic Watch',
      'brand': 'Fossil',
      'price': 16200,
      'oldPrice': 24500,
      'rating': 4.7,
      'reviews': 1121,
      'category': 'Watches',
      'image':
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?q=80&w=388&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'images': const [
        'https://plus.unsplash.com/premium_photo-1728759436968-db4b52249ffa?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['One Size'],
      'colors': const [0xFFD4AF37, 0xFFBEBEBE, 0xFF1A1A2E],
      'description':
          'Timeless classic watch with genuine leather strap. Water resistant up to 50m. Quartz movement for accuracy.',
      'isFeatured': true,
    },
    const {
      'id': '8',
      'name': 'Glow Serum',
      'brand': 'The Ordinary',
      'price': 1999,
      'oldPrice': 2500,
      'rating': 4.6,
      'reviews': 892,
      'category': 'Beauty',
      'image':
          'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?w=600&auto=format&fit=crop&q=60',
      'images': const [
        'https://images.unsplash.com/photo-1642162225900-8d4e658252c9?q=80&w=327&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      'sizes': const ['30ml', '50ml', '100ml'],
      'colors': const [0xFFFADADD, 0xFFFFE4E1],
      'description':
          'A lightweight glow serum enriched with vitamins and natural extracts to brighten and hydrate your skin. Suitable for all skin types and perfect for daily use.',
      'isFeatured': false,
    },
    const {
      'id': '9',
      'name': 'Casual Cotton Shirt',
      'brand': 'Zara',
      'price': 4999,
      'oldPrice': 6000,
      'rating': 4.4,
      'reviews': 520,
      'category': 'Shirts',
      'image':
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=600&auto=format&fit=crop&q=60',
      'images': const [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=60',
      ],
      'sizes': const ['S', 'M', 'L', 'XL'],
      'colors': const [0xFF2196F3, 0xFF000000, 0xFFFFFFFF],
      'description':
          'A stylish casual cotton shirt made from breathable fabric for all-day comfort. Perfect for both casual and semi-formal occasions, giving a clean and modern look.',
      'isFeatured': false,
    },
    const {
      'id': '10',
      'name': 'Hydrating Face Cream',
      'brand': 'Nivea',
      'price': 2050,
      'oldPrice': 3000,
      'rating': 4.5,
      'reviews': 760,
      'category': 'Beauty',
      'image':
          'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=600&auto=format&fit=crop&q=60',
      'images': const [
        'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?w=600&auto=format&fit=crop&q=60',
      ],
      'sizes': const ['50ml', '100ml', '200ml'],
      'colors': const [0xFFE3F2FD, 0xFFFFFFFF],
      'description':
          'A deeply hydrating face cream enriched with vitamins and natural ingredients to keep your skin soft, smooth, and moisturized طوال the day. Suitable for all skin types.',
      'isFeatured': false,
    },
    const {
      'id': '11',
      'name': 'Floral Essence Perfume',
      'brand': 'Chanel',
      'price': 2750,
      'oldPrice': 3500,
      'rating': 4.8,
      'reviews': 2100,
      'category': 'Perfume',
      'image':
          'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=600',
      'images': const [
        'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=600',
      ],
      'sizes': const ['30ml', '50ml', '100ml'],
      'colors': const [0xFFFFC0CB],
      'description':
          'A soft floral fragrance with long-lasting freshness, perfect for daily wear.',
      'isFeatured': true,
    },
  ];
}
