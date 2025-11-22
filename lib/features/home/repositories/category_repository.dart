import 'package:danielabake/features/home/models/response/get_item_by_category_id_response_model.dart';

import '../../../core/network/network_result.dart';
import '../models/response/get_category_response_model.dart';



abstract class CategoryRepository {
  NetworkResult<GetCategoryResponseModel> fetchCategory();
  NetworkResult<GetItemByCategoryIdResponseModel> fetchSpecificItem(String categoryId);
}
