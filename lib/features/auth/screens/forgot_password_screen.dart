import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();

  final _authController = Get.find<AuthController>();

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future _submit() async{
    if (!_formKey.currentState!.validate()) return;
    _authController.forgotPass(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Select which contact details should we use to reset your password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
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
                onApiPressed: () => _submit(),
                text: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
