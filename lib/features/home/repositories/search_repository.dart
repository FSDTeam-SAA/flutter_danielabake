import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';
import 'package:danielabake/features/home/models/response/search_response_model.dart';

import '../../../core/network/network_result.dart';



abstract class SearchRepository {
  NetworkResult<GetPopularItemResponseModel> searchItem(String text);

}
