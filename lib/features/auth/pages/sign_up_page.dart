import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hr_flow/core/shared_widgets/custom_btn.dart';
import 'package:hr_flow/core/shared_widgets/custom_field.dart';
import 'package:hr_flow/core/utils/credential_validation.dart';
import 'package:hr_flow/features/auth/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_flow/features/profile/profile_page.dart';
import 'package:iconsax/iconsax.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final auth = CredentialValidation();
  final emailCtr = TextEditingController();
  final passCtr = TextEditingController();

  @override
  void dispose() {
    emailCtr.dispose();
    passCtr.dispose();
    super.dispose();
  }

  Future<void> _attemptSignUp() async {
    bool isValid = auth.signUpChecks(
      email: emailCtr.text,
      password: passCtr.text,
    );
    if (!isValid) return;
    try {
      final user = await FirebaseAuth.instance.authStateChanges().firstWhere(
        (u) => u != null,
        orElse: () => null,
      );
      if (user != null) {
        Get.offAll(() => ProfilePage());
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
                  "Create Account!",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(
                  "create your account to get started",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
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
                    color: Colors.grey.shade800,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomField(
                controller: emailCtr,
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
                    color: Colors.grey.shade800,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomField(
                controller: passCtr,
                hintText: "Enter your password",
                prefix: Icon(
                  Iconsax.lock,
                  color: Colors.deepPurple.shade700,
                  size: 26,
                ),
                isPassword: true,
              ),
              SizedBox(height: AppBar().preferredSize.height / 4),
              Align(
                alignment: Alignment.center,
                child: CustomBtn(text: "SignUp", onPressed: _attemptSignUp),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.grey.withValues(alpha: 0.3),
                    highlightColor: Colors.grey.withValues(alpha: 0.1),
                    onTap: () {
                      Get.to(LoginPage());
                    },
                    child: Text(
                      "Login",
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
