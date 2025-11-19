import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/popular_items.dart';


class AllPopularItems extends StatefulWidget {
  const AllPopularItems({super.key});

  @override
  State<AllPopularItems> createState() => _AllPopularItemsState();
}

class _AllPopularItemsState extends State<AllPopularItems> {
  final _homeController = Get.find<HomeController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Obx(() {
        final data = _homeController.popularItem.value;

        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = data.items;

        return GridView.builder(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 270,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              // Create a reactive favorite variable
              final isFavorite = false.obs;

              return FoodCard(
                imagePath: item.image,
                title: item.name,
                price: item.price.toString(),
                itemId: item.id,
                isFavorite: isFavorite,
                onAdd: () {
                  print("Add ${item.name}");
                },
              );
            }
        );
      }),
    );
  }
}
