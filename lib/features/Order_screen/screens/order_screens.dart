import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/screens/checkout_screen.dart';
import 'package:danielabake/features/Order_screen/widget/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';

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
    controller.fetchOrders(); // fetch orders from API
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
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
          // Cart Items Section
          Expanded(
            child: Obx(() {
              if (controller.order.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final cartItems = controller.category.value!.items;

              if (cartItems.isEmpty) {
                return const Center(child: Text('Your cart is empty'));
              }

              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemCard(cartItem: item);
                },
              );
            }),
          ),

          // Only show the button if there are items in the cart
          Obx(() {
            if (controller.category.value != null &&
                controller.category.value!.items.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: PrimaryButton(
                  text: 'Place Order',
                  onSimplePressed: () async => Get.to(() => CheckoutScreen()),
                ),
              );
            } else {
              return const SizedBox.shrink(); // empty space if no items
            }
          }),
          // Ordered Items header
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: TextWithViewAllButton(
          //     text: 'Ordered Items',
          //     onTap: () {},
          //   ),
          // ),
          //
          // // Orders List
          // // Orders List
          // Obx(() {
          //   if (controller.isLoading.value) {
          //     return const Center(child: CircularProgressIndicator());
          //   }
          //
          //   if (controller.order.value == null || controller.order.value!.orders.isEmpty) {
          //     return const Center(child: Text("No Orders Found"));
          //   }
          //
          //   final orders = controller.order.value!.orders;
          //
          //   return Expanded(
          //     child: ListView.builder(
          //       itemCount: orders.length,
          //       itemBuilder: (context, orderIndex) {
          //         final order = orders[orderIndex];
          //
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             ListView.builder(
          //               shrinkWrap: true,
          //               physics: const NeverScrollableScrollPhysics(),
          //               itemCount: order.items.length,
          //               itemBuilder: (context, itemIndex) {
          //                 final orderedItem = order.items[itemIndex];
          //                 return OrderedItemCard(
          //                   orderItem: orderedItem,
          //                   address: order.address,
          //                   status: order.status,
          //                 );
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //     ),
          //   );
          // })
        ],
      ),
    );
  }
}
