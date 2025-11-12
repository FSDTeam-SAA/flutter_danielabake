import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/elevated_button.dart';
import '../widgets/pincode.dart';
import 'create_new_password_screen.dart';


class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _otpVerify = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      appBar: AppBar(
        title: Text('Enter security code', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
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
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Color(0xFF4E4E4E), fontSize: 15),
              ),

              const SizedBox(height: 32),

              // Pin Code Field
              PinCode(otpController: _otpVerify),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Resend code in 43s',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),

              const SizedBox(height: 30),

              // Continue Button
              PrimaryButton(
                onTap: () {
                  Get.to(() => CreateNewPasswordScreen(email: widget.email, otp: _otpVerify.text));
                },
                label: 'Verify',
                width: double.infinity,
                height: 50,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
