import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/theme/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });


  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmNewPasswordFocus = FocusNode();
  final FocusNode _currentPassFocus = FocusNode();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _profileController = Get.find<ProfileController>();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  Future _submit () async{
    if (!_formKey.currentState!.validate()) return;
    _profileController.changePassword(_currentPasswordController.text, _confirmNewPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Create new password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('Current Password'),
              SizedBox(height: 8,),
              /// New Password
              ValueListenableBuilder<bool>(
                valueListenable: _obscurePassword,
                builder: (context, obscure, _) {
                  return TextFormField(
                    controller: _currentPasswordController,
                    focusNode: _currentPassFocus,
                    cursorColor: Colors.black,
                    obscureText: obscure,
                    textInputAction: TextInputAction.next,

                    decoration: context
                        .primaryInputDecoration()
                        .copyWith(
                      hintText: "Current Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryGray,
                        ),
                        onPressed: () =>
                        _obscurePassword.value = !obscure,
                      ),
                    ),
                    validator: Validators.password,
                    autofillHints: const [AutofillHints.password],
                  );
                },
              ),

              const SizedBox(height: 16),

              Text('New Password'),
              SizedBox(height: 8,),
              /// Confirm New Password
              ValueListenableBuilder<bool>(
                valueListenable: _obscurePassword,
                builder: (context, obscure, _) {
                  return TextFormField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    cursorColor: Colors.black,
                    obscureText: obscure,
                    textInputAction: TextInputAction.done,
                    decoration: context
                        .primaryInputDecoration()
                        .copyWith(
                      hintText: "New Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryGray,
                        ),
                        onPressed: () =>
                        _obscurePassword.value = !obscure,
                      ),
                    ),
                    validator: Validators.password,
                    autofillHints: const [AutofillHints.password],
                  );
                },
              ),

              const SizedBox(height: 16),

              Text('Confirm New Password'),
              SizedBox(height: 8,),
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
                    decoration: context
                        .primaryInputDecoration()
                        .copyWith(
                      hintText: "Confirm New Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryGray,
                        ),
                        onPressed: () =>
                        _obscurePassword.value = !obscure,
                      ),
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
