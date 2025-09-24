import 'package:akij_task/core/utils/widgets/custom_button.dart';
import 'package:akij_task/feature/auth/login/view/login_view.dart';
import 'package:akij_task/feature/profile/controller/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // Fetch profile when screen opens
    controller.fetchUserProfile();

    return Scaffold(
      appBar: AppBar(title: Text("My Profile"), centerTitle: true),
      body: Obx(() {
        if (controller.email.value.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email: ${controller.email.value}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Name: ${controller.name.value}",
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              CustomButton(
                text: "Logout",
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  // Navigate to Login screen
                  Get.offAll(LoginView());
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
