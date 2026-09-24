import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as DPrint;
import '../controller/favorite_food_controller.dart';
import '../../Order_screen/controller/order_controller.dart';

class FoodCard extends StatelessWidget {
  final String imagePath;
  final double? rating;
  final int? reviewCount;
  final String title;
  final String description;
  final String price;
  final String itemId;
  final RxBool isFavorite; // Observable
  final VoidCallback onAdd;
  final Future<void> Function(bool newValue)?
  onFavoriteToggle; // optional callback

  const FoodCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.itemId,
    required this.isFavorite,
    required this.onAdd,
    this.onFavoriteToggle,
    this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteFoodController favoriteController =
        Get.find<FavoriteFoodController>();
    final OrderController cartController = Get.find<OrderController>();

    return Container(
      // Remove width and height here — let GridView control it
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important: don't force max height
        children: [
          // Image with favorite icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imagePath,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              // Positioned(
              //   top: 8,
              //   right: 8,
              //   child: Obx(
              //     () => InkWell(
              //       onTap: () async {
              //         try {
              //           final newValue = !isFavorite.value;
              //           isFavorite.value = newValue; // Optimistic update
              //
              //           if (newValue) {
              //             await favoriteController.favorite(itemId);
              //             onFavoriteToggle?.call(true);
              //           } else {
              //             await favoriteController.removeFavorite(itemId);
              //             onFavoriteToggle?.call(false);
              //           }
              //         } catch (e) {
              //           isFavorite.value = !isFavorite.value; // Revert on error
              //           DPrint.log("Favorite toggle error: $e");
              //         }
              //       },
              //       child: CircleAvatar(
              //         radius: 12,
              //         backgroundColor: const Color(0xBD3C84F0),
              //         child: Icon(
              //           isFavorite.value
              //               ? Icons.favorite
              //               : Icons.favorite_border,
              //           color: isFavorite.value ? Colors.white : Colors.grey,
              //           size: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 8),

          // Title, Description, Rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    Obx(() {
                      final isItemFavorite = favoriteController.isFavoriteItem(
                        itemId,
                      );

                      return InkWell(
                        onTap: () async {
                          final currentValue = favoriteController
                              .isFavoriteItem(itemId);
                          final newValue = !currentValue;
                          try {
                            favoriteController.setFavoriteState(
                              itemId,
                              newValue,
                            );
                            isFavorite.value = newValue;

                            bool success = false;
                            if (newValue) {
                              success = await favoriteController.favorite(
                                itemId,
                              );
                              if (success) onFavoriteToggle?.call(true);
                            } else {
                              success = await favoriteController.removeFavorite(
                                itemId,
                              );
                              if (success) onFavoriteToggle?.call(false);
                            }

                            if (!success) {
                              favoriteController.setFavoriteState(
                                itemId,
                                currentValue,
                              );
                              isFavorite.value = currentValue;
                            }
                          } catch (e) {
                            favoriteController.setFavoriteState(
                              itemId,
                              currentValue,
                            );
                            isFavorite.value = currentValue;
                            DPrint.log("Favorite toggle error: $e");
                          }
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xBD3C84F0),
                          child: Icon(
                            isItemFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 9),

                // Stars + Review Count in ONE Row
                if (rating != null && rating! > 0)
                  Row(
                    children: [
                      // 5 Stars
                      ...List.generate(5, (index) {
                        double starValue = index + 1.0;
                        if (rating! >= starValue) {
                          return const Icon(
                            Icons.star,
                            color: Color(0xFF7F3615),
                            size: 14,
                          );
                        } else if (rating! >= starValue - 0.5) {
                          return const Icon(
                            Icons.star_half,
                            color: Color(0xFF7F3615),
                            size: 14,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Color(0xFF7F3615),
                            size: 14,
                          );
                        }
                      }),

                      const SizedBox(width: 8),

                      // Inside the Row, replace the current Text widget with this:
                      Text(
                        '(${reviewCount ?? 0})',
                        // Explicitly convert int to String
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          //const Spacer(), // Pushes price + button to bottom
          // Price + add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Obx(() {
                      final quantity = cartController.getItemQuantity(itemId);
                      if (quantity > 0) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  cartController.removeOneItemFromCart(itemId),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFFE0E0E0),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF7F3615),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    InkWell(
                      onTap: onAdd,
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFF0066FF),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
