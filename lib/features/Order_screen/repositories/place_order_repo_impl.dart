
import 'package:danielabake/core/network/api_client.dart';
import 'package:danielabake/core/network/constants/api_constants.dart';
import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo.dart';
import '../models/request/place_order_request_model.dart';
import '../models/response/place_order_response_model.dart';

class PlaceOrderRepoImpl implements PlaceOrderRepo {
  final ApiClient _apiClient;

  PlaceOrderRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<PlaceOrderResponseModel> placeOrder(CheckoutRequestModel request, String userId){
    return _apiClient.post(
      endpoint: ApiConstants.order.placeOrder,
      data: request.toJson(),
      fromJsonT: (json) => PlaceOrderResponseModel.fromJson(json),
    );
  }
}
