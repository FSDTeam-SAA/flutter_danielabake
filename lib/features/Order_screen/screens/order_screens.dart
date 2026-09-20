import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/screens/checkout2.dart';
import 'package:danielabake/features/Order_screen/screens/checkout_screen.dart';
import 'package:danielabake/features/Order_screen/widget/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../widget/simmer_card.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({super.key});

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    controller.fetchCart();
  }



  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Review Order',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [

          Text('We kindly require a minimum of two days\' notice for all orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF7F3615)),),
          // Cart Items Section
          Expanded(
            child: Obx(() {
              // Show shimmer while explicitly loading
              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemCount: 5,
                  itemBuilder: (context, index) => const ShimmerCartItemCard(),
                );
              }

              // After loading, check if cart is empty
              if (controller.cart.value == null || controller.cart.value!.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add delicious items to get started!',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              // Show actual cart items
              return ListView.builder(
                itemCount: controller.cart.value!.items.length,
                itemBuilder: (context, index) {
                  final item = controller.cart.value!.items[index];
                  return CartItemCard(cartItem: item);
                },
              );
            }),
          ),

          // Only show the button if there are items in the cart
          Obx(() {
            final hasItems = controller.cart.value != null &&
                controller.cart.value!.items.isNotEmpty &&
                !controller.isLoading.value;

            if (hasItems) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  text: 'Continue to Checkout',
                  key: Key("order-screen"),
                  onSimplePressed: () => Get.to(() => Checkout2Screen()),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
