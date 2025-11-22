import 'dart:math';
import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:danielabake/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/elevated_button.dart'
    show PrimaryButton, SecondaryButton;
import '../../../core/network/services/secure_store_services.dart';
import '../controller/first_screen_controller.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FirstScreenController()); // Initialize the controller

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Image.asset(Images.background),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 160,
                    child: AppLogo(),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.32,
              left: -70,
              child: _buildDiamondImage(Images.cookie1, 160),
            ),
            Positioned(
              top: size.height * 0.38,
              left: 120,
              child: _buildDiamondImage(Images.cookie2, 199),
            ),
            Positioned(
              top: size.height * 0.32,
              right: -70,
              child: _buildDiamondImage(Images.cookie3, 160),
            ),

            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: PrimaryButton(
                onTap: () => Get.to(() => SignUpScreen()),
                label: 'Create Account',
                width: double.infinity,
                height: 50,
              ),
            ),
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: SecondaryButton(
                onTap: () async {
                  final secureStore = SecureStoreServices();
                  final savedEmail = await secureStore.retrieveData("email");
                  final savedPassword = await secureStore.retrieveData("password");

                  Get.to(() => LoginScreen(
                    email: savedEmail,
                    password: savedPassword,
                  ));
                },
                label: 'Login',
                width: double.infinity,
                height: 50,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDiamondImage(String imagePath, double size) {
    return Transform.rotate(
      angle: pi / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
