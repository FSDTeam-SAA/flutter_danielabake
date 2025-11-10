import 'package:danielabake/core/utils/getx_helper.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

void setupControllers() {
  Get.getOrPut(() => AuthController());
}
