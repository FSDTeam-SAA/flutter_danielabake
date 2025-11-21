import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:danielabake/features/Order_screen/screens/checkout2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/utils/app_svg.dart';
import '../../Order_screen/models/response/get_cart_response_model.dart';
import '../controller/cart_controller.dart';
import '../widgets/ingredients_list.dart';
import '../widgets/models/detail_food_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final _cartController = Get.find<AddToCartController>();
  final _orderController = Get.find<OrderController>();

  final RxInt quantity = 0.obs;

  @override
  void initState() {
    super.initState();
    _initializeQuantity();
  }

  void _initializeQuantity() async {
    /// Fetch latest cart data always
    await _orderController.fetchCart();

    /// Find this item in cart
    final cartItem = _orderController.cart.value?.items
        .firstWhereOrNull((i) => i.item.id == widget.food.id);

    quantity.value = cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBar: Obx(
            () => Container(
          color: const Color(0x2EFFB972),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${widget.food.price}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _squareButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (quantity.value <= 0) return;

                          quantity.value--;
                          _cartController.removeCart(widget.food.id);

                          /// refresh cart after removing
                          _orderController.fetchCart();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${quantity.value}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      _squareButton(
                        icon: Icons.add,
                        onTap: () {
                          quantity.value++;

                          /// call add API
                          _cartController.addCart(widget.food.id, 1);

                          /// refresh cart after adding
                          _orderController.fetchCart();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                text: 'Place Order',
                onSimplePressed: () => Get.to(() => Checkout2Screen()),
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// Food Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.food.image),
              ),
            ),

            /// Title & Description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.food.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500)),
                  Text(widget.food.description,
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            /// Ingredients Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 12,
                children: IngredientData.allIngredients
                    .where((item) =>
                    widget.food.ingredients.contains(item["name"]))
                    .map((item) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0x2EFFB972)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: AppSvg(
                              asset: item["asset"]!,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(item["name"]!,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _squareButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF4C8FFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
