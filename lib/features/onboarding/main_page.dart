import 'package:flutter/material.dart';
import 'package:hr_flow/core/colors/app_colors.dart';
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingThree()),
      );
    }
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
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AMColors.indicatorColor,
                dotColor: Colors.grey.shade700,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 4,
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

