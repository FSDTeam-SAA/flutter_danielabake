class SearchResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<ProductItem> items;

  SearchResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.items,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      items: List<ProductItem>.from(
          json['items'].map((item) => ProductItem.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'pages': pages,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final Category category;
  final List<Ingredient> ingredients;
  final double rating;
  final int reviewsCount;

  ProductItem({
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

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: Category.fromJson(json['category']),
      ingredients: List<Ingredient>.from(
          json['ingredients'].map((i) => Ingredient.fromJson(i))),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category.toJson(),
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}

class Ingredient {
  final String id;
  final String name;
  final bool isAllergen;

  Ingredient({required this.id, required this.name, required this.isAllergen});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id'],
      name: json['name'],
      isAllergen: json['isAllergen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'isAllergen': isAllergen,
    };
  }
}
