import 'package:danielabake/features/home/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Order_screen/controller/order_controller.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import 'food_details_screen.dart'; // <-- make sure path is correct

class FoodListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const FoodListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final _cartController = Get.find<OrderController>();
  final controller = Get.put(CategoryController());
  // create controller if not exists
  @override
  void initState() {
    super.initState();
    // Fetch items with a high limit to show all available items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchItems(widget.categoryId, limit: 1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    int gridCount = width > 900
        ? 4
        : width > 650
        ? 3
        : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              mainAxisExtent: 255,
              crossAxisSpacing: width * 0.035,
              mainAxisSpacing: height * 0.02,
            ),
            itemBuilder: (context, index) {
              final food = foods[index];

              // Reactive favorite variable
              final isFavorite = false.obs;

              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => FoodDetailScreen(
                      food: FoodModel(
                        title: food.name,
                        description: food.description,
                        image: food.image,
                        ingredients: food.ingredients,
                        price: food.price.toString(),
                        id: food.id,
                        images: food.images,
                        //rating: food.rating, reviewsCount: food.reviewsCount,
                      ),
                    ),
                  );
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
                      final success = await _cartController.addCart(food.id, 1);
                      if (success) {
                        //Get.snackbar('Success', '${food.name} added to cart');
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to add ${food.name} to cart',
                      );
                    }
                  },
                  onFavoriteToggle: (newValue) async {
                    // Logic handled inside FoodCard
                  },
                  rating: food.rating,
                  reviewCount: food.reviewsCount,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
