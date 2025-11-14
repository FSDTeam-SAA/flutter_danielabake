import 'package:danielabake/features/profile_screens/models/response/get_profile_response_model.dart';
import 'package:danielabake/features/profile_screens/repositories/profile_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';



class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetProfileResponseModel> fetchProfile(String userId){
    return _apiClient.get(endpoint: ApiConstants.profile.fetchProfile(userId), fromJsonT: (json) =>
        GetProfileResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }




  // @override
  // NetworkResult<UserResponse> updatePersonalInfo(FormData request) {
  //   return _apiClient.patch(
  //       ApiConstants.user.updateProfile,
  //       formData: request,
  //       fromJsonT: (json) => UserResponse.fromJson(json),
  //       isFormData: true
  //   );
  // }
  //
  // @override
  // NetworkResult<void> changePass(ChangePasswordRequest request) {
  //   return _apiClient.post(
  //     ApiConstants.auth.changePassword,
  //     data: request.toJson(),
  //     fromJsonT: (json) => [],
  //   );
  // }
  //
  // @override
  // NetworkResult<UserResponse> uploadPhoto(FormData request) {
  //   return _apiClient.patch(
  //       ApiConstants.user.updateProfile,
  //       formData: request,
  //       fromJsonT: (json) => UserResponse.fromJson(json),
  //       isFormData: true
  //   );
  // }
  //
  // @override
  // NetworkResult<UserResponse> tradingInfo(FormData request) {
  //   return _apiClient.patch(
  //       ApiConstants.user.updateProfile,
  //       formData: request,
  //       fromJsonT: (json) => UserResponse.fromJson(json),
  //       isFormData: true
  //   );
  // }
}