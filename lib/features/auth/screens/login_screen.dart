import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/network/socket_client.dart';
import 'package:danielabake/core/utils/debug_print.dart';
import 'package:danielabake/core/utils/gap_helper.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
          Gap(h: 30),
          PrimaryButton(onApiPressed: () => _authCtrl.login(), text: "Login"),
          Gap(h: 30),
          SecondaryButton(
            onApiPressed: () => _authCtrl.register(),
            text: "Resister",
          ),
          Gap(h: 30),
          PrimaryButton(
            onSimplePressed: () {
              DPrint.info("is simple button");
              socketClient.emit("search", {
                'query': "d",
                // 'genre': "genre",
                // 'year': '20',
              });
            },
            text: "next screen",
          ),
        ],
      ),
    );
  }
}
