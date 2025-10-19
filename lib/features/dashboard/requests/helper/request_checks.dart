import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/snackbar/custom_snackbar.dart';

class ValidationHelper {
  static bool validateForm({
    required String selectedOption,
    required DateTime? fromDate,
    required DateTime? toDate,
    required String description,
    required dynamic file,
  }) {
    if (selectedOption.isEmpty) {
      _showError("Please select leave type");
      return false;
    }

    if (fromDate == null) {
      _showError("Please select From Date");
      return false;
    }

    if (toDate == null) {
      _showError("Please select To Date");
      return false;
    }

    if (description.isEmpty) {
      _showError("Please enter description");
      return false;
    }

    if (file == null) {
      _showError("Please attach a file");
      return false;
    }

    return true;
  }

  static void _showError(String message) {
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
}
