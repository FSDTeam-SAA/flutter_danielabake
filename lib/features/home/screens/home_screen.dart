import 'dart:developer' as DPrint;

import 'package:danielabake/core/common/widgets/abbbar_search.dart';
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
import 'package:flutx_core/core/theme/gap.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/cart.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/grid_layout.dart';
import '../widgets/popular_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();
  final _cartController = Get.find<AddToCartController>();

  @override
  Widget build(BuildContext context) {
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
                AppBarSearch(),
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
              Gap.h20,
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: Image.asset(Images.discount, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              TextWithViewAllButton(
                  text: 'Select by Category',
                  onTap: () {
                    Get.to(() => AllCategoryScreen());
                  }),
              CategorySection(),
              const SizedBox(height: 24),
              TextWithViewAllButton(
                  text: 'Popular Item',
                  onTap: () {
                    Get.to(() => AllPopularItems());
                  }),
              const SizedBox(height: 12),

              // Popular items grid
              // Popular items grid
              Obx(() {
                final data = _homeController.popularItem.value;

                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridLayout(
                  mainAxisExtent: 260,
                  itemCount: data.items.length,
                  itemBuilder: (_, index) {
                    final item = data.items[index];

                    // Reactive favorite state (can be updated from API later)
                    final isFavorite = false.obs;

                    return FoodCard(
                      imagePath: item.image,
                      title: item.name,
                      price: item.price.toString(),
                      itemId: item.id,
                      isFavorite: isFavorite,
                      // Add to cart
                      onAdd: () async {
                        try {
                          await _cartController.register(item.id, 1); // default quantity 1
                          Get.snackbar('Success', '${item.name} added to cart');
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to add ${item.name} to cart');
                        }
                      },
                      // Favorite toggle
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
                    );
                  },
                );
              }),


              const SizedBox(height: 24),
              // ElevatedButton(
              //     onPressed: () {
              //       _authController.logout();
              //     },
              //     child: const Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
