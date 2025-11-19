import 'package:danielabake/features/Order_screen/models/response/get_cart_response_model.dart';
import 'package:danielabake/features/Order_screen/models/response/getorder_by_id_response%20model.dart';

import '../../../core/network/network_result.dart';




abstract class CartRepo{
  NetworkResult<GetCartResponseModel> fetchCart(String userId);
  NetworkResult<GetOrderByIdResponseModel> fetchOrder(String userId);
}
