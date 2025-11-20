import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/response/get_cart_response_model.dart';
import '../models/response/get_order_by_id_response model.dart';



class CartRepoImpl implements CartRepo{
  final ApiClient _apiClient;

  CartRepoImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetCartResponseModel> fetchCart(String userId){
    return _apiClient.get(
      endpoint: ApiConstants.order.fetchCart(userId),
      fromJsonT: (json) => GetCartResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<GetOrderByIdResponseModel> fetchOrder(){
    return _apiClient.get(
      endpoint: ApiConstants.order.fetchOrder,
      fromJsonT: (json) => GetOrderByIdResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}