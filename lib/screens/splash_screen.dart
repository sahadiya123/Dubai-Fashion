// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final List<Timer> _timers = [];
  late AnimationController _sweepCtrl;
  late Animation<double> _sweepAnim;
  late AnimationController _logoCtrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoSlide;
  late AnimationController _textCtrl;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late AnimationController _tagCtrl;
  late Animation<double> _tagFade;
  late AnimationController _shimmerCtrl;

  void _schedule(Duration duration, VoidCallback callback) {
    _timers.add(Timer(duration, callback));
  }

  @override
  void initState() {
    super.initState();

    _sweepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sweepAnim = CurvedAnimation(parent: _sweepCtrl, curve: Curves.easeOut);

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoSlide = Tween<double>(
      begin: 30,
      end: 0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut));

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _textSlide = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _tagCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _tagFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _tagCtrl, curve: Curves.easeIn));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _runSequence();
  }

  void _runSequence() {
    _schedule(const Duration(milliseconds: 250), () {
      _sweepCtrl.forward().then((_) {
        _schedule(const Duration(milliseconds: 80), () {
          _logoCtrl.forward().then((_) {
            _schedule(const Duration(milliseconds: 60), () {
              _textCtrl.forward().then((_) {
                _schedule(const Duration(milliseconds: 100), () {
                  _tagCtrl.forward().then((_) {
                    _schedule(const Duration(milliseconds: 1500), () {
                      if (mounted) {
                        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
                        context.go(isLoggedIn ? '/home' : '/login');
                      }
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    _sweepCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _tagCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned(
            top: -size.width * 0.3,
            right: -size.width * 0.3,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.4,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _logoFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _logoSlide.value),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.accent, AppColors.accentDark],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.35),
                                blurRadius: 30,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.diamond_outlined,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: Listenable.merge([_sweepAnim, _shimmerCtrl]),
                  builder: (_, __) {
                    return ClipRect(
                      child: Align(
                        widthFactor: _sweepAnim.value,
                        alignment: Alignment.centerLeft,
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            final sp = _shimmerCtrl.value;
                            return LinearGradient(
                              colors: const [
                                AppColors.accentDark,
                                AppColors.accent,
                                Colors.white,
                                AppColors.accent,
                                AppColors.accentDark,
                              ],
                              stops: [
                                (sp - 0.4).clamp(0.0, 1.0),
                                (sp - 0.2).clamp(0.0, 1.0),
                                sp.clamp(0.0, 1.0),
                                (sp + 0.2).clamp(0.0, 1.0),
                                (sp + 0.4).clamp(0.0, 1.0),
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            width: 200,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _textFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            'Dubai',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Fashion',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedBuilder(
                  animation: _tagCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _tagFade.value,
                    child: Text(
                      'W H E R E   S T Y L E   E V O L V E S',
                      style: TextStyle(
                        color: AppColors.accent.withOpacity(0.65),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 44,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _tagCtrl,
              builder: (_, __) => Opacity(
                opacity: _tagFade.value,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'FASHION  ·  REDEFINED',
                      style: TextStyle(
                        color: AppColors.textLight.withOpacity(0.3),
                        fontSize: 9,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
