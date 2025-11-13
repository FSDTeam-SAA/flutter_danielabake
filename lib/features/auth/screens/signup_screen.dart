import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _agreeToTerms = ValueNotifier<bool>(false);

  final _authCtrl = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms.value) {
      Get.snackbar(
        "Terms Required",
        "You must agree to the Terms of Service to sign up.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Pass data to AuthController (you can extend AuthController to handle signup)

    await _authCtrl.register(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Gap(h: 60),
                      const AppLogo(height: 80),
                      Gap(h: 30),
                      Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(h: 30),

                      /// [Text Field] Name
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryBlack,
                        ),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Name",
                        ),
                        validator: Validators.name,
                        autofillHints: const [AutofillHints.name],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_emailFocus),
                      ),
                      Gap.h12,

                      /// [Text Field] Email
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryBlack,
                        ),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Email",
                        ),
                        validator: Validators.email,
                        autofillHints: const [AutofillHints.email],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                      ),
                      Gap.h12,

                      /// [Text Field] Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscurePassword,
                        builder: (context, obscure, _) {
                          return TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: obscure,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              color: AppColors.primaryBlack,
                            ),
                            decoration: context
                                .primaryInputDecoration()
                                .copyWith(
                                  hintText: "Password",
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
                            autofillHints: const [AutofillHints.newPassword],
                            onFieldSubmitted: (_) => _submit(),
                          );
                        },
                      ),
                      Gap.h12,

                      /// [Checkbox] I agree to the Terms of Service
                      ValueListenableBuilder<bool>(
                        valueListenable: _agreeToTerms,
                        builder: (context, agreed, _) {
                          return Row(
                            children: [
                              Checkbox(
                                side: const BorderSide(
                                  color: AppColors.primaryButtonBright,
                                ),
                                value: agreed,
                                onChanged: (value) {
                                  _agreeToTerms.value = value ?? false;
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: const TextStyle(
                                      color: AppColors.primaryBlack,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: const TextStyle(
                                          color: AppColors.primaryButtonBright,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.snackbar(
                                              "Terms",
                                              "Terms of Service opened",
                                            );
                                          },
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const Gap(h: 20),

                      /// [Button] Sign Up
                      PrimaryButton(onApiPressed: _submit, text: "Sign Up"),

                      const Gap(h: 24),

                      /// [Link] Already have an account? Login
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                              color: AppColors.primaryBlack,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: AppColors.primaryButtonBright,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => LoginScreen);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
