import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';

import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:danielabake/features/auth/screens/forgot_password_screen.dart';
import 'package:danielabake/features/auth/screens/signup_screen.dart';
import 'package:danielabake/features/home/screens/home_screen.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';

import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/remember_me_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,  this.password,  this.email});
  final String? password;
  final String? email;

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
  final rememberMeController = Get.put(RememberMeController());

  final _authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
    _passwordController.text = widget.password ?? '';
  }



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await _authCtrl.login(rememberMeController, email: _emailController.text, password: _passwordController.text);
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
                      Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(h: 30),

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
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
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
                          Obx(
                                () => Checkbox(
                              value:
                              rememberMeController.rememberMe.value,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              //  tick color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: WidgetStateBorderSide.resolveWith((
                                  states,
                                  ) {
                                if (states.contains(
                                  WidgetState.selected,
                                )) {
                                  //  Border when checked
                                  return BorderSide(
                                    color: Color(0xFF1753FF),
                                    width: 2,
                                  );
                                }
                                // Border when unchecked
                                return BorderSide(
                                  color: Color(0xFF1753FF),
                                  width: 1,
                                );
                              }),
                              onChanged: (_) =>
                                  rememberMeController.toggleRememberMe(),
                            ),
                          ),
                          
                          
                          Text("Remember me", style: TextStyle(fontSize: 14)),
                          Spacer(),
                          TextButton(
                            onPressed: () {Get.to(() => ForgotPasswordScreen());},
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
                                  ..onTap = () {
                                    Get.to(
                                      () => (SignUpScreen()),
                                      transition: Transition.rightToLeft,
                                    );
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
