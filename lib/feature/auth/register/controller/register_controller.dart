import 'package:akij_task/feature/auth/login/view/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class RegisterController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      EasyLoading.showError("Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      EasyLoading.showError("Passwords do not match");
      return;
    }

    try {
      EasyLoading.show(status: "Registering...");
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      String token = const Uuid().v4();
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'password': password,
        'userID': userId,
        'token': token,
      });

      EasyLoading.showSuccess("Registration successful");
      Get.offAll(LoginView());
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message ?? "Registration failed");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
      print("The error is for $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
