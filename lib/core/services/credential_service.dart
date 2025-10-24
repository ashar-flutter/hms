import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hr_flow/core/snackbar/custom_snackbar.dart';
import 'package:iconsax/iconsax.dart';

import 'credential_store_service.dart';

class CredentialService {
  final _auth = FirebaseAuth.instance;
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword
        (email: email, password: password).then((_)async {
        await SecureStorageService.saveLoginState(true);
        await SecureStorageService.saveUid(_auth.currentUser!.uid);
        CustomSnackBar.show(
          title: "Success",
          message: "Login Successful",
          backgroundColor: const Color.fromARGB(255, 0, 122, 255),
          textColor: Colors.black,
          shadowColor: Colors.lightBlueAccent,
          borderColor: Colors.transparent,
          icon: Iconsax.message_tick,
        );
      });
    } catch (e) {
      CustomSnackBar.show(
        title: "Error",
        message: e.toString(),
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
    }
  }

  //  Sign Up Method
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword
        (email: email, password: password).then((_) async{
        await SecureStorageService.saveLoginState(true);
        await SecureStorageService.saveUid(_auth.currentUser!.uid);
        CustomSnackBar.show(
          title: "Success",
          message: "Account Created Successfully",
          backgroundColor: const Color.fromARGB(255, 0, 122, 255),
          textColor: Colors.black,
          shadowColor: Colors.lightBlueAccent,
          borderColor: Colors.transparent,
          icon: Iconsax.message_tick,
        );
      });
    } catch (e) {
      CustomSnackBar.show(
        title: "Error",
        message: e.toString(),
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
    }
  }
}

