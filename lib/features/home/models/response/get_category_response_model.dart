class GetCategoryResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<Category> data;

  GetCategoryResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.data,
  });

  factory GetCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryResponseModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      data: (json['data'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'pages': pages,
    'data': data.map((item) => item.toJson()).toList(),
  };
}

class Category {
  final String id;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'image': image,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
