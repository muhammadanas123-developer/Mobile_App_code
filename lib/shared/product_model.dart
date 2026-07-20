class ProductModel {
  final String id;
  final String brandName;
  final String productName;
  final double price;
  final String description;
  final double rating;
  final String imageUrl;
  final String category;

  const ProductModel({
    required this.id,
    required this.brandName,
    required this.productName,
    required this.price,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      brandName: json['brandName'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandName': brandName,
      'productName': productName,
      'price': price,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}