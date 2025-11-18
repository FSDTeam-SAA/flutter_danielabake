import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/models/response/favorite_food_response_model.dart';

import '../../../core/network/network_result.dart';
import '../../auth/models/request/register_request_model.dart';



abstract class FavoriteFoodRepository {
  NetworkResult<FavoriteFoodResponseModel> favorite(FavoriteFoodRequestModel request, String userId, String itemId);
}
