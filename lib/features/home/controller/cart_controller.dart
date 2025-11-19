import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/repositories/cart_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../models/request/cart_request_model.dart';

class AddToCartController extends BaseController {
  final _addCartRepo = Get.find<CartRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();


  Future<void> register(String itemId, int quantity) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final request = AddItemRequest(userId: userId, itemId: itemId, quantity: quantity);

    final result = await _addCartRepo.addCart(request, userId, itemId, quantity);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Add cart success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("add cart success result : ${success.data.id}");
        setLoading(false);
      },
    );
  }
}
