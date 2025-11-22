import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../widgets/category_card.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import 'food_item_by_category.dart';

class AllCategoryScreen extends StatelessWidget {
  const AllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        // Loader
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Response null হলে
        final response = controller.category.value;
        if (response == null) {
          return const Center(child: Text("No categories found"));
        }

        final categories = response.data; // List<Category>

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'See all the available categories',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // GRID VIEW
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,       // must remain 4
                    childAspectRatio: 0.7,  // makes cards bigger vertically
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                itemBuilder: (context, index) {
                  final cat = categories[index];

                  return CategoryCard(
                    title: cat.name,
                    imageUrl: cat.image,
                    bgColor: Colors.pink.shade100,
                    onTap: () {
                      Get.to(() => FoodListScreen(
                        categoryId: cat.id,
                        categoryName: cat.name,
                      ));
                    },
                  );

                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
