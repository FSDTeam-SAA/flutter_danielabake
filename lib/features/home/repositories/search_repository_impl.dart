import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';
import 'package:danielabake/features/home/repositories/category_repository.dart';
import 'package:danielabake/features/home/repositories/search_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/response/get_category_response_model.dart';
import '../models/response/get_item_by_category_id_response_model.dart';
import '../models/response/search_response_model.dart';



class SearchRepositoryImpl implements SearchRepository{
  final ApiClient _apiClient;

  SearchRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetPopularItemResponseModel> searchItem(String text){
    return _apiClient.get(
      endpoint: ApiConstants.home.searchItem(text),
      fromJsonT: (json) => GetPopularItemResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}