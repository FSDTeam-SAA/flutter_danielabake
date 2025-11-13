import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmNewPasswordFocus = FocusNode();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  Future _submit () async{
    if (!_formKey.currentState!.validate()) return;
    _authController.createNewPass(widget.email, widget.otp, _newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Create new password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select which contact details should we use to reset your password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),

              const SizedBox(height: 16),

              /// New Password
              ValueListenableBuilder<bool>(
                valueListenable: _obscurePassword,
                builder: (context, obscure, _) {
                  return TextFormField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    cursorColor: Colors.black,
                    obscureText: obscure,
                    textInputAction: TextInputAction.done,
                    decoration: context.primaryInputDecoration().copyWith(
                      hintText: 'New Password',
                    ),
                    validator: Validators.password,
                    autofillHints: const [AutofillHints.password],
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Confirm New Password
              ValueListenableBuilder<bool>(
                valueListenable: _obscurePassword,
                builder: (context, obscure, _) {
                  return TextFormField(
                    controller: _confirmNewPasswordController,
                    focusNode: _confirmNewPasswordFocus,
                    cursorColor: Colors.black,
                    obscureText: obscure,
                    textInputAction: TextInputAction.done,
                    decoration: context.primaryInputDecoration().copyWith(
                      hintText: 'Repeat New Password',
                    ),
                    validator: Validators.password,
                    autofillHints: const [AutofillHints.password],
                  );
                },
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                onApiPressed: () =>
                  _submit()
                ,
                text: 'Continue',
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
