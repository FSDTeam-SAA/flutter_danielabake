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

  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;
  final RxBool _isSearchExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    final double screenW = MediaQuery.of(context).size.width;

    // Responsive columns
    final int crossAxisCount = screenW > 700 ? 4 : screenW > 500 ? 3 : 2;

    return AppScaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Popular Items',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenW * 0.04),
            child: AppBarSearch(
              controller: _searchController,
              isExpanded: _isSearchExpanded,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _homeController.searchItem(value);
                  _isSearching.value = true;
                } else {
                  _isSearching.value = false;
                }
              },
              onClear: () {
                _searchController.clear();
                _isSearching.value = false;
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final bool searching = _isSearching.value;
          final items = searching
              ? _homeController.search.value?.items ?? []
              : _homeController.popularItem.value?.items ?? [];

          if (_homeController.isLoading.value && !searching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No items found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(
              vertical: screenH * 0.015,
              horizontal: screenW * 0.04,
            ),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: screenH * 0.30,
              crossAxisSpacing: screenW * 0.035,
              mainAxisSpacing: screenH * 0.02,
            ),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              final isFav = false.obs;

              return GestureDetector(
                onTap: () {
                  Get.to(() => FoodDetailScreen(
                    food: FoodModel(
                      title: item.name,
                      description: item.description,
                      image: item.image,
                      ingredients: item.ingredients.map((e) => e.name).toList(),
                      price: item.price.toString(),
                      id: item.id,
                    ),
                  ));
                },
                child: FoodCard(
                  imagePath: item.image,
                  title: item.name,
                  description: item.description,
                  price: item.price.toString(),
                  itemId: item.id,
                  isFavorite: isFav,
                  onAdd: () async {
                    try {
                      await _cartController.addCart(item.id, 1);
                      Get.snackbar('Success', '${item.name} added to cart');
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to add ${item.name}');
                    }
                  },
                  onFavoriteToggle: (value) async {
                    try {
                      if (value) {
                        await _favoriteFoodController.favorite(item.id);
                        isFav.value = true;
                      } else {
                        await _favoriteFoodController.removeFavorite(item.id);
                        isFav.value = false;
                      }
                    } catch (e) {
                      DPrint.log("Favorite Error: $e");
                    }
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
