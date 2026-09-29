import 'category.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? discountPrice;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> images;
  final String categoryId;
  final Category? category;
  final String vendorId;
  final String vendorName;
  final bool isFeatured;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.stock,
    required this.images,
    required this.categoryId,
    this.category,
    required this.vendorId,
    required this.vendorName,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      categoryId: json['category_id'] as String? ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      vendorId: json['vendor_id'] as String? ?? '',
      vendorName: json['vendor_name'] as String? ?? 'Verified Seller',
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'rating': rating,
      'review_count': reviewCount,
      'stock': stock,
      'images': images,
      'category_id': categoryId,
      if (category != null) 'category': category!.toJson(),
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  int get discountPercentage => hasDiscount
      ? (((price - discountPrice!) / price) * 100).round()
      : 0;
}
