import 'package:danielabake/features/profile_screens/models/request/current_password_update_request_model.dart';
import 'package:danielabake/features/profile_screens/models/response/get_favorite_items_response_model.dart';
import 'package:danielabake/features/profile_screens/models/response/ongoing_order_response_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/network_result.dart';
import '../models/response/get_profile_response_model.dart';
import '../models/response/update_profile_response_model.dart';



abstract class ProfileRepository {
  NetworkResult<GetProfileResponseModel> fetchProfile(String userId);

  //profile update
  NetworkResult<UpdateProfileResponseModel> updatePersonalInfo(FormData formData, String userId);
//
//Change password
  NetworkResult<void> changePass(UpdatePasswordRequestModel request);
  NetworkResult<OngoingOrderResponseModel> fetchOngoingOrder();
  NetworkResult<OngoingOrderResponseModel> fetchCompletedOrder();
  NetworkResult<List<GetFavoriteItemsResponseModel>> fetchFavoriteItems(String userId);
  // NetworkResult<Category> fetchCategory(String userId);
//
//   NetworkResult<UserResponse> uploadPhoto(FormData request);
//
//
//   NetworkResult<UserResponse> tradingInfo(FormData request);
}
