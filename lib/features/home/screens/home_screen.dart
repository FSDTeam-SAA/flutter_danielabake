import 'dart:developer' as DPrint;
import 'package:danielabake/core/common/widgets/appbar_text.dart';
import 'package:danielabake/core/common/widgets/text_with_view_all_button.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/features/home/controller/cart_controller.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:danielabake/features/home/screens/all_category_screen.dart';
import 'package:danielabake/features/home/screens/all_popular_items.dart';
import 'package:danielabake/features/home/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/cart.dart';
import '../widgets/grid_layout.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import 'food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.find<HomeController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();
  final _cartController = Get.find<AddToCartController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarText(text: 'Place an order'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Cart(),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              /// 🔥 Responsive Discount Banner
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: screenHeight * 0.24, // Responsive height
                  width: double.infinity,
                  child: Image.asset(
                    Images.discount,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              TextWithViewAllButton(
                  text: 'Select by Category',
                  onTap: () {
                    Get.to(() => AllCategoryScreen());
                  }),
              CategorySection(),

              SizedBox(height: screenHeight * 0.03),

              TextWithViewAllButton(
                  text: 'Popular Item',
                  onTap: () {
                    Get.to(() => AllPopularItems());
                  }),

              SizedBox(height: screenHeight * 0.015),

              // Popular items grid
              Obx(() {
                final data = _homeController.popularItem.value;

                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridLayout(
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.30, // smaller height
                  itemCount: data.items.length,
                  itemBuilder: (_, index) {
                    final item = data.items[index];
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
                      )
                    );
                  },
                );
              }),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
