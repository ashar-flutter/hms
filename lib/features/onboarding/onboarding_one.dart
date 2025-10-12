import 'package:flutter/material.dart';
class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          SizedBox(height: AppBar().preferredSize.height*1.2,),
          Center(
          child: Image.asset("assets/images/one.png",
          height: MediaQuery.of(context).size.height*0.40,
          width: MediaQuery.of(context).size.width*0.9,
            fit: BoxFit.contain,
          ),
        ),
          SizedBox(height: AppBar().preferredSize.height/3,),
          Align(
            alignment: Alignment.center,
            child: Text("Welcome LA Digital Agency!",
            style: TextStyle(
                fontFamily: "bold",
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600
            )
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Stay connected, track your progress, and",
              style: TextStyle(
                  fontFamily: "poppins",
                  decoration: TextDecoration.none,
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              )
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Text("manage your work life effortlessly.",
              style: TextStyle(
                    fontFamily: "poppins",
                  decoration: TextDecoration.none,
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              )
            ),
          )
      ]),
    );
  }
}
