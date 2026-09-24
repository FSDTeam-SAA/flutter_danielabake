import 'get_item_ingredient.dart';

class GetItemByCategoryIdResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<FoodItem> items;

  GetItemByCategoryIdResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.items,
  });

  factory GetItemByCategoryIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetItemByCategoryIdResponseModel(
      total: json["total"],
      page: json["page"],
      pages: json["pages"],
      items: List<FoodItem>.from(
        json["items"].map((x) => FoodItem.fromJson(x)),
      ),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final Category category;
  final List<ItemIngredient> ingredients;
  final double rating;
  final int reviewsCount;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.images,
    required this.category,
    required this.ingredients,
    required this.rating,
    required this.reviewsCount,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      price: (json["price"] as num).toDouble(),
      image: json["image"],
      images: List<String>.from(json["images"] ?? []),
      category: Category.fromJson(json["category"]),
      ingredients: List<ItemIngredient>.from(
        json["ingredients"].map((x) => ItemIngredient.fromJson(x)),
      ),
      rating: (json["rating"] as num).toDouble(),
      reviewsCount: json["reviewsCount"],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json["_id"], name: json["name"], image: json["image"]);
  }
}

// class ItemIngredient {
//   final String name;
//   final bool isAllergen;
//   final String id;
//   final String? image;
//
//   ItemIngredient({
//     required this.name,
//     required this.isAllergen,
//     required this.id,
//     this.image,
//   });
//
//   factory ItemIngredient.fromJson(Map<String, dynamic> json) {
//     return ItemIngredient(
//       name: json['name'],
//       isAllergen: json['isAllergen'],
//       id: json['_id'],
//       image: json['image'],
//     );
//   }
// }
