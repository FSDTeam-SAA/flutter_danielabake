import 'dart:developer' as DPrint;
import 'package:danielabake/core/common/widgets/appbar_text.dart';
import 'package:danielabake/core/common/widgets/text_with_view_all_button.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:danielabake/features/home/screens/all_category_screen.dart';
import 'package:danielabake/features/home/screens/all_popular_items.dart';
import 'package:danielabake/features/home/widgets/category_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';

import '../../../core/common/widgets/cart.dart';
import '../../Order_screen/controller/order_controller.dart';
import '../widgets/dropdown_with_button.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import '../widgets/responsive.dart';
import '../widgets/weekly_menu_slider.dart';
import 'food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.find<HomeController>();
  final _cartController = Get.find<OrderController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();

  final RxString selectedDay = 'Today'.obs;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favoriteFoodController.fetchFavoriteItem();
      _homeController.fetchPopularItem(mapDayForApi('Today'));
      _homeController.fetchWeeklyMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    int gridCount = width > 900
        ? 4
        : width > 650
        ? 3
        : 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarText(text: 'Place an order'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(children: [const SizedBox(width: 16), const Cart()]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: rw(context, 0.03)),
              Text(
                'Weekly Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              //Add slider here
              SizedBox(height: rw(context, 0.02)),

              const WeeklyMenuSlider(),

              SizedBox(height: rw(context, 0.06)),

              TextWithViewAllButton(
                text: 'Select by Category',
                onTap: () => Get.to(() => AllCategoryScreen()),
              ),
              CategorySection(),

              SizedBox(height: rw(context, 0.05)),

              DropdownWithButton(
                onDayChanged: (value) {
                  if (value != null) {
                    selectedDay.value = value; // Track the day name
                    final apiDay = mapDayForApi(value);
                    _homeController.fetchPopularItem(apiDay);
                  }
                },
                onTap: () => Get.to(() => AllPopularItems()),
              ),

              // TextWithViewAllButton(
              //           text: 'Today\'s Items',
              //           onTap: () => Get.to(() => AllPopularItems()),
              //         ),
              SizedBox(height: rw(context, 0.03)),

              /// Popular Items Grid
              // Obx(() {
              //   final selected = selectedDay.value; // "Today", "Monday", etc.
              //
              //   // Get today's full name
              //   String todayName = _controller.days[DateTime.now().weekday - 1];
              //
              //   // Determine which day to show
              //   final dayToShow = selected == 'Today' ? todayName : selected;
              //
              //   // Get items for that day
              //   final filteredItems = _controller.weeklyMenuByDay[dayToShow] ?? [];
              //
              //   if (filteredItems.isEmpty) {
              //     return const Center(child: Text("No items available"));
              //   }
              //
              //   return GridView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     padding: const EdgeInsets.symmetric(horizontal: 4),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: gridCount,
              //       mainAxisExtent: 255,
              //       crossAxisSpacing: width * 0.025,
              //       mainAxisSpacing: width * 0.025,
              //     ),
              //     itemCount: filteredItems.length,
              //     itemBuilder: (_, index) {
              //       final item = filteredItems[index];
              //       final isFavorite = false.obs;
              //
              //       return GestureDetector(
              //         onTap: () {
              //           Get.to(() => FoodDetailScreen(
              //             food: FoodModel(
              //               title: item.name,
              //               description: item.description,
              //               image: item.image,
              //               ingredients: item.ingredients,
              //               price: item.price.toString(),
              //               id: item.id,
              //               images: item.images,
              //             ),
              //           ));
              //         },
              //         child: FoodCard(
              //           imagePath: item.image,
              //           title: item.name,
              //           description: item.description,
              //           price: item.price.toString(),
              //           itemId: item.id,
              //           isFavorite: isFavorite,
              //           onAdd: () async {
              //             try {
              //               await _cartController.addCart(item.id, 1);
              //               Get.snackbar(
              //                 'Success',
              //                 '${item.name} added to cart',
              //                 backgroundColor: Colors.green,
              //                 colorText: Colors.white,
              //                 margin: const EdgeInsets.all(12),
              //                 duration: const Duration(seconds: 2),
              //               );
              //             } catch (e) {
              //               Get.snackbar('Error', 'Failed to add ${item.name} to cart');
              //             }
              //           },
              //           onFavoriteToggle: (newValue) async {
              //             try {
              //               if (newValue) {
              //                 await _favoriteFoodController.favorite(item.id);
              //                 isFavorite.value = true;
              //               } else {
              //                 await _favoriteFoodController.removeFavorite(item.id);
              //                 isFavorite.value = false;
              //               }
              //             } catch (e) {
              //               DPrint.log("Favorite toggle error: $e");
              //             }
              //           },
              //           rating: item.rating,
              //           reviewCount: item.reviewsCount,
              //         ),
              //       );
              //     },
              //   );
              // }),

              /// Popular Items Grid
              Obx(() {
                final data = _homeController.popularItem.value;

                if (_homeController.isLoading.value || data == null) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      mainAxisExtent: 255,
                      crossAxisSpacing: width * 0.025,
                      mainAxisSpacing: width * 0.025,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  );
                }

                if (data.items.isEmpty) {
                  final day = selectedDay.value == 'Today'
                      ? DropdownWithButton.weekdays[DateTime.now().weekday - 1]
                      : selectedDay.value;

                  String message = "No items available";
                  if (day == 'Saturday') {
                    message = "No item available on saturday";
                  } else if (day == 'Sunday') {
                    message = "No items available on sunday";
                  }

                  return Center(child: Text(message));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  // ← Required #1
                  physics: const NeverScrollableScrollPhysics(),
                  // ← Required #2 (disable inner scroll)
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  // optional, looks better
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    mainAxisExtent: 255,
                    crossAxisSpacing: width * 0.025,
                    mainAxisSpacing: width * 0.025,
                  ),
                  itemCount: data.items.length,
                  itemBuilder: (_, index) {
                    final item = data.items[index];
                    final isFavorite = _favoriteFoodController
                        .isFavoriteItem(item.id)
                        .obs;

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => FoodDetailScreen(
                            food: FoodModel(
                              title: item.name,
                              description: item.description,
                              image: item.image,
                              ingredients: item.ingredients,
                              price: item.price.toString(),
                              id: item.id,
                              images: item.images,
                            ),
                          ),
                        );
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
                            final success = await _cartController.addCart(
                              item.id,
                              1,
                            );
                            if (success) {
                              // Get.snackbar(
                              //   'Success',
                              //   '${item.name} added to cart',
                              //   backgroundColor: Colors.green,
                              //   colorText: Colors.white,
                              //   margin: const EdgeInsets.all(12),
                              //   duration: const Duration(seconds: 2),
                              // );
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to add ${item.name} to cart',
                            );
                          }
                        },
                        onFavoriteToggle: (newValue) async {
                          // Logic handled inside FoodCard
                        },
                        rating: item.rating,
                        reviewCount: item.reviewsCount,
                      ),
                    );
                  },
                );
              }),

              //SizedBox(height: rw(context, 0.05)),
            ],
          ),
        ),
      ),
    );
  }

  String mapDayForApi(String day) {
    final now = DateTime.now();

    if (day == 'Today') {
      return _weekdayToApi(now.weekday);
    }

    return _weekdayNameToApi(day);
  }

  String _weekdayToApi(int weekday) {
    const map = {
      1: 'mon',
      2: 'tue',
      3: 'wed',
      4: 'thu',
      5: 'fri',
      6: 'sat',
      7: 'sun',
    };
    return map[weekday]!;
  }

  String _weekdayNameToApi(String name) {
    const map = {
      'Monday': 'mon',
      'Tuesday': 'tue',
      'Wednesday': 'wed',
      'Thursday': 'thu',
      'Friday': 'fri',
      'Saturday': 'sat',
      'Sunday': 'sun',
    };
    return map[name]!;
  }

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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.white70),
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
