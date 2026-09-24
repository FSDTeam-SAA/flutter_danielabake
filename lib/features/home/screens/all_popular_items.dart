import 'dart:developer' as DPrint;
import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Order_screen/controller/order_controller.dart';
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
  final _cartController = Get.find<OrderController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxBool _isSearching = false.obs;
  final RxBool _isSearchExpanded = false.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favoriteFoodController.fetchFavoriteItem();
      _homeController.fetchAllPopularItem();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isSearching.value) {
        _homeController.fetchAllPopularItem(isRefresh: false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    final double screenW = MediaQuery.of(context).size.width;

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
        centerTitle: true,
        elevation: 0,
        title: Obx(
          () => _isSearchExpanded.value
              ? const SizedBox() // Hide title when searching
              : const Text(
                  'All Available Items',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
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
                _isSearchExpanded.value = false; // collapse
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
              : _homeController.allPopularItem.value?.items ?? [];

          DPrint.log(
            'All Popular Items count: ${items.length}, Searching: $searching, Loading: ${_homeController.isLoading.value}',
          );

          if (_homeController.isLoading.value && !searching) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                mainAxisExtent: 255,
                crossAxisSpacing: width * 0.025,
                mainAxisSpacing: width * 0.025,
              ),
              itemCount: 8,
              itemBuilder: (context, index) => _buildShimmerCard(),
            );
          }

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No items found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  //padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    mainAxisExtent: 255,
                    crossAxisSpacing: width * 0.025,
                    mainAxisSpacing: width * 0.025,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final isFav = _favoriteFoodController
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
                              //rating: item.rating, reviewsCount: item.reviewsCount,
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
                        isFavorite: isFav,
                        onAdd: () async {
                          try {
                            final success = await _cartController.addCart(
                              item.id,
                              1,
                            );
                            if (success) {
                              // Get.snackbar(
                              //   "Success",
                              //   '${item.name} added to cart',
                              //   backgroundColor: Colors.green,
                              //   colorText: Colors.white,
                              //   snackPosition: SnackPosition.BOTTOM,
                              //   margin: const EdgeInsets.all(12),
                              //   duration: const Duration(seconds: 2),
                              // );
                            }
                          } catch (e) {
                            Get.snackbar('Error', 'Failed to add ${item.name}');
                          }
                        },
                        onFavoriteToggle: (value) async {
                          // Logic handled inside FoodCard
                        },
                        rating: item.rating,
                        reviewCount: item.reviewsCount,
                      ),
                    );
                  },
                ),
              ),
              if (_homeController.isLoadMore.value)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ),
    );
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
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAD1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
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
