import 'package:dio/dio.dart';

import '../../../core/network/network_result.dart';
import '../models/response/get_profile_response_model.dart';



abstract class ProfileRepository {
  NetworkResult<GetProfileResponseModel> fetchProfile(String userId);

//   //profile update
//   NetworkResult<UserResponse> updatePersonalInfo(FormData request);
//
// //Change password
//   NetworkResult<void> changePass(ChangePasswordRequest request);
//
//   NetworkResult<UserResponse> uploadPhoto(FormData request);
//
//
//   NetworkResult<UserResponse> tradingInfo(FormData request);
}
