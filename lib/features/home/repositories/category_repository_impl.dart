import 'package:danielabake/features/home/repositories/category_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/response/get_category_response_model.dart';
import '../models/response/get_item_by_category_id_response_model.dart';



class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetCategoryResponseModel> fetchCategory() {
    return _apiClient.get(
      endpoint: ApiConstants.home.category,
      fromJsonT: (json) => GetCategoryResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<GetItemByCategoryIdResponseModel> fetchSpecificItem(String categoryId){
    return _apiClient.get(
      endpoint: ApiConstants.home.items(categoryId),
      fromJsonT: (json) => GetItemByCategoryIdResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

}