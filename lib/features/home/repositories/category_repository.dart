import '../../../core/network/network_result.dart';
import '../models/response/get_category_response_model.dart';



abstract class CategoryRepository {
  NetworkResult<GetCategoryResponseModel> fetchCategory();
}
