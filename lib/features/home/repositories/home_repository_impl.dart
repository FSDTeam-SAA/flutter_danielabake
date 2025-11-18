import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';
import 'package:danielabake/features/home/repositories/home_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';



class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetPopularItemResponseModel> fetchPopularItems() {
    return _apiClient.get(
      endpoint: ApiConstants.home.category,
      fromJsonT: (json) => GetPopularItemResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

}