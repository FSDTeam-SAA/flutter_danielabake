import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/core/network/socket_client.dart';

import 'package:danielabake/features/auth/controller/auth_controller.dart';
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
  final _authCtrl = Get.find<AuthController>();
  final socketClient = SocketClient();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          AppLogo(),
          Gap(h: 30),
          PrimaryButton(onApiPressed: () => _authCtrl.login(), text: "Login"),
          Gap(h: 30),

          /// [Text Field] Email
          TextFormField(
            // controller: _emailController,
            // focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 16, color: AppColors.primaryBlack),
            decoration: context.primaryInputDecoration().copyWith(
              hintText: "Email",
            ),
            validator: Validators.email,
            // onFieldSubmitted: (_) =>
            //     FocusScope.of(context).requestFocus(_passwordFocus),
            autofillHints: const [AutofillHints.email],
          ),
          Gap.h12,

          SecondaryButton(
            onApiPressed: () => _authCtrl.register(),
            text: "Resister",
          ),
          Gap(h: 30),

          PrimaryButton(
            onSimplePressed: () {
              DPrint.info("is simple button");
            },
            text: "Next Screen",
          ),
        ],
      ),
    );
  }
}
