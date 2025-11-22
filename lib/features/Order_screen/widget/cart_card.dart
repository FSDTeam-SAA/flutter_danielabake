import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/cart_controller.dart';
import '../models/response/get_cart_response_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  CartItemCard({super.key, required this.cartItem});

  // Reactive quantity
  final RxInt quantity = 0.obs;
  final RxInt quantity1 = 0.obs;

  @override
  Widget build(BuildContext context) {
    quantity.value = cartItem.quantity;
    final AddToCartController controller = Get.find<AddToCartController>();

    final item = cartItem.item;
    final price = item.price;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // MAIN CARD
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0x2EFFB972), // soft peach color
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
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

                    // NAME + DESCRIPTION
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7F3615)),
                          ),
                        ],
                      ),
                    ),

                    // PRICE + QUANTITY BUTTONS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B76FF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _squareButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (quantity.value > 1) {
                                      quantity.value--;
                                      cartItem.quantity = quantity.value;
                                      controller.removeOneItemFromCart(cartItem.item.id);
                                    }
                                  },
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                                  child: Obx(
                                        () => Text(
                                      '${quantity.value}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                _squareButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    quantity.value++;
                                    cartItem.quantity = quantity.value;
                                    controller.addCart(
                                        cartItem.item.id, quantity1.value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: Color(0xFFAD653F),
                ),
                const SizedBox(height: 12),

                // BOTTOM TOTAL
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total ${quantity.value} items',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${(price * quantity.value).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // CROSS BUTTON (TOP RIGHT)
        Positioned(
          top: 12,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                controller.removeCart(item.id);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Figma-style square button
  Widget _squareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
