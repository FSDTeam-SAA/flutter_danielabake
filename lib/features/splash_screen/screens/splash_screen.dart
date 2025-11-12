import 'dart:math';
import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:danielabake/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/common/constants/app_images.dart';
import '../../../core/common/widgets/elevated_button.dart' show PrimaryButton, SecondaryButton;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            //Background subtle pattern (optional)
            // Positioned.fill(
            //   child: Opacity(
            //     opacity: 0.05,
            //     child: Image.asset(
            //       AppImages.appLogo, // optional repeating bread bg
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
            //Center Images (diamond style)
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
                onTap: () {Get.to(SignUpScreen());},
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
                onTap: () {Get.to(() => LoginScreen());},
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

  // Helper Widget to make images diamond-shaped
  Widget _buildDiamondImage(String imagePath, double size) {
    return Transform.rotate(
      angle: pi / 4, // rotate the container (square rotated)
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: size,
          height: size,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // image fills the square
          ),
        ),
      ),
    );
  }
}
