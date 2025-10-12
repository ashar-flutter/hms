import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Color shadowColor,
    required Color borderColor,
    required IconData icon,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(milliseconds: 900),
  }) {
    Get.rawSnackbar(
      snackPosition: position,
      borderRadius: 20,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      snackStyle: SnackStyle.FLOATING,
      duration: duration,
      messageText: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12),
                  child: Icon(icon, color: textColor, size: 26),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: "poppins",
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
