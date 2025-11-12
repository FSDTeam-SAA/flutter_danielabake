import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/elevated_button.dart';
import '../widgets/pincode.dart';

class OtpVerificationToCompleteRegister extends StatefulWidget {
  const OtpVerificationToCompleteRegister({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationToCompleteRegister> createState() =>
      _OtpVerificationToCompleteRegisterState();
}

class _OtpVerificationToCompleteRegisterState
    extends State<OtpVerificationToCompleteRegister> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 51),

              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Enter your received OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 32),

              PinCode(otpController: otpController),

              SizedBox(height: 24),

              PrimaryButton(
                onTap: () {
                 Get.to(() => LoginScreen());
                },
                label: 'Verify OTP',
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
