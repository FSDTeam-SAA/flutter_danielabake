import 'package:danielabake/features/home/models/request/remove_cart_request_model.dart';

import '../../../core/network/network_result.dart';
import '../models/request/cart_request_model.dart';
import '../models/response/cart_respponse_model.dart';



abstract class CartRepository {
  NetworkResult<OrderResponse> addCart(AddItemRequest request, String userId, String itemId, int quantity);
  NetworkResult<void> removeCart(RemoveCartRequestModel request, String userId, String itemId);
}
