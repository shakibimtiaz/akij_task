import 'dart:async';

import 'package:akij_task/feature/auth/login/view/login_view.dart'
    show LoginView;
import 'package:akij_task/feature/bottom_navbar/view/bottom_navbar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(const Duration(seconds: 3), () {
      User? user = _auth.currentUser;
      if (user != null) {
        // User is signed in, navigate to BottomNavbarView
        Get.offAll(() => BottomNavbarView()); // Assuming you have a named route
        return;
      } else {
        Get.offAll(LoginView());
      }
    });
  }
}
