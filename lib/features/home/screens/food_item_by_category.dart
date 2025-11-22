import 'dart:developer' as DPrint;

import 'package:danielabake/features/home/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/favorite_food_controller.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import 'food_details_screen.dart'; // <-- make sure path is correct

class FoodListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  FoodListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final _favoriteFoodController = Get.find<FavoriteFoodController>();
  final _cartController = Get.find<AddToCartController>();
  final controller = Get.put(CategoryController());
 // create controller if not exists
  @override
  Widget build(BuildContext context) {
    controller.fetchItems(widget.categoryId); // fetch API

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.specificItems.value == null ||
            controller.specificItems.value!.items.isEmpty) {
          return const Center(child: Text("No items found"));
        }

        final foods = controller.specificItems.value!.items;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: foods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final food = foods[index];

              // Reactive favorite variable
              final isFavorite = false.obs;

              return GestureDetector(
                onTap: () {
                  Get.to(() => FoodDetailScreen(
                    food: FoodModel(
                      title: food.name,
                      description: food.description,
                      image: food.image,
                      ingredients: food.ingredients
                          .map((e) => e.name)
                          .toList(), price: food.price.toString(), id: food.id,
                    ),
                  ));
                },
                child: FoodCard(
                  imagePath: food.image,
                  title: food.name,
                  description: food.description,
                  price: food.price.toString(),
                  itemId: food.id,
                  isFavorite: isFavorite,
                  onAdd: () async {
                    try {
                      await _cartController.addCart(food.id, 1);
                      Get.snackbar('Success', '${food.name} added to cart');
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to add ${food.name} to cart');
                    }
                  },
                  onFavoriteToggle: (newValue) async {
                    try {
                      if (newValue) {
                        await _favoriteFoodController.favorite(food.id);
                        isFavorite.value = true;
                      } else {
                        await _favoriteFoodController.removeFavorite(food.id);
                        isFavorite.value = false;
                      }
                    } catch (e) {
                      DPrint.log("Favorite toggle error: $e");
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
