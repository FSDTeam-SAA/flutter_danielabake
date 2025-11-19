import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/request/remove_favorite_request_model.dart';
import '../models/response/favorite_food_response_model.dart';



class FavoriteFoodRepositoryImpl implements FavoriteFoodRepository {
  final ApiClient _apiClient;

  FavoriteFoodRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;


  @override
  NetworkResult<FavoriteFoodResponseModel> favorite(FavoriteFoodRequestModel request, String userId, String itemId){
    return _apiClient.post(
      endpoint: ApiConstants.home.favorite,
      data: request.toJson(),
      fromJsonT: (json) => FavoriteFoodResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<void> removeFavorite(RemoveFavoriteFoodRequestModel request, String userId, String itemId){
    return _apiClient.delete(
      endpoint: ApiConstants.home.removeFavorite,
      data: request.toJson(),
      fromJsonT: (json) {},
    );
  }
}