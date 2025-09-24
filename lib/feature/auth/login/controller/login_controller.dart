import 'package:akij_task/feature/bottom_navbar/view/bottom_navbar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      EasyLoading.showError("Please fill all fields");
      return;
    }

    try {
      EasyLoading.show(status: "Logging in...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      EasyLoading.showSuccess("Login successful");
      Get.offAll(BottomNavbarView());
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message ?? "Login failed");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
      print("The error is for $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
