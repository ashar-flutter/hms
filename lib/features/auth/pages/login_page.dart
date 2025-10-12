import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hr_flow/core/colors/app_colors.dart';
import 'package:hr_flow/core/shared_widgets/custom_btn.dart';
import 'package:hr_flow/core/shared_widgets/custom_field.dart';
import 'package:hr_flow/core/utils/credential_validation.dart';
import 'package:hr_flow/features/auth/pages/forget_password_page.dart';
import 'package:hr_flow/features/auth/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final validation = CredentialValidation();
  final emailCnt = TextEditingController();
  final passwordCnt = TextEditingController();

  @override
  void dispose() {
    emailCnt.dispose();
    passwordCnt.dispose();
    super.dispose();
  }

  Future<void> _attemptSignIn() async {
    bool isValid = validation.signInChecks(emailCnt.text, passwordCnt.text);
    if (!isValid) return;
    try {
      final user = await FirebaseAuth.instance.authStateChanges().firstWhere(
        (u) => u != null,
        orElse: () => null,
      );
      if (user != null) {
        emailCnt.clear();
        passwordCnt.clear();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppBar().preferredSize.height * 2),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Login Account",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(
                  "Please login with registered account",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: AppBar().preferredSize.height / 2),
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 4),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomField(
                controller: emailCnt,
                hintText: "Enter your email",
                prefix: Icon(
                  Iconsax.sms,
                  color: Colors.deepPurple.shade700,
                  size: 26,
                ),
                isPassword: false,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 4, top: 10),
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomField(
                controller: passwordCnt,
                hintText: "Enter your password",
                prefix: Icon(
                  Iconsax.lock,
                  color: Colors.deepPurple.shade700,
                  size: 26,
                ),
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(ForgetPasswordPage());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: 15,
                        color: Colors.blueGrey[900],
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppBar().preferredSize.height / 4),
              Align(
                alignment: Alignment.center,
                child: CustomBtn(text: "Login", onPressed: _attemptSignIn),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(SignUpPage());
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: 17,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
