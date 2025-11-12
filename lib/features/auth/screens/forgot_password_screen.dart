import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/auth/screens/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/elevated_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();

  //final _authController = Get.find<AuthController>();


  final TextEditingController _emailController = TextEditingController();


  // void _submit(){
  //   _authController.resetPass(_emailController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text('Forgot Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),)),
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text('Select which contact details should we use to reset your password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              cursorColor: Colors.black,
              keyboardType: TextInputType.emailAddress,
              decoration: context.primaryInputDecoration().copyWith(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
              ),
              validator: Validators.email,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              onTap: () {
                Get.to(()=>VerifyCodeScreen(email: _emailController.value.text));
              },
              label: 'Continue',
              width: double.infinity,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
