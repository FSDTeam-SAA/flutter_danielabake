import 'package:danielabake/core/base/base_controller.dart';
import 'package:danielabake/core/network/models/refresh_token_request_model.dart';
import 'package:danielabake/features/auth/controller/remember_me_controller.dart';
import 'package:danielabake/features/auth/models/request/create_new_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/forgot_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/verify_otp_request_model.dart';
import 'package:danielabake/features/auth/screens/create_new_password_screen.dart';
import 'package:danielabake/features/auth/screens/verify_code_screen.dart';
import 'package:danielabake/features/splash_screen/screens/splash_screen.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/secure_store_services.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../screens/login_screen.dart';

class AuthController extends BaseController {
  final _authRepo = Get.find<AuthRepository>();
  bool _isSuccess = false;

  final AuthStorageService _authStorageService = AuthStorageService();

  //
  // AuthController(this._authRepo, this._authStorageService);

  Future<void> register(String name, String email, String password) async {
    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
    );

    final result = await _authRepo.register(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Register success result : ${success.data.id}");
        Get.to(SplashScreen());
        setLoading(false);
      },
    );
  }

  // Future verifyOTPRegister(String email, String otp) async {
  //   setLoading(true);
  //   setError("");
  //
  //   final request = OtpRequestModelRegister(email: email, otp: otp);
  //   final result = await _authRepository.otpVerifyRegister(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log("verify otp success result : ${fail.message}");
  //       setLoading(false);
  //     },
  //         (success) {
  //       DPrint.log("verify otp success result : ${success.data.message}");
  //       Get.to(EnterScreen());
  //       setLoading(false);
  //     },
  //   );
  // }

  // Login

  Future<void> login(
      RememberMeController? rememberMeController, {
        required String email,
        required String password,
      }) async {
    final request = LoginRequestModel(email: email, password: password);

    final result = await _authRepo.login(request);

    DPrint.log("Login Response ${result.isRight()}");

    result.fold(
          (fail) {
        setError(fail.message);
        setLoading(false);
      },
          (success) async {
        // Extract user data
        final user = success.data.user;

        // Store access token and refresh token for ANY user
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: user.id,
        );

        // If Remember Me is ON → save email + password
        if (rememberMeController?.rememberMe.value == true) {
          final secureStore = SecureStoreServices();
          secureStore.storeData('email', email);
          secureStore.storeData('password', password);
        }

        // Navigate to home screen
        Get.to(() => NavigationMenu());
      },
    );
  }


  //
  Future forgotPass(String email) async {
    final request = ForgotPasswordRequestModel(email: email);
    final result = await _authRepo.forgotPassword(request);

    result.fold(
          (fail) {
        setError(fail.message);
        setLoading(false);
      },
          (success) {
        Get.off(() => VerifyCodeScreen(email: email)); //changed
        setLoading(false);
      },
    );
  }


  Future verifyOTP(String email, String otp) async {

    final request = VerifyOtpRequestModel(email: email, otp: otp);
    final result = await _authRepo.verifyOtp(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("verify otp success result : ${fail.message}");

      },
      (success) {
        DPrint.log("verify otp success result : ${success.message}");
        Get.to(CreateNewPasswordScreen(email: email, otp: otp));
      },
    );
  }



  Future createNewPass(String email, String otp, String newPassword) async {

    final request = CreateNewPasswordRequestModel(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    final result = await _authRepo.createNewPassword(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("New Password set failed result : ${fail.message}");
      },
          (success) {
        DPrint.log(
          "New Password set successfully result : ${success.message}",
        );
        Get.offAll(LoginScreen());
      },
    );
  }

  //
  Future refreshToken() async {
    setLoading(true);

    final refreshToken = await _authStorageService.getRefreshToken();
    DPrint.log("Got refresh token: $refreshToken");
    final request = RefreshTokenRequestModel(refreshToken: refreshToken);

    final result = await _authRepo.refreshToken(request);

    final navi = result.fold(
          (fail) {
        DPrint.log("Refresh token failed: ${fail.message}");
        return _isSuccess = false;
      },
          (success) async {
        DPrint.log("Refresh token success: ${success.message}");
        await _authStorageService.storeAccessToken(accessToken: success.data.accessToken);
        await _authStorageService.storeRefreshToken(refreshToken: success.data.refreshToken);
        //await _authStorageService.storeRefreshToken(success.data.refreshToken);
        return _isSuccess = true;
      },
    );
    return navi;
  }
  //
  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    Get.offAll(() => LoginScreen());
  }
}
