import 'package:danielabake/core/network/services/auth_storage_service.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/splash_screen/screens/first_screen.dart';

class RootWrapper extends StatelessWidget {
  RootWrapper({super.key});

  final AuthStorageService _authStorageService = AuthStorageService();

  Future<bool> _checkToken() async {
    final token = await _authStorageService.getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// If refresh token exists → go to navigation menu
        if (snapshot.data == true) {
          return const NavigationMenu();
        }

        /// Otherwise → go to splash screen
        return const FirstScreen();
      },
    );
  }
}
