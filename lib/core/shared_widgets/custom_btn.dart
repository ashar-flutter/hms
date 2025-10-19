import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomBtn({super.key,
    required this.text,
    required this.onPressed});

  static const Color gradientStart =  Color(0xFF0D00B3);
  static const Color gradientEnd = Color(0xFFAA00FF);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 22,
        backgroundColor: Colors.transparent,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withValues(alpha: 0.25);
            }
            return null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        child: Container(
          width: screenWidth * 0.9,
          height: 53,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  text,
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
