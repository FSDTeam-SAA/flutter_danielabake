import 'package:get/get.dart';

class RememberMeController extends GetxController {
  // observable boolean
  var rememberMe = false.obs;

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
