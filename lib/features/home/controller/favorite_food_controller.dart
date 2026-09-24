import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/models/request/remove_favorite_request_model.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';
import 'package:danielabake/features/profile_screens/models/response/get_favorite_items_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../profile_screens/repositories/profile_repository.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';

class FavoriteFoodController extends BaseController {
  final _profileRepository = Get.find<ProfileRepository>();
  final _favoriteRepository = Get.find<FavoriteFoodRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final RxList<GetFavoriteItemsResponseModel> favoriteItems =
      <GetFavoriteItemsResponseModel>[].obs;
  final RxList<String> favoriteItemIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteItem();
  }

  Future<bool> favorite(String itemId) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      if (Get.isDialogOpen == true)
        return false; // Prevent double dialogs, return false
      Get.defaultDialog(
        title: "Not Sign in",
        middleText: "Please sign in first to add favorites.",
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.to(() => const LoginScreen());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7F3615)),
            child: const Text("Sign In", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
      setLoading(false);
      return false; // Return false for guest
    }
    final request = FavoriteFoodRequestModel(userId: userId, itemId: itemId);
    final result = await _favoriteRepository.favorite(request, userId, itemId);

    return result.fold(
      (fail) {
        if (fail.message.toLowerCase().contains("already")) {
          setFavoriteState(itemId, true);
          return true;
        }
        setError(fail.message);
        DPrint.log("Favorite success result : ${fail.message}");
        setLoading(false);
        return false; // Return false on failure
      },
      (success) {
        DPrint.log("Favorite success result : ${success.data.id}");
        setFavoriteState(itemId, true);
        // Get.snackbar(
        //   "Success",
        //   "Item added to favorites",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        return true; // Return true on success
      },
    );
  }

  Future<void> fetchFavoriteItem() async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      // Guest user: just return empty list, no error
      favoriteItems.clear();
      favoriteItemIds.clear();
      return;
    }

    setLoading(true);
    final result = await _profileRepository.fetchFavoriteItems(userId);

    result.fold((fail) => setError(fail.message), (success) {
      // ✅ FILTER NULL ITEMS HERE
      final cleanList = success.data.where((e) => e.item != null).toList();

      favoriteItems.assignAll(cleanList);
      favoriteItemIds.assignAll(
        cleanList.map((entry) => entry.item!.id).toSet().toList(),
      );
    });

    setLoading(false);
  }

  bool isFavoriteItem(String itemId) => favoriteItemIds.contains(itemId);

  void setFavoriteState(String itemId, bool isFavorite) {
    if (isFavorite) {
      if (!favoriteItemIds.contains(itemId)) {
        favoriteItemIds.add(itemId);
      }
    } else {
      favoriteItemIds.remove(itemId);
    }

    favoriteItemIds.refresh();
  }

  Future<bool> removeFavorite(String itemId) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) return false;

    final request = RemoveFavoriteFoodRequestModel(
      userId: userId,
      itemId: itemId,
    );
    final result = await _favoriteRepository.removeFavorite(
      request,
      userId,
      itemId,
    );

    return result.fold(
      (fail) {
        Get.snackbar('Error', fail.message);
        return false;
      },
      (success) {
        // INSTANT UI UPDATE — Remove from observable list
        favoriteItems.removeWhere((entry) => entry.item?.id == itemId);
        favoriteItems.refresh();
        setFavoriteState(itemId, false);

        // Get.snackbar(
        //   "Removed",
        //   "Item removed from favorites",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        return true;
      },
    );
  }
}
