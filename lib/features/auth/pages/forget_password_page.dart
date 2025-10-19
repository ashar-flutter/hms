import 'package:flutter/material.dart';
import 'package:hr_flow/core/services/forget_password_service.dart';
import 'package:hr_flow/core/shared_widgets/custom_btn.dart';
import 'package:hr_flow/core/shared_widgets/custom_field.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/snackbar/custom_snackbar.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final service = ForgetPasswordService();
  final mailCtr = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
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
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(
                  "Please enter your email",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
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
                controller: mailCtr,
                hintText: "Enter your email",
                prefix: Icon(
                  Iconsax.sms,
                  color: Colors.deepPurple.shade700,
                  size: 26,
                ),
                isPassword: false,
              ),
              SizedBox(height: AppBar().preferredSize.height / 4),
              Align(
                alignment: Alignment.center,
                child: CustomBtn(
                  text: "Send Link",
                  onPressed: () async {
                    final email = mailCtr.text.trim();

                    if (email.isEmpty) {
                      CustomSnackBar.show(
                        title: "Error",
                        message: "please enter your email",
                        backgroundColor: Colors.redAccent.shade400,
                        textColor: Colors.black,
                        shadowColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        icon: Icons.error,
                      );
                    } else if (!email.contains('@') ||
                        !email.contains('.com')) {
                      CustomSnackBar.show(
                        title: "Error",
                        message: "Invalid email!",
                        backgroundColor: Colors.redAccent.shade400,
                        textColor: Colors.black,
                        shadowColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        icon: Icons.error,
                      );
                    } else if (_isValidEmail(email)) {
                      await service.forgetPassword(email);
                      Future.delayed(const Duration(seconds: 2), () {
                        mailCtr.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
