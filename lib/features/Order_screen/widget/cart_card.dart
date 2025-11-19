import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/response/get_cart_response_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  CartItemCard({super.key, required this.cartItem});

  // Reactive quantity
  final RxInt quantity = 0.obs;

  @override
  Widget build(BuildContext context) {
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
                      item.name, // optional subtitle
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
                      _squareButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (quantity.value > 1) quantity.value--;
                          cartItem.quantity = quantity.value;
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

                      _squareButton(
                        icon: Icons.add,
                        onTap: () {
                          quantity.value++;
                          cartItem.quantity = quantity.value;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // QUANTITY BUTTONS LIKE FIGMA


          const SizedBox(height: 12),
          const Divider(
            thickness: 1,
            height: 1,
            color: Color(0xFFAD653F),
          ),
          SizedBox(height: 12,),

          // BOTTOM TOTAL
          Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ${quantity.value} items',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,),
                ),
                Text(
                  '\$${(price * quantity.value).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Figma-style round square button
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
