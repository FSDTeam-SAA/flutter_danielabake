import 'dart:developer' as DPrint;
import 'package:danielabake/features/Order_screen/models/request/place_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_cart_response_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_order_by_id_response%20model.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo.dart';
import 'package:danielabake/features/home/screens/home_screen.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class OrderController extends BaseController {
  final _cartRepo = Get.find<CartRepo>();
  final _placeOrderRepo = Get.find<PlaceOrderRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCartResponseModel> cart = Rxn<GetCartResponseModel>();
  final Rxn<GetOrderByIdResponseModel> ongoingOrder = Rxn<GetOrderByIdResponseModel>();
  final Rxn<GetOrderByIdResponseModel> completedOrder = Rxn<GetOrderByIdResponseModel>();

  // final Rxn<OngoingOrderResponseModel> ongoingOrder = Rxn<OngoingOrderResponseModel>();
  // final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
    fetchOngoingOrders();
    fetchCompletedOrders();
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
        cart.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> fetchOngoingOrders() async {
    final result = await _cartRepo.fetchOngoingOrder();

    result.fold(
      (fail) {
        DPrint.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        DPrint.log("Raw order data: ${success.data}");
        ongoingOrder.value = success.data;
      },
    );
  }

  Future<void> fetchCompletedOrders() async {
    final result = await _cartRepo.fetchCompletedOrder();

    result.fold(
      (fail) {
        DPrint.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        DPrint.log("Raw order data: ${success.data}");
        completedOrder.value = success.data;
      },
    );
  }

  Future<void> placeOrder(String address, String phone) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    final request = CheckoutRequestModel(userId: userId, address: address, phone: phone
    );

    final result = await _placeOrderRepo.placeOrder(request, userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Place Order success result : ${fail.message}");
      },
          (success) {
        DPrint.log("Place order result : ${success.data.id}");
        Get.offAll(() => NavigationMenu());
      },
    );
  }
}
