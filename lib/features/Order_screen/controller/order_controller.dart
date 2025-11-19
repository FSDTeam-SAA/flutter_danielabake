import 'dart:developer' as DPrint;
import 'package:danielabake/features/Order_screen/models/response/get_cart_response_model.dart';
import 'package:danielabake/features/Order_screen/models/response/getorder_by_id_response%20model.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class OrderController extends BaseController {
  final _cartRepo = Get.find<CartRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCartResponseModel> category = Rxn<GetCartResponseModel>();
  final Rxn<GetOrderByIdResponseModel> order = Rxn<GetOrderByIdResponseModel>();

  // final Rxn<OngoingOrderResponseModel> ongoingOrder = Rxn<OngoingOrderResponseModel>();
  // final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
    fetchOrders();
  }

  Future<void> fetchCart() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _cartRepo.fetchCart(userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Fetch Cart failed');
      },
          (success) {
        category.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> fetchOrders() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _cartRepo.fetchOrder(userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Fetch Cart failed');
      },
          (success) {
        order.value = success.data;
        DPrint.log(success.message);
      },
    );
  }
}
