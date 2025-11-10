import 'package:danielabake/core/base/base_controller.dart';
import 'package:danielabake/core/utils/debug_print.dart';
import 'package:danielabake/features/auth/models/request/login_request_model.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends BaseController {
  final _authRepo = Get.find<AuthRepository>();

  Future<void> login() async {
    final request = LoginRequestModel(
      email: "admin12@gmail.com",
      password: "1234567",
    );

    final response = await _authRepo.login(request);

    response.fold((fail) {
      DPrint.log(fail.message);
    }, (success) {});
  }

  Future<void> register() async {
    final request = LoginRequestModel(
      email: "noyonbdc787@gmail.com",
      password: "123456",
    );
    final response = await _authRepo.login(request);

    response.fold((fail) {}, (success) {});
  }
}
