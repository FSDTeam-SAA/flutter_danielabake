import 'package:danielabake/core/theme/app_theme.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:danielabake/features/splash_screen/screens/splash_screen.dart';
import 'package:danielabake/root_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/init/app_initializer.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.light,
      home: RootWrapper(),
    );
  }
}
