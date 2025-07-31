class Product {
  final String id;
  final String name;
  final double price;
  final String countryName;
  final String image;
  final String categoryId;
  final String description;
  final String moneyCode;
  final String createdAt;
  final String updatedAt;
  final ProductCategory category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.countryName,
    required this.image,
    required this.categoryId,
    required this.description,
    required this.moneyCode,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      countryName: json['countryName'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['categoryId'] ?? '',
      description: json['description'] ?? '',
      moneyCode: json['moneyCode'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      category: ProductCategory.fromJson(json['category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'countryName': countryName,
      'image': image,
      'categoryId': categoryId,
      'description': description,
      'moneyCode': moneyCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category.toJson(),
    };
  }
}

class ProductCategory {
  final String id;
  final String title;

  ProductCategory({
    required this.id,
    required this.title,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
