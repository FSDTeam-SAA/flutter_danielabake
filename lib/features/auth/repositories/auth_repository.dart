import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/auth/models/request/create_new_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/forgot_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/login_request_model.dart';
import 'package:danielabake/features/auth/models/request/verify_otp_request_model.dart';
import 'package:danielabake/features/auth/models/response/forgot_password_response_model.dart';
import 'package:danielabake/features/auth/models/response/register_response_model.dart';

import '../models/request/register_request_model.dart';
import '../models/response/login_response_model.dart';
import '/core/network/models/refresh_token_request_model.dart';

abstract class AuthRepository {

  //Auth
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  NetworkResult<LoginResponseModel> login(LoginRequestModel request);
  NetworkResult<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  NetworkResult<void> verifyOtp(VerifyOtpRequestModel request);
  NetworkResult<void> createNewPassword(CreateNewPasswordRequestModel request);

  NetworkResult<LoginResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  );
}
