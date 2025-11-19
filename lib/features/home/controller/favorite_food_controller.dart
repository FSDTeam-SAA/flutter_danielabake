import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/models/request/remove_favorite_request_model.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class FavoriteFoodController extends BaseController {
  final _favoriteRepository = Get.find<FavoriteFoodRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();


  Future<void> favorite(String itemId) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }
    final request = FavoriteFoodRequestModel(userId: userId, itemId: itemId);
    final result = await _favoriteRepository.favorite(request, userId, itemId);


    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Favorite success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("Favorite success result : ${success.data.id}");
        Get.snackbar(
          "Success",
          "Item added to your favorites",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> removeFavorite(String itemId)async{
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }
    final request = RemoveFavoriteFoodRequestModel(userId: userId, itemId: itemId);
    final result = await _favoriteRepository.removeFavorite(request, userId, itemId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Favorite success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("Favorite success result : ${success.message}");
        Get.snackbar(
          "Success",
          "Item removed from favorites",
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
    );
  }
}
