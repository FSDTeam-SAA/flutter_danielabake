import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../widgets/favorite_food_cart.dart';

class FavoriteItems extends StatefulWidget {
  const FavoriteItems({super.key});

  @override
  State<FavoriteItems> createState() => _FavoriteItemsState();
}

class _FavoriteItemsState extends State<FavoriteItems> {
  final _favoriteFoodController = Get.put(FavoriteFoodController());

  @override
  void initState() {
    super.initState();
    _favoriteFoodController.fetchFavoriteItem(); // Already called in onInit, but safe to call again
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    double font(double v) => v * (width / 390);

    int gridCount = width > 900
        ? 4
        : width > 650
        ? 3
        : 2;

    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorite Items',
          style: TextStyle(
            fontSize: font(17),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.only(bottom: width * 0.04, top: height * 0.02, left: 16),
            child: Text(
              'Your All Favorite Items',
              style: TextStyle(
                color: Colors.black,
                fontSize: font(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final isLoading = _favoriteFoodController.isLoading.value;
              final items = _favoriteFoodController.favoriteItems;

              // Show shimmer when loading
              if (isLoading) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    //mainAxisExtent: height * 0.4,
                    crossAxisSpacing: width * 0.015,
                    mainAxisSpacing: height * 0.02,
                  ),
                  itemCount: 6, // Show 6 shimmer cards as placeholder
                  itemBuilder: (context, index) => _buildShimmerCard(),
                );
              }

              // Show empty state
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No favorite items found.',
                    style: TextStyle(
                      fontSize: font(13),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              // Show real data
              return GridView.builder(
                //padding: const EdgeInsets.all(16),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  mainAxisExtent: 255,
                  crossAxisSpacing: width * 0.025,
                  mainAxisSpacing: width * 0.025,
                ),
                itemBuilder: (_, index) {
                  final food = items[index].item;

                  return FavoriteFoodCard(
                    imagePath: food!.image,
                    title: food.name,
                    price: food.price.toString(),
                    itemId: food.id,
                    isFavorite: true.obs,
                    description: food.description,
                    onAdd: () => print('Add ${food.name}'),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Build a single shimmer card (same size as real FoodCard)
  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFDEB8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 Item Image Placeholder
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEAD1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.image,
                size: 40,
                color: Colors.white70,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🏷 Item Name
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAD1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: 8),

                /// 📝 Description
                Container(
                  height: 13,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAD1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 💰 Price
                    Container(
                      height: 18,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEAD1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    Row(
                      children: [
                        /// ❤️ Favorite Icon
                        Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEAD1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// 🛒 Add to Cart Button
                        Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEAD1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
