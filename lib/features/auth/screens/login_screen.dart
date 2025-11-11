import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/core/network/socket_client.dart';

import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';

import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _rememberMe = ValueNotifier<bool>(false);

  final _authCtrl = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await _authCtrl.login();
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
                constraints: BoxConstraints(maxWidth: 600, minWidth: 300),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(h: 60),
                      AppLogo(height: 80),

                      Gap(h: 30),

                      /// [Text Field] Email
                      TextFormField(
                        // controller: _emailController,
                        // focusNode: _emailFocus,
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
                        // onFieldSubmitted: (_) =>
                        //     FocusScope.of(context).requestFocus(_passwordFocus),
                        autofillHints: const [AutofillHints.email],
                      ),
                      Gap.h12,

                      /// [Text field] Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscurePassword,
                        builder: (context, obscure, _) {
                          return TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: obscure,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: AppColors.primaryBlack),
                            decoration: context
                                .primaryInputDecoration()
                                .copyWith(
                                  hintText: "Enter your Password",
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

                            // validator: Validators.password,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _submit(),
                          );
                        },
                      ),
                      Gap.h12,
                      Row(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _rememberMe,
                            builder: (context, remember, _) {
                              return Checkbox(
                                side: BorderSide(
                                  color: AppColors.primaryButtonBright,
                                ),
                                value: remember,
                                onChanged: (value) {
                                  _rememberMe.value = value ?? false;
                                },
                              );
                            },
                          ),
                          Text("Remember me", style: TextStyle(fontSize: 14)),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: AppColors.primaryButtonBright,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      PrimaryButton(
                        onApiPressed: () => _submit(),
                        text: "Login",
                      ),

                      Gap(h: 24),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Don’t have an account? ',
                            style: TextStyle(color: AppColors.primaryBlack),
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: AppColors.primaryButtonBright,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
