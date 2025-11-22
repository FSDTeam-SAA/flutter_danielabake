import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:get/get.dart';
import '../../../../core/network/services/secure_store_services.dart';


class FirstScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _checkStartupFlow() async {
    final secureStore = SecureStoreServices();
    final savedEmail = await secureStore.retrieveData("email");
    final savedPassword = await secureStore.retrieveData("password");

    // final success = await _authController.refreshToken();

    if (savedEmail != null && savedPassword != null) {
      Get.offAll(() => LoginScreen(password: savedPassword, email: savedEmail,));
    }
    else{
      Get.offAll(LoginScreen());
    }
  }
}
