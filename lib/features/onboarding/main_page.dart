import 'package:flutter/material.dart';
import 'package:hr_flow/core/colors/app_colors.dart';
import 'package:hr_flow/features/auth/pages/login_page.dart';
import 'package:hr_flow/features/onboarding/onboarding_one.dart';
import 'package:hr_flow/features/onboarding/onboarding_three.dart';
import 'package:hr_flow/features/onboarding/onboarding_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/shared_widgets/onBoard_btn.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Widget> pages = const [
    OnboardingOne(),
    OnboardingTwo(),
    OnboardingThree(),
  ];

  void _nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return child!;
                    },
                    child: pages[index],
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: pages.length,
              effect: WormEffect(
                activeDotColor: AMColors.indicatorColor,
                dotColor: Colors.grey.shade600,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
                type: WormType.thinUnderground,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: OnboardBtn(
                onPressed: _nextPage,
                isLastPage: currentIndex == pages.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
