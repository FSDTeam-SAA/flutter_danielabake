import 'dart:async';
import 'package:get/get.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';

class VerifyCodeController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  /// Reactive countdown timer value
  var remainingSeconds = 60.obs;

  /// To control the timer
  Timer? _timer;

  /// Current user email
  final String email;

  VerifyCodeController(this.email);

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  /// Start 43-second countdown
  void startTimer() {
    remainingSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// Resend OTP after countdown
  Future<void> resendCode() async {
    // Here you can call your forgot password or resend OTP function
    await _authController.forgotPass(email);
    startTimer();
  }

  /// Verify the entered OTP
  Future<void> verifyCode(String otp) async {
    await _authController.verifyOTP(email, otp);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
