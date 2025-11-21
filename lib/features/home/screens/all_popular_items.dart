import 'dart:developer' as DPrint;

import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import 'food_details_screen.dart';

class AllPopularItems extends StatefulWidget {
  const AllPopularItems({super.key});

  @override
  State<AllPopularItems> createState() => _AllPopularItemsState();
}

class _AllPopularItemsState extends State<AllPopularItems> {
  final _homeController = Get.find<HomeController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();
  final _cartController = Get.find<AddToCartController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive crossAxisCount for tablets/large screens
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    // Responsive padding
    final horizontalPadding = screenWidth * 0.03;

    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Popular Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: AppBarSearch(),
          )
        ],
      ),
      body: Obx(() {
        final data = _homeController.popularItem.value;

        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = data.items;

        return GridView.builder(
          padding: EdgeInsets.only(
            top: screenHeight * 0.01,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: screenHeight * 0.30, // Responsive height
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenHeight * 0.02,
          ),
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];

            // Reactive favorite variable
            final isFavorite = false.obs;

            return GestureDetector(
              onTap: () {
                Get.to(() => FoodDetailScreen(
                  food: FoodModel(
                    title: item.name,
                    description: item.description,
                    image: item.image,
                    ingredients: item.ingredients
                        .map((e) => e.name)
                        .toList(), price: item.price.toString(), id: item.id,
                  ),
                ));
              },
              child: FoodCard(
                imagePath: item.image,
                title: item.name,
                description: item.description,
                price: item.price.toString(),
                itemId: item.id,
                isFavorite: isFavorite,
                onAdd: () async {
                  try {
                    await _cartController.addCart(item.id, 1);
                    Get.snackbar('Success', '${item.name} added to cart');
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to add ${item.name} to cart');
                  }
                },
                onFavoriteToggle: (newValue) async {
                  try {
                    if (newValue) {
                      await _favoriteFoodController.favorite(item.id);
                      isFavorite.value = true;
                    } else {
                      await _favoriteFoodController.removeFavorite(item.id);
                      isFavorite.value = false;
                    }
                  } catch (e) {
                    DPrint.log("Favorite toggle error: $e");
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}
