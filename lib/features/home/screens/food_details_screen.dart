import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:danielabake/features/Order_screen/screens/checkout2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../review_rating/controllers/rating_controller.dart';
import '../widgets/models/detail_food_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final _orderController = Get.find<OrderController>();
  final ratingController = Get.find<RatingController>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final RxInt selectedImageIndex = 0.obs;

  final PageController _pageController = PageController();

  final Rx<String?> currentUserId = Rx<String?>(null);
  final RxInt quantity = 0.obs;

  @override
  void initState() {
    super.initState();
    _initializeQuantity();
    ratingController.getReview(widget.food.id);
    _loadCurrentUserId(); // Fetch reviews
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // No setState needed anymore
  void _loadCurrentUserId() async {
    final userId = await _authStorageService.getUserId();
    currentUserId.value = userId!; // This automatically triggers rebuild in Obx
  }

  void _initializeQuantity() async {
    /// Fetch latest cart data always
    await _orderController.fetchCart();

    /// Find this item in cart
    final cartItem = _orderController.cart.value?.items.firstWhereOrNull(
      (i) => i.item?.id == widget.food.id,
    );

    quantity.value = cartItem?.quantity ?? 0;
  }

  List<String> get _galleryImages {
    final images = <String>[];

    void addImage(String? image) {
      final trimmedImage = image?.trim();
      if (trimmedImage != null &&
          trimmedImage.isNotEmpty &&
          !images.contains(trimmedImage)) {
        images.add(trimmedImage);
      }
    }

    addImage(widget.food.image);
    widget.food.images?.forEach(addImage);

    return images;
  }

  void _showGalleryImage(int index) {
    final galleryImages = _galleryImages;
    if (index < 0 || index >= galleryImages.length) return;

    selectedImageIndex.value = index;

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final galleryImages = _galleryImages;

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          color: const Color(0x2EFFB972),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.food.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _squareButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (quantity.value <= 0) return;

                            quantity.value--;
                            _orderController.removeOneItemFromCart(
                              widget.food.id,
                            );

                            /// refresh cart after removing
                            _orderController.fetchCart();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${quantity.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _squareButton(
                          icon: Icons.add,
                          onTap: () async {
                            /// call add API
                            final success = await _orderController.addCart(
                              widget.food.id,
                              1,
                            );

                            if (success) {
                              quantity.value++;

                              /// refresh cart after adding
                              _orderController.fetchCart();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                PrimaryButton(
                  text: 'Place Order',
                  key: const Key("food-details-screen"),
                  onSimplePressed: () {
                    if (quantity.value == 0) {
                      Get.snackbar(
                        'No Item Added',
                        'First add an item to place your order',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white24,
                        colorText: Colors.black,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 10,
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }
                    Get.to(() => Checkout2Screen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Food Image
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: galleryImages.isEmpty
                        ? const Center(child: Icon(Icons.image_not_supported))
                        : Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: galleryImages.length,
                                onPageChanged: (index) {
                                  selectedImageIndex.value = index;
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    galleryImages[index],
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                              if (galleryImages.length > 1) ...[
                                Positioned(
                                  left: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: _galleryNavButton(
                                      icon: Icons.chevron_left,
                                      onTap: () {
                                        final currentIndex =
                                            selectedImageIndex.value;
                                        final previousIndex = currentIndex == 0
                                            ? galleryImages.length - 1
                                            : currentIndex - 1;
                                        _showGalleryImage(previousIndex);
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: _galleryNavButton(
                                      icon: Icons.chevron_right,
                                      onTap: () {
                                        final currentIndex =
                                            selectedImageIndex.value;
                                        final nextIndex =
                                            (currentIndex + 1) %
                                            galleryImages.length;
                                        _showGalleryImage(nextIndex);
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Obx(
                                    () => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0x8C000000),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${selectedImageIndex.value + 1}/${galleryImages.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   left: 40,
                                //   right: 40,
                                //   bottom: 10,
                                //   child: Obx(
                                //     () => SingleChildScrollView(
                                //       scrollDirection: Axis.horizontal,
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: List.generate(
                                //           galleryImages.length,
                                //           (index) {
                                //             final isSelected =
                                //                 selectedImageIndex.value ==
                                //                 index;

                                //             return AnimatedContainer(
                                //               duration: const Duration(
                                //                 milliseconds: 200,
                                //               ),
                                //               margin:
                                //                   const EdgeInsets.symmetric(
                                //                     horizontal: 3,
                                //                   ),
                                //               width: isSelected ? 16 : 7,
                                //               height: 7,
                                //               decoration: BoxDecoration(
                                //                 color: isSelected
                                //                     ? const Color(0xFF1566CD)
                                //                     : const Color(0xBFFFFFFF),
                                //                 borderRadius:
                                //                     BorderRadius.circular(20),
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),

            /// Extra Food Images
            if (galleryImages.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: galleryImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final image = galleryImages[index];

                      return GestureDetector(
                        onTap: () {
                          _showGalleryImage(index);
                        },
                        child: Obx(
                          () => Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedImageIndex.value == index
                                    ? const Color(0x991566CD)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            /// Title & Description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.food.description,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            //add ingredients image and name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                children: widget.food.ingredients.map((ingredient) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Color(0x2EFFB972),
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          ingredient.image ?? '',
                          height: 45,
                          width: 45,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.fastfood, size: 30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ingredient.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // /// Ingredients Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Wrap(
            //     spacing: 10,
            //     runSpacing: 12,
            //     children: IngredientData.allIngredients
            //         .where(
            //           (item) => widget.food.ingredients.contains(item["name"]),
            //         )
            //         .map((item) {
            //           return Column(
            //             children: [
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(100),
            //                   color: const Color(0x2EFFB972),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(18.0),
            //                   child: SizedBox(
            //                     height: 40,
            //                     width: 40,
            //                     child: AppSvg(
            //                       asset: item["asset"]!,
            //                       width: 40,
            //                       height: 40,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 item["name"]!,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //             ],
            //           );
            //         })
            //         .toList(),
            //   ),
            // ),
            const SizedBox(height: 20),

            // Padding(
            //   padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Text('Ratings and Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            //           Text('(${widget.food.reviewsCount})')
            //         ],
            //       ),
            //       SizedBox(width: 30,),
            //
            //       if (widget.food.rating > 0)
            //         Row(
            //           children: [
            //             Text('${widget.food.rating}'),
            //             // 5 Stars
            //             ...List.generate(5, (index) {
            //               double starValue = index + 1.0;
            //               if (widget.food.rating >= starValue) {
            //                 return const Icon(
            //                   Icons.star,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               } else if (widget.food.rating >= starValue - 0.5) {
            //                 return const Icon(
            //                   Icons.star_half,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               } else {
            //                 return const Icon(
            //                   Icons.star_border,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               }
            //             }),
            //
            //           ],
            //         )
            //     ],
            //   ),
            // ),
            //
            // //here fetch the review and show in the screen
            // Obx(() {
            //   if (ratingController.isLoading.value && ratingController.review.isEmpty) {
            //     return const Center(child: CircularProgressIndicator());
            //   }
            //
            //   if (ratingController.review.isEmpty) {
            //     return const Padding(
            //       padding: EdgeInsets.all(20),
            //       child: Text("No reviews yet. Be the first to review!", style: TextStyle(color: Colors.grey)),
            //     );
            //   }
            //
            //   return ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: ratingController.review.length,
            //     itemBuilder: (context, index) {
            //       final rev = ratingController.review[index];
            //       DPrint.log(rev.id);
            //       //final userId =  _authStorageService.getUserId();
            //       // Now this condition is properly typed as bool
            //       final bool isOwnReview = currentUserId.value != null && currentUserId.value == rev.user.id;
            //
            //       return ReviewCard(
            //       review: rev,
            //       onDelete: isOwnReview
            //       ? () => ratingController.deleteReview(rev.id)
            //       : null,
            //       );
            //     },
            //   );
            // })
          ],
        ),
      ),
    );
  }

  Widget _squareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF4C8FFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  Widget _galleryNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0x61000000),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
