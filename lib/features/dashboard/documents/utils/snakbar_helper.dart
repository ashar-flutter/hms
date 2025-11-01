import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hr_flow/core/snackbar/custom_snackbar.dart';

class SnackbarHelper {
  static void showError(BuildContext context, String message) {
    CustomSnackBar.show(
      title: "Error",
      message: message,
      backgroundColor: Colors.redAccent.shade400,
      textColor: Colors.black,
      shadowColor: Colors.transparent,
      borderColor: Colors.transparent,
      icon: Iconsax.close_square,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    CustomSnackBar.show(
      title: "Success",
      message: message,
      backgroundColor: Colors.greenAccent.shade400,
      textColor: Colors.black,
      shadowColor: Colors.transparent,
      borderColor: Colors.transparent,
      icon: Icons.check_circle,
    );
  }
}
