// lib/core/common/screens/no_internet_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: AppColors.primaryGray),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryWhite,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.primaryGray),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Optionally, trigger a connectivity check or retry
                Get.back(); // Go back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGray,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 16, color: AppColors.primaryWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
