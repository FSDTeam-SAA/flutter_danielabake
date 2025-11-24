import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/models/response/get_category_response_model.dart';
import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';
import 'package:danielabake/features/home/models/response/search_response_model.dart';
import 'package:danielabake/features/home/repositories/home_repository.dart';
import 'package:danielabake/features/home/repositories/search_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class HomeController extends BaseController {
  final _homeRepository = Get.find<HomeRepository>();
  final _searchRepository = Get.find<SearchRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCategoryResponseModel> category =
  Rxn<GetCategoryResponseModel>();

  final Rxn<GetPopularItemResponseModel> popularItem = Rxn<GetPopularItemResponseModel>();
  final Rxn<GetPopularItemResponseModel> search = Rxn<GetPopularItemResponseModel>();
  // final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchPopularItem();
  }

  Future<void> fetchPopularItem() async {

    final result = await _homeRepository.fetchPopularItems();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        popularItem.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> searchItem(String text) async {

    final result = await _searchRepository.searchItem(text);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        search.value = success.data;
        DPrint.log(success.message);
      },
    );
  }
}
