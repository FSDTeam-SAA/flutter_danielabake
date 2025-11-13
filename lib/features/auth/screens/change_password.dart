import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _obscureCurrent = ValueNotifier<bool>(true);
  final _obscureNew = ValueNotifier<bool>(true);
  final _obscureConfirm = ValueNotifier<bool>(true);

  final _authCtrl = Get.find<AuthController>();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // await _authCtrl.changePassword(
    //   currentPassword: _currentCtrl.text,
    //   newPassword: _newCtrl.text,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C42),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ────── SCROLLABLE FORM ──────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ).copyWith(bottom: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(h: 30),

                    // Current Password
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureCurrent,
                      builder: (_, obscure, __) => TextFormField(
                        controller: _currentCtrl,
                        focusNode: _currentFocus,
                        obscureText: obscure,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryBlack,
                        ),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Current Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.primaryGray,
                            ),
                            onPressed: () => _obscureCurrent.value = !obscure,
                          ),
                        ),
                        validator: Validators.password,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_newFocus),
                      ),
                    ),
                    Gap.h16,

                    // New Password
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureNew,
                      builder: (_, obscure, __) => TextFormField(
                        controller: _newCtrl,
                        focusNode: _newFocus,
                        obscureText: obscure,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryBlack,
                        ),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "New Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.primaryGray,
                            ),
                            onPressed: () => _obscureNew.value = !obscure,
                          ),
                        ),
                        validator: Validators.password,
                        autofillHints: const [AutofillHints.newPassword],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_confirmFocus),
                      ),
                    ),
                    Gap.h16,

                    // Confirm New Password
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirm,
                      builder: (_, obscure, __) => TextFormField(
                        controller: _confirmCtrl,
                        focusNode: _confirmFocus,
                        obscureText: obscure,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryBlack,
                        ),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Confirm New Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.primaryGray,
                            ),
                            onPressed: () => _obscureConfirm.value = !obscure,
                          ),
                        ),
                        validator: (v) =>
                            Validators.confirmPassword(v, _newCtrl.text),
                        autofillHints: const [AutofillHints.newPassword],
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ),

                    Gap(h: 40),
                  ],
                ),
              ),
            ),
          ),

          // ────── FIXED SAVE BUTTON ──────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: PrimaryButton(onApiPressed: _submit, text: "Save"),
          ),
        ],
      ),
    );
  }
}
