import 'dart:ui';

class CategoryModel {
  final String title;
  final String imageUrl;
  final Color bgColor;

  CategoryModel({
    required this.title,
    required this.imageUrl,
    required this.bgColor,
  });

  // API থেকে map convert
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      title: json['title'],
      imageUrl: json['image'],
      bgColor: Color(int.parse(json['bgColor'])), // Example: "0xFFFEEFEF"
    );
  }
}
