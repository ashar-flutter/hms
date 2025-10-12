import 'package:flutter/material.dart';
import 'package:hr_flow/core/services/credential_service.dart';
import 'package:iconsax/iconsax.dart';

import '../snackbar/custom_snackbar.dart';

class CredentialValidation {
  final CredentialService _service = CredentialService();

  // ---------------- SIGN IN VALIDATION ----------------
  bool signInChecks(String email, String password) {
    if (email.isEmpty && password.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Both fields are required",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (email.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Enter your email also",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (password.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Enter your password please",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (!email.contains("@") || !email.endsWith(".com")) {
      CustomSnackBar.show(
        title: "Error",
        message: "Invalid Email Format",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (password.length < 8) {
      CustomSnackBar.show(
        title: "Error",
        message: "Password must be at least 8 characters",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else {
      _service.signIn(email, password);
      return true;
    }
  }

  // ---------------- SIGN UP VALIDATION ----------------
  bool signUpChecks({required String email, required String password}) {
    if (email.isEmpty && password.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Both fields are required",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (email.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Enter your email also",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (password.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "Enter your password please",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (!email.contains("@") || !email.endsWith(".com")) {
      CustomSnackBar.show(
        title: "Error",
        message: "Invalid Email Format",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (password.length < 8) {
      CustomSnackBar.show(
        title: "Error",
        message: "Password must be at least 8 characters",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else {
      _service.signUp(email, password);
      return true;
    }
  }
}
