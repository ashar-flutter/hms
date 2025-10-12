import 'package:flutter/material.dart';

class OnboardBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLastPage;
  const OnboardBtn({
    super.key,
    required this.onPressed,
    required this.isLastPage,
  });

  static const Color indicatorColor = Color(0xFF5038ED);
  static const Color onBoardBtn = Color(0xFF988AF4);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [indicatorColor, onBoardBtn],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        child: Container(
          width: screenWidth * 0.8,
          height: 55,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLastPage ? 'Get Started' : 'Next',
                style:TextStyle(
                  fontFamily: "bold",
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                )
              ),
              const SizedBox(width: 8),
              Icon(
                isLastPage
                    ? Icons.arrow_circle_right_rounded
                    : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

