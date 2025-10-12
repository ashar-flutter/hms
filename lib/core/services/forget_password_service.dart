import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../snackbar/custom_snackbar.dart';
class ForgetPasswordService {
  final _auth = FirebaseAuth.instance;

  Future<void> forgetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((_){
      CustomSnackBar.show(
        title: "Success",
        message: "Link sent to $email",
        backgroundColor: const Color.fromARGB(255, 0, 122, 255),
        textColor: Colors.black,
        shadowColor: Colors.lightBlueAccent,
        borderColor: Colors.transparent,
        icon: Iconsax.message_tick,
      );
    });

  }
}
