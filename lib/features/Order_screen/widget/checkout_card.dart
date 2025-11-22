import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/cart_controller.dart';
import '../models/response/get_cart_response_model.dart';

class CheckoutCard extends StatelessWidget {
  final CartItem cartItem;

  CheckoutCard({super.key, required this.cartItem});

  // Reactive quantity
  final RxInt quantity = 0.obs;
  final RxInt quantity1 = 0.obs;

  @override
  Widget build(BuildContext context) {
    // inside CheckoutCard widget
    final AddToCartController controller = Get.find<AddToCartController>();

    quantity.value = cartItem.quantity;

    final item = cartItem.item;

    final price = item.price;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0x2EFFB972), // soft peach color like Figma
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP CONTENT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              // NAME + PRICE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description, // optional subtitle
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7F3615),
                      ),
                    ),
                  ],
                ),
              ),

              // TOTAL PRICE
              Column(
                children: [
                  Obx(
                        () => Text(
                      '\$${(price * quantity.value).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      //here you have to add remove  cart api
                      _squareButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (quantity.value > 1) {
                            quantity.value--;
                            cartItem.quantity = quantity.value;

                            controller.removeOneItemFromCart(cartItem.item.id); // <-- API CALL
                          }
                        },
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(
                              () => Text(
                            '${quantity.value}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      //here you have to add add cart api
                      _squareButton(
                        icon: Icons.add,
                        onTap: () {
                          quantity.value++;
                          cartItem.quantity = quantity.value;

                          controller.addCart(cartItem.item.id, quantity1.value); // <-- API CALL
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom round square button
  Widget _squareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF4C8FFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
