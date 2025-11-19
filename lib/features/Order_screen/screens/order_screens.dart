import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/Order_screen/widget/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/text_with_view_all_button.dart';
import '../controller/order_controller.dart';
import '../widget/ordered_items_cart.dart';

class OrderScreens extends StatefulWidget {
  OrderScreens({super.key});

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
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: AppBarSearch(),
          )
        ],
      ),
      body: Column(
        children: [
          // Cart Items Section
          Expanded(
            child: Obx(() {
              if (controller.category.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final cartItems = controller.category.value!.items;

              if (cartItems.isEmpty) {
                return const Center(child: Text('Your cart is empty'));
              }

              return ListView.builder(
                //padding: const EdgeInsets.only(bottom: 10),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemCard(cartItem: item);
                },
              );
            }),
          ),

          // Ordered Items header
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextWithViewAllButton(
              text: 'Ordered Items',
              onTap: () {},
            ),
          ),


          // Obx(() {
          //   if (controller.order.value == null) {
          //     return const Center(child: CircularProgressIndicator());
          //   }
          //
          //   final orderedItems = controller.order.value!.items;
          //
          //   if (orderedItems.isEmpty) {
          //     return const Text("No ordered items found");
          //   }
          //
          //   return SizedBox(
          //     height: 250, // scrollable inside column
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: orderedItems.length,
          //       itemBuilder: (context, index) {
          //         return OrderedItemCard(orderItem: orderedItems[index]);
          //       },
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
