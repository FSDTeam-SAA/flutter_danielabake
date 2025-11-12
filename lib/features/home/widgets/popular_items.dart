import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final VoidCallback onAdd;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const FoodCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.onAdd,
    required this.onFavorite,
    this.isFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      height: 262,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2), // light peach background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image with favorite icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: onFavorite,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xBD3C84F0), // BD = 74% opacity,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.white : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),


          SizedBox(height: 25,),

          // price + add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                InkWell(
                  onTap: onAdd,
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF0066FF),
                    child: Icon(Icons.add, color: Colors.white, size: 20,),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
