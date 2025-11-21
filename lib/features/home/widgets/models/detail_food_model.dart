class FoodModel {
  final String id;
  final String title;
  final String description;
  final String image; // network or asset
  final String price; // network or asset
  final List<String> ingredients;

  FoodModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.ingredients,
  });
}
