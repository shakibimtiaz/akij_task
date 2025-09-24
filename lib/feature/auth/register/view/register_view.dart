import 'package:akij_task/core/utils/constants/image_path.dart' show ImagePath;
import 'package:akij_task/core/utils/style/get_text_style.dart'
    show getTextStyle;
import 'package:akij_task/core/utils/widgets/custom_button.dart'
    show CustomButton;
import 'package:akij_task/core/utils/widgets/custom_textfield.dart'
    show CustomTextField;
import 'package:akij_task/feature/auth/login/view/login_view.dart';
import 'package:akij_task/feature/auth/register/controller/register_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final RegisterController controller = Get.put(RegisterController());

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
              controller: controller.nameController,
              hintText: 'Enter your name',
            ),
            SizedBox(height: 15),
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
            SizedBox(height: 15),
            CustomTextField(
              controller: controller.confirmPasswordController,
              hintText: 'Confirm your password',
              inObscure: true,
              showVisibilityIcon: true,
            ),
            SizedBox(height: 50),
            CustomButton(
              text: "Register",
              onPressed: () {
                controller.registerUser();
              },
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: getTextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ), // regular text style
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: getTextStyle(fontSize: 16, color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAll(() => LoginView());
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
