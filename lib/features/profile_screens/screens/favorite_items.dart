import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../home/widgets/popular_items.dart';

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
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    // Dynamic sizing
    double font(double v) => v * (width / 390); // 390 is iPhone 12 width baseline

    // Determine grid count based on screen width
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
            padding: EdgeInsets.only(bottom: width * 0.04, top: height * 0.02),
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
              final items = _favoriteFoodController.favoriteItems;

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

              return GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  mainAxisExtent: height * 0.3, // dynamic card height
                  crossAxisSpacing: width * 0.035,
                  mainAxisSpacing: height * 0.02,
                ),
                itemBuilder: (_, index) {
                  final food = items[index].item;

                  return FoodCard(
                    imagePath: food.image,
                    title: food.name,
                    price: food.price.toString(),
                    itemId: food.id,
                    isFavorite: true.obs,
                    description: '',
                    onAdd: () => print('Add ${food.name}'),
                    onFavoriteToggle: (val) async {
                      if (!val) {
                        items.removeAt(index); // instantly update UI
                        await _favoriteController.removeFavorite(food.id);
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
