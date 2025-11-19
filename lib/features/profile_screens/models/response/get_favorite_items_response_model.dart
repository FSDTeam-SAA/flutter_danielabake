class GetFavoriteItemsResponseModel {
  final String id;
  final String user;
  final FavoriteItem item;
  final String createdAt;
  final String updatedAt;
  final int v;

  GetFavoriteItemsResponseModel({
    required this.id,
    required this.user,
    required this.item,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory GetFavoriteItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetFavoriteItemsResponseModel(
      id: json['_id'],
      user: json['user'],
      item: FavoriteItem.fromJson(json['item']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'],
    );
  }
}
