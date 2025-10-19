import 'package:flutter/material.dart';
class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:[
            SizedBox(height: AppBar().preferredSize.height*1.2,),
            Center(
              child: Image.asset("assets/images/two.png",
                height: MediaQuery.of(context).size.height*0.40,
                width: MediaQuery.of(context).size.width*0.9,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: AppBar().preferredSize.height/3,),
            Align(
              alignment: Alignment.center,
              child: Text("Your Workday, Simplified",
                style: TextStyle(
                    fontFamily: "bold",
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 18,
                )
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("Access tools, updates, and information — all in ",
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
              child: Text("one app",
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
