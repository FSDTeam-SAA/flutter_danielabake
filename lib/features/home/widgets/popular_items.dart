import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as DPrint;

import '../controller/favorite_food_controller.dart';

class FoodCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String itemId;
  final RxBool isFavorite; // Observable
  final VoidCallback onAdd;
  final Future<void> Function(bool newValue)? onFavoriteToggle; // optional callback

  const FoodCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.itemId,
    required this.isFavorite,
    required this.onAdd,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteFoodController favoriteController = Get.find<FavoriteFoodController>();

    return Container(
      width: 158,
      height: 262,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() => InkWell(
                  onTap: () async {
                    try {
                      if (!isFavorite.value) {
                        // Add favorite
                        await favoriteController.favorite(itemId);
                        isFavorite.value = true; // update UI after success
                      } else {
                        // Remove favorite
                        await favoriteController.removeFavorite(itemId);
                        isFavorite.value = false; // update UI after success
                      }
                    } catch (e) {
                      DPrint.log("Favorite toggle error: $e");
                    }
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xBD3C84F0),
                    child: Icon(
                      isFavorite.value ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite.value ? Colors.white : Colors.grey,
                      size: 16,
                    ),
                  ),
                ))

              ),
            ],
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 25),

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
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
