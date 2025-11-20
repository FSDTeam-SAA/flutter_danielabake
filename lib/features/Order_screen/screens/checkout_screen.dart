import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/widget/cart_card.dart';
import 'package:danielabake/features/Order_screen/widget/checkout_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/text_with_view_all_button.dart';
import '../controller/order_controller.dart';
import '../widget/ordered_items_cart.dart';
import 'checkout2.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 30.0), child: AppBarSearch()),
        ],
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
                  return CheckoutCard(cartItem: item);
                },
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    Text("\$${controller.category.value!.total.toStringAsFixed(2)}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                PrimaryButton(text: 'Continue', onSimplePressed: ()=> Get.to(() => Checkout2Screen())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
