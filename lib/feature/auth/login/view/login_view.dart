import 'package:akij_task/core/utils/constants/image_path.dart';
import 'package:akij_task/core/utils/style/get_text_style.dart';
import 'package:akij_task/core/utils/widgets/custom_button.dart';
import 'package:akij_task/core/utils/widgets/custom_textfield.dart';
import 'package:akij_task/feature/auth/login/controller/login_controller.dart';
import 'package:akij_task/feature/auth/register/view/register_view.dart'
    show RegisterView;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(ImagePath.logo, width: 150, height: 150),
            ),
            SizedBox(height: 15),
            Text(
              "Smart Notes &\n Task Manager",
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Enter your email',
            ),
            SizedBox(height: 15),
            CustomTextField(
              controller: controller.passwordController,
              hintText: 'Enter your password',
              inObscure: true,
              showVisibilityIcon: true,
            ),
            SizedBox(height: 50),
            CustomButton(
              text: "Login",
              onPressed: () {
                controller.loginUser();
              },
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: getTextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ), // regular text style
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: getTextStyle(fontSize: 16, color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAll(() => RegisterView());
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
