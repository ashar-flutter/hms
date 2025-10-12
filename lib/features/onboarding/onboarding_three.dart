import 'package:flutter/material.dart';


class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: AppBar().preferredSize.height * 1.2),
          Center(
            child: Image.asset(
              "assets/images/three.png",
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppBar().preferredSize.height / 3),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Your Digital Workplace",
              style: TextStyle(
                fontFamily: "bold",
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "One app to handle leaves, documents",
              style: TextStyle(
                fontFamily: "poppins",
                decoration: TextDecoration.none,
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Text(
              "payslips, and more.",
              style:TextStyle(
                fontFamily: "poppins",
                decoration: TextDecoration.none,
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )
            ),
          ),
        ],
      ),
    );
  }
}
