class ProductModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String image;
  final String categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.categoryId,
  });

  // Factory method to create a Product from a JSON object (like from Firestore)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      price: (json['price']?.toDouble() ?? 0.0),
      rating: (json['rating']?.toDouble() ?? 0.0),
      image: json['image'] ?? '',
      categoryId: json['category_id'] ?? '',
    );
  }

  // Convert a Product object to JSON (useful for saving back to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'image': image,
      'category_id': categoryId,
    };
  }
}
