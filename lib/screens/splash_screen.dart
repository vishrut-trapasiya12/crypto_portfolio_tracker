import 'dart:async';

import 'package:crypto_portfolio/screens/portfolio_screen.dart';
import 'package:crypto_portfolio/theme/app_colors.dart';
import 'package:crypto_portfolio/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Timer(const Duration(milliseconds: 2500), () {
      Get.off(() => PortfolioScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _animation,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pie_chart, size: 84, color: Colors.white),
              SizedBox(height: 16),
              AppText(
                text: 'Crypto Portfolio',
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              AppText(
                text: 'Track your crypto holdings',
                color: Colors.white70,
                fontSize: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
