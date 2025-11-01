import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/core/colors/app_colors.dart';
import 'package:hr_flow/features/onboarding/main_page.dart';
import 'package:hr_flow/features/profile/profile_page.dart';
import 'package:hr_flow/features/dashboard/main_dashboard.dart';
import '../../core/services/credential_store_service.dart';
import '../admin_dashboard/admin_dashboard.dart';
import '../dashboard/requests/controller/notification_controller.dart';
import '../dashboard/requests/controller/status_controller.dart';

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
    if (!Get.isRegistered<RequestStatusController>()) {
      Get.put(RequestStatusController(), permanent: true);
    }
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController(), permanent: true);
    }

    print('🚀 All controllers initialized');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.6, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 400));
        await _navigateUser();
      }
    });
  }

  Future<void> _navigateUser() async {
    final isLoggedIn = await SecureStorageService.isLoggedIn();
    final isProfileCompleted = await SecureStorageService.isProfileCompleted();
    final userRole = await SecureStorageService.getUserRole();

    debugPrint("isLoggedIn: $isLoggedIn");
    debugPrint("isProfileCompleted: $isProfileCompleted");
    debugPrint("userRole: $userRole");

    if (!isLoggedIn) {
      Get.offAll(
        () => const MainPage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
      return;
    }

    if (isLoggedIn && !isProfileCompleted) {
      Get.offAll(
        () => const ProfilePage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
      return;
    }

    if (isLoggedIn && isProfileCompleted) {
      if (userRole != null && userRole.toLowerCase() == 'admin') {
        Get.offAll(
          () => const AdminDashboard(naame: "", lNaame: ""),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      } else {
        Get.offAll(
          () => const MainDashboard(firstname: '', lastname: ''),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      }
    }
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
