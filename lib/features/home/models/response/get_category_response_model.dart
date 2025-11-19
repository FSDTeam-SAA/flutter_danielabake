class GetCategoryResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<CategoryItem> data;

  GetCategoryResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.data,
  });

  factory GetCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryResponseModel(
      total: json["total"],
      page: json["page"],
      pages: json["pages"],
      data: (json["data"] as List)
          .map((e) => CategoryItem.fromJson(e))
          .toList(),
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String image;
  final int bgColor;
  final String createdAt;
  final String updatedAt;

  CategoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.bgColor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    int parseBgColor(dynamic value) {
      if (value == null) return 0xFFFFFFFF; // fallback white

      String colorStr = value.toString().trim();

      // Remove # if present
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.substring(1);
      }

      // Add 0x prefix if not already there
      if (!colorStr.startsWith('0x') && !colorStr.startsWith('0X')) {
        colorStr = '0x$colorStr';
      }

      // If the string is like "FF5733" (without alpha), add full opacity
      if (colorStr.length == 8) { // #RRGGBB -> 0xRRGGBB (no alpha)
        colorStr = '0xFF${colorStr.substring(2)}'; // add full opacity
      }

      return int.tryParse(colorStr) ?? 0xFFFFFFFF; // fallback to white if parsing fails
    }

    return CategoryItem(
      id: json["_id"],
      name: json["name"],
      image: json["image"],
      bgColor: parseBgColor(json["bgColor"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
