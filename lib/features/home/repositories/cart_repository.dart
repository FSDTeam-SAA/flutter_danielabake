import '../../../core/network/network_result.dart';
import '../models/request/cart_request_model.dart';
import '../models/response/cart_respponse_model.dart';
import '../models/response/get_category_response_model.dart';



abstract class CartRepository {
  NetworkResult<OrderResponse> addCart(AddItemRequest request, String userId, String itemId, int quantity);
}
