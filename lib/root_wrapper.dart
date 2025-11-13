import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/services/auth_check_service.dart';
import '../../features/home/screens/home_screen.dart';
import 'features/splash_screen/screens/splash_screen.dart';

class RootWrapper extends StatelessWidget {
  const RootWrapper({super.key});

  Future<bool> _checkAuth() async {
    final authService = Get.find<AuthenticateCheckService>();
    return await authService.isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        // While checking auth → show blank or logo only
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If logged in → Go directly to Home
        if (snapshot.data == true) {
          return const HomeScreen();
        }

        // If not logged in → Go to SplashScreen
        return const SplashScreen();
      },
    );
  }
}
