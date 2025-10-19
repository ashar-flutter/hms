import 'package:flutter/material.dart';

class DatePickerHelper {

  static Future<DateTime?> pickFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    return picked;
  }


  static Future<DateTime?> pickToDate(
      BuildContext context, DateTime? fromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );
    return picked;
  }
}
