import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../widgets/category_card.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final response = controller.category.value;

      if (response == null) {
        return const SizedBox();
      }

      final categories = response.data; // List<Category>

      return SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,       //FIXED
          //padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final cat = categories[index];     //FIXED

            return CategoryCard(
              title: cat.name,
              imageUrl: cat.image,
              bgColor: Colors.pink.shade100,   // তোমার bgColor যেহেতু নেই backend এ
            );
          },
        ),
      );
    });
  }
}
