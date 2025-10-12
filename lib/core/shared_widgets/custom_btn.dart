import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomBtn({super.key,
    required this.text,
    required this.onPressed});

  static const Color indicatorColor = Color(0xFF5038ED);
  static const Color onBoardBtn = Color(0xFF988AF4);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
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
          width: screenWidth * 0.9,
          height: 50,
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
