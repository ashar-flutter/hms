import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../snackbar/custom_snackbar.dart';

class ProfileValidation {
  Future<bool> validation({
    required BuildContext context,
    required String name,
    required String lastName,
    required String role,
  }) async {
    if (name.isEmpty && lastName.isEmpty  && role.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "please fill all fields to proceed",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (name.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "please enter your first name",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (lastName.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "please enter your last name",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    } else if (role.isEmpty) {
      CustomSnackBar.show(
        title: "Error",
        message: "please select your role",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return false;
    }
    return true;
  }
}
