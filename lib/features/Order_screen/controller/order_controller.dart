import 'dart:developer' as d_print;
import 'package:danielabake/features/Order_screen/models/request/place_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/request/re_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_cart_response_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_order_by_id_response_model.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../home/models/request/cart_request_model.dart';
import '../../home/models/request/remove_cart_request_model.dart';
import '../../home/repositories/cart_repository.dart';

class OrderController extends BaseController {
  final _cartRepo = Get.find<CartRepo>();
  final _placeOrderRepo = Get.find<PlaceOrderRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCartResponseModel> cart = Rxn<GetCartResponseModel>();
  final Rxn<GetOrderByIdResponseModel> ongoingOrder =
      Rxn<GetOrderByIdResponseModel>();
  final Rxn<GetOrderByIdResponseModel> completedOrder =
      Rxn<GetOrderByIdResponseModel>();

  final _addCartRepo = Get.find<CartRepository>();

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
    // d_print.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      // Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _cartRepo.fetchCart(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log('Fetch Cart failed');
      },
      (success) {
        cart.value = success.data;
        d_print.log(success.message);
      },
    );
  }

  // Pending item storage
  String? _pendingItemId;
  int? _pendingItemQuantity;

  Future<bool> addCart(String itemId, int quantity) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      // Store pending item
      _pendingItemId = itemId;
      _pendingItemQuantity = quantity;

      if (Get.isDialogOpen == true) return false; // Prevent double dialogs
      Get.defaultDialog(
        title: "Not Sign in",
        middleText: "Please sign in to add items to cart.",
        actions: [
          TextButton(
            onPressed: () {
              // Clear pending item on cancel
              _pendingItemId = null;
              _pendingItemQuantity = null;
              Get.back();
            },
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
      return false; // User not logged in
    }

    setLoading(true); // optional: show loading

    // --- Optimistic Update ---
    final currentCart = cart.value;
    bool isNewItem = false;
    CartItem? newItemMock;

    if (currentCart != null) {
      final existingItem = currentCart.items.firstWhereOrNull(
        (e) => e.item?.id == itemId,
      );
      if (existingItem != null) {
        existingItem.quantity += quantity;
      } else {
        isNewItem = true;
        newItemMock = CartItem(
          id: 'temp_id',
          item: ItemDetails(
            id: itemId,
            name: 'Loading...',
            description: '',
            price: 0,
            image: '',
          ),
          quantity: quantity,
        );
        currentCart.items.add(newItemMock);
      }
      cart.refresh();
    }
    // --------------------------

    final request = AddItemRequest(
      userId: userId,
      itemId: itemId,
      quantity: quantity,
    );

    final result = await _addCartRepo.addCart(
      request,
      userId,
      itemId,
      quantity,
    );

    return result.fold(
      (fail) {
        // --- Revert Optimistic Update ---
        if (currentCart != null) {
          if (isNewItem && newItemMock != null) {
            currentCart.items.remove(newItemMock);
          } else {
            final existingItem = currentCart.items.firstWhereOrNull(
              (e) => e.item?.id == itemId,
            );
            if (existingItem != null) {
              existingItem.quantity -= quantity;
              if (existingItem.quantity <= 0) {
                currentCart.items.remove(existingItem);
              }
            }
          }
          cart.refresh();
        }
        // --------------------------------
        setError(fail.message);
        Get.snackbar('Error', fail.message);
        setLoading(false);
        return false; // Failed
      },
      (success) async {
        // Option 1: Best - Re-fetch the entire cart (most reliable)
        await fetchCart(); // This will update cart.value → triggers Obx → badge appears

        setLoading(false);
        return true; // Success
      },
    );
  }

  Future<void> retryAddCartAfterLogin() async {
    if (_pendingItemId != null && _pendingItemQuantity != null) {
      d_print.log("Retrying pending cart item: $_pendingItemId");
      final success = await addCart(_pendingItemId!, _pendingItemQuantity!);
      if (success) {
        // Get.snackbar(
        //   "Success",
        //   "Pending item added to cart",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        //   margin: const EdgeInsets.all(12),
        //   duration: const Duration(seconds: 2),
        // );
      }
      // Clear after retry (successful or not to prevent infinite loops/stale data)
      _pendingItemId = null;
      _pendingItemQuantity = null;
    }
  }

  Future<void> removeCart(String itemId) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    // 1. Optimistically remove from UI IMMEDIATELY
    final currentCart = cart.value;
    if (currentCart != null) {
      final removedItem = currentCart.items.firstWhereOrNull(
        (e) => e.item?.id == itemId,
      );
      if (removedItem != null) {
        currentCart.items.removeWhere((e) => e.item?.id == itemId);
        cart.refresh(); // This triggers instant rebuild in Obx(() => CartItemCard)

        // Get.snackbar(
        //   "Removed",
        //   "Item removed from cart",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        //   duration: const Duration(seconds: 2),
        // );
      }
    }

    // 2. Then call API in background
    final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
    final result = await _addCartRepo.removeCart(request, userId, itemId);

    result.fold(
      (fail) {
        // API FAILED → Show error + restore item (optional but safe)
        // Get.snackbar(
        //   "Failed",
        //   "Could not remove item. Try again.",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );

        // Optional: Restore the item if API failed
        // await fetchCart(); // safest way to sync
      },
      (success) {
        // API succeeded → already removed optimistically → do nothing
        d_print.log("Item removed from server successfully");
      },
    );
  }

  Future<void> removeOneItemFromCart(String itemId) async {
    final userId = await _authStorageService.getUserId();
    d_print.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    setLoading(true);

    // --- Optimistic Update ---
    final currentCart = cart.value;
    bool wasRemoved = false;
    CartItem? removedItemCopy;

    if (currentCart != null) {
      final existingItem = currentCart.items.firstWhereOrNull(
        (e) => e.item?.id == itemId,
      );
      if (existingItem != null) {
        if (existingItem.quantity > 1) {
          existingItem.quantity -= 1;
        } else {
          removedItemCopy = CartItem(
            id: existingItem.id,
            item: existingItem.item,
            quantity: existingItem.quantity,
          );
          currentCart.items.remove(existingItem);
          wasRemoved = true;
        }
        cart.refresh();
      }
    }
    // --------------------------

    final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
    final result = await _addCartRepo.removeOneCartItem(
      request,
      userId,
      itemId,
    );

    result.fold(
      (fail) {
        // --- Revert Optimistic Update ---
        if (currentCart != null) {
          if (wasRemoved && removedItemCopy != null) {
            currentCart.items.add(removedItemCopy);
          } else {
            final existingItem = currentCart.items.firstWhereOrNull(
              (e) => e.item?.id == itemId,
            );
            if (existingItem != null) {
              existingItem.quantity += 1;
            }
          }
          cart.refresh();
        }
        // --------------------------------
        setError(fail.message);
        d_print.log("Favorite success result : ${fail.message}");
        setLoading(false);
      },
      (success) async {
        d_print.log("Favorite success result : ${success.message}");
        await fetchCart();
        // Get.snackbar(
        //   "Removed",
        //   "Item removed from cart",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        setLoading(false);
      },
    );
  }

  Future<void> fetchOngoingOrders() async {
    final result = await _cartRepo.fetchOngoingOrder();

    result.fold(
      (fail) {
        d_print.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        d_print.log("Raw order data: ${success.data}");
        ongoingOrder.value = success.data;
      },
    );
  }

  Future<void> fetchCompletedOrders() async {
    final result = await _cartRepo.fetchCompletedOrder();

    result.fold(
      (fail) {
        d_print.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        d_print.log("Raw order data: ${success.data}");
        completedOrder.value = success.data;
      },
    );
  }

  Future<void> placeOrder(
    String address,
    String phone,
    DateTime scheduledFor,
    DateTime scheduledTo,
    bool pickOrder,
  ) async {
    final userId = await _authStorageService.getUserId();
    d_print.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    final request = CheckoutRequestModel(
      userId: userId,
      address: address,
      phone: phone,
      scheduledFor: scheduledFor,
      scheduledTo: scheduledTo,
      pickOrder: pickOrder,
    );

    final result = await _placeOrderRepo.placeOrder(request, userId);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Place Order success result : ${fail.message}");
      },
      (success) {
        d_print.log("Place order result : ${success.data.id}");
        Get.offAll(() => NavigationMenu());
      },
    );
  }

  Future<void> reOrder(String id) async {
    final userId = await _authStorageService.getUserId();
    d_print.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    final request = ReOrderRequestModel(userId: userId);

    final result = await _placeOrderRepo.reOrder(request, id);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Place Order success result : ${fail.message}");
      },
      (success) {
        d_print.log("Place order result : ${success.data.id}");
        // Get.snackbar(
        //   "Success",
        //   "Item added to the cart",
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        Get.offAll(() => NavigationMenu());
      },
    );
  }

  void reset() {
    cart.value = null;
    isLoading.value = false;
  }

  int getItemQuantity(String itemId) {
    if (cart.value == null) return 0;
    final item = cart.value!.items.firstWhereOrNull(
      (e) => e.item?.id == itemId,
    );
    return item?.quantity ?? 0;
  }
}
