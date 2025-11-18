import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/repositories/category_repository.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';


import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../auth/models/request/register_request_model.dart';
import '../models/response/favorite_food_response_model.dart';
import '../models/response/get_category_response_model.dart';



class FavoriteFoodRepositoryImpl implements FavoriteFoodRepository {
  final ApiClient _apiClient;

  FavoriteFoodRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;


  @override
  NetworkResult<FavoriteFoodResponseModel> favorite(FavoriteFoodRequestModel request, String userId, String itemId){
    return _apiClient.get(
      endpoint: ApiConstants.home.favorite,
      fromJsonT: (json) => FavoriteFoodResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}