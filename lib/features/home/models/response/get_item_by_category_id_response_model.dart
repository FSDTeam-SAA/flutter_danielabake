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
      items: List<FoodItem>.from(json["items"].map((x) => FoodItem.fromJson(x))),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final Category category;
  final List<Ingredient> ingredients;
  final double rating;
  final int reviewsCount;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
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
      category: Category.fromJson(json["category"]),
      ingredients: List<Ingredient>.from(
        json["ingredients"].map((x) => Ingredient.fromJson(x)),
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

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"],
      name: json["name"],
      image: json["image"],
    );
  }
}

class Ingredient {
  final String name;
  final bool isAllergen;

  Ingredient({
    required this.name,
    required this.isAllergen,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json["name"],
      isAllergen: json["isAllergen"],
    );
  }
}
