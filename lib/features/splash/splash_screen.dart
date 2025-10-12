import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/core/colors/app_colors.dart';
import 'package:hr_flow/features/onboarding/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.6, 0), // right side se aayega
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.offAll(
                () => const MainPage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        });
      }
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
      backgroundColor: AMColors.splashBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Text(
              "LA Digital Agency",
              textAlign: TextAlign.center,
              style: TextStyle(
                 fontFamily: "bold",
                fontWeight: FontWeight.w700,
                color: AMColors.splashText,
                fontSize: 32,
                letterSpacing: 1.4,
              )
            ),
          ),
        ),
      ),
    );
  }
}

