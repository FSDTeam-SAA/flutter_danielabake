import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../home/widgets/popular_items.dart'; // make sure path is correct

class FavoriteItems extends StatefulWidget {
  const FavoriteItems({super.key});

  @override
  State<FavoriteItems> createState() => _FavoriteItemsState();
}

class _FavoriteItemsState extends State<FavoriteItems> {
  final _favoriteFoodController = Get.put(ProfileController());
  final _favoriteController = Get.put(FavoriteFoodController());

  @override
  void initState() {
    super.initState();
    _favoriteFoodController.fetchFavoriteItem();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your all Favorite Items',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = _favoriteFoodController.favoriteItems;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No favorite items found.'),
                );
              }

              return GridView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, index) {
                  final item = items[index].item;
                  final isFavorite = true.obs;

                  return FoodCard(
                    imagePath: item.image,
                    title: item.name,
                    price: item.price.toString(),
                    itemId: item.id,
                    isFavorite: isFavorite,
                    onAdd: () => print('Add ${item.name}'),
                    onFavoriteToggle: (newValue) async {
                      if (!newValue) {
                        // Remove from the list immediately
                        items.removeAt(index);

                        // Call backend
                        await _favoriteController.removeFavorite(item.id);
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
