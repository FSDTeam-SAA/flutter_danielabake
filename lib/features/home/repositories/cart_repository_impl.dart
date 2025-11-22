import 'package:danielabake/features/home/repositories/cart_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/request/cart_request_model.dart';
import '../models/request/remove_cart_request_model.dart';
import '../models/response/cart_respponse_model.dart';
import '../models/response/remove_cart_response_model.dart';



class CartRepositoryImpl implements CartRepository {
  final ApiClient _apiClient;

  CartRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<OrderResponse> addCart(AddItemRequest request, String userId, String itemId, int quantity){
    return _apiClient.post(
      endpoint: ApiConstants.home.addCart,
      data: request.toJson(),
      fromJsonT: (json) => OrderResponse.fromJson(json),
    );
  }

  @override
  NetworkResult<RemoveCartResponseModel> removeOneCartItem(RemoveCartRequestModel request, String userId, String itemId){
    return _apiClient.put(
      endpoint: ApiConstants.home.removeOneCart,
      data: request.toJson(),
      fromJsonT: (json) => RemoveCartResponseModel.fromJson(json),
    );
  }


  @override
  NetworkResult<void> removeCart(RemoveCartRequestModel request, String userId, String itemId){
    return _apiClient.delete(
      endpoint: ApiConstants.home.removeCart,
      data: request.toJson(),
      fromJsonT: (json) {},
    );
  }

}