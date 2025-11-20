import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/Order_screen/models/request/place_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/response/place_order_response_model.dart';



abstract class PlaceOrderRepo{

  //Auth
  NetworkResult<PlaceOrderResponseModel> placeOrder(CheckoutRequestModel request, String userId);
  //NetworkResult<LoginResponseModel> login(LoginRequestModel request);

}
