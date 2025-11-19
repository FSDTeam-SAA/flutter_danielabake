import 'dart:developer' as DPrint;
import 'dart:io';
import 'package:danielabake/features/home/models/response/get_category_response_model.dart';
import 'package:danielabake/features/home/repositories/category_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class CategoryController extends BaseController {
  final _categoryRepository = Get.find<CategoryRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCategoryResponseModel> category = Rxn<GetCategoryResponseModel>();

  // final Rxn<OngoingOrderResponseModel> ongoingOrder = Rxn<OngoingOrderResponseModel>();
  // final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    final result = await _categoryRepository.fetchCategory();

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
      (success) {
        category.value = success.data;
        DPrint.log(success.message);
      },
    );
  }
}
