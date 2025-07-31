// lib/models/enhanced_product_model.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String countryName;
  final String image;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;

  // New user field
  final User? user;

  // Enhanced fields for localization
  final String? translatedName;
  final String? translatedDescription;
  final bool isFavorite;
  final String? description;

  // Currency conversion fields
  final String? originalCurrency;
  final Map<String, double>? convertedPrices;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.countryName,
    required this.image,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    this.user, // ✅ added
    this.translatedName,
    this.translatedDescription,
    this.isFavorite = false,
    this.description,
    this.originalCurrency,
    this.convertedPrices,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      countryName: json['countryName'],
      image: json['image'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: Category.fromJson(json['category']),
      user:
          json['user'] != null ? User.fromJson(json['user']) : null, // ✅ added
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
      originalCurrency: json['moneyCode'],
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toJson(),
      'user': user?.toJson(), // ✅ added
      'description': description,
      'isFavorite': isFavorite,
      'moneyCode': originalCurrency,
      'translatedName': translatedName,
      'translatedDescription': translatedDescription,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? countryName,
    String? image,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
    User? user, // ✅ added
    String? translatedName,
    String? translatedDescription,
    bool? isFavorite,
    String? description,
    String? originalCurrency,
    Map<String, double>? convertedPrices,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      countryName: countryName ?? this.countryName,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      user: user ?? this.user, // ✅ added
      translatedName: translatedName ?? this.translatedName,
      translatedDescription:
          translatedDescription ?? this.translatedDescription,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      convertedPrices: convertedPrices ?? this.convertedPrices,
    );
  }

  // Getters for display
  String get displayName => translatedName ?? name;
  String get displayDescription => translatedDescription ?? description ?? '';

  // Method to get converted price for a specific currency
  double getConvertedPrice(
      String targetCurrency, Map<String, double> exchangeRates) {
    if (targetCurrency == originalCurrency) return price;

    // Check if we have cached converted price
    if (convertedPrices != null &&
        convertedPrices!.containsKey(targetCurrency)) {
      return convertedPrices![targetCurrency]!;
    }

    // Calculate conversion
    double convertedPrice = price;

    // Convert to USD first if needed
    if (originalCurrency != 'USD') {
      final fromRate = exchangeRates[originalCurrency];
      if (fromRate != null && fromRate > 0) {
        convertedPrice = price / fromRate;
      }
    }

    // Convert to target currency
    if (targetCurrency != 'USD') {
      final toRate = exchangeRates[targetCurrency];
      if (toRate != null) {
        convertedPrice = convertedPrice * toRate;
      }
    }

    return convertedPrice;
  }

  // Method to format price with currency symbol
  String getFormattedPrice(
      String currencyCode, Map<String, double> exchangeRates) {
    final price = getConvertedPrice(currencyCode, exchangeRates);
    return _formatCurrency(price, currencyCode);
  }

  String _formatCurrency(double amount, String currencyCode) {
    final currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'BDT': '৳',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'JPY': '¥',
      'INR': '₹',
      'CHF': 'CHF ',
    };

    final symbol = currencySymbols[currencyCode] ?? '$currencyCode ';
    return '$symbol ${amount.toStringAsFixed(2)}';
  }
}

// ✅ Added User model
class User {
  final String id;
  final String? fullName;
  final String email;
  final String? profileImage;

  User({
    required this.id,
    this.fullName,
    required this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

class Category {
  final String id;
  final String title;
  final String? translatedTitle;

  Category({
    required this.id,
    required this.title,
    this.translatedTitle,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      translatedTitle: json['translatedTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'translatedTitle': translatedTitle,
    };
  }

  Category copyWith({
    String? id,
    String? title,
    String? translatedTitle,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      translatedTitle: translatedTitle ?? this.translatedTitle,
    );
  }

  String get displayTitle => translatedTitle ?? title;
}
