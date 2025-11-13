import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../controller/verify_code_controller.dart';
import '../widgets/pincode.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _otpVerify = TextEditingController();
  late VerifyCodeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VerifyCodeController(widget.email));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Enter security code',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Please check your Email for a message with your code. Your code is 6 numbers long.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4E4E4E),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),

              // 🔢 Pin Code Field
              PinCode(otpController: _otpVerify),

              const SizedBox(height: 16),

              // ⏳ Countdown Timer
              Center(
                child: Obx(() {
                  if (controller.remainingSeconds.value > 0) {
                    return Text(
                      'Resend code in ${controller.remainingSeconds.value}s',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    );
                  } else {
                    return GestureDetector(
                      onTap: controller.resendCode,
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                }),
              ),

              const SizedBox(height: 30),

              //Verify Button
              PrimaryButton(
                onApiPressed: () => controller.verifyCode(_otpVerify.text),
                text: 'Verify',
                width: double.infinity,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
