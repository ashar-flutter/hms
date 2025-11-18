import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  bool _controllersRegistered = false;

  @override
  void initState() {
    super.initState();
    // **OPTIMIZATION 2: Sync operations first**
    _registerControllersSync();
    // **OPTIMIZATION 3: Microtask for immediate execution**
    Future.microtask(_navigateUserFast);
  }

  void _registerControllersSync() {
    if (!_controllersRegistered) {
      Get.put(RequestStatusController(), permanent: true);
      Get.put(NotificationController(), permanent: true);
      _controllersRegistered = true;
    }
  }

  Future<void> _navigateUserFast() async {
    try {
      final results = await Future.wait([
        SecureStorageService.isLoggedIn(),
        SecureStorageService.isProfileCompleted(),
        SecureStorageService.getUserRole(),
      ], eagerError: true);

      _navigateBasedOnAuth(
        results[0] as bool,
        results[1] as bool,
        results[2] as String?,
      );
    } catch (e) {
      Get.offAll(() => const MainPage(), transition: Transition.noTransition);
    }
  }

  void _navigateBasedOnAuth(bool isLoggedIn, bool isProfileCompleted, String? userRole) {
    if (!isLoggedIn) {
      Get.offAll(() => const MainPage(), transition: Transition.noTransition);
    } else if (!isProfileCompleted) {
      Get.offAll(() => const ProfilePage(), transition: Transition.noTransition);
    } else if (userRole != null && userRole.toLowerCase() == 'admin') {
      Get.offAll(() => const AdminDashboard(naame: "", lNaame: ""),
          transition: Transition.noTransition);
    } else {
      Get.offAll(() => const MainDashboard(firstname: '', lastname: ''),
          transition: Transition.noTransition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptimizedSplashImage(),
            SizedBox(height: 5),
            Text(
              "LA Digital Agency",
              style: TextStyle(
                fontFamily: "bold",
                color: Color(0xFF121212),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptimizedSplashImage extends StatelessWidget {
  const _OptimizedSplashImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/icon/my_icon.png",
      height: 120,
      width: 120,
      filterQuality: FilterQuality.high,
      cacheWidth: 120,
      cacheHeight: 120,
    );
  }
}