class FavoriteFoodResponseModel {
  final String id;
  final String user;
  final String item;
  final String createdAt;
  final String updatedAt;
  final int v;

  FavoriteFoodResponseModel({
    required this.id,
    required this.user,
    required this.item,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FavoriteFoodResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteFoodResponseModel(
      id: json['_id'],
      user: json['user'],
      item: json['item'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
