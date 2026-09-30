class MarketListing {
  final String id;
  final String title;
  final double price;
  final String formattedPrice;
  final String location;
  final String category;
  final String subcategory;
  final String imagePath;
  final String description;
  final String sellerId;
  final String sellerName;
  final String status; // 'active', 'draft', 'pending', 'paused'
  final bool isFeatured;
  final DateTime createdAt;
  final Map<String, dynamic> specifications;

  const MarketListing({
    required this.id,
    required this.title,
    required this.price,
    required this.formattedPrice,
    required this.location,
    required this.category,
    this.subcategory = '',
    required this.imagePath,
    this.description = '',
    this.sellerId = 'seller_default',
    this.sellerName = 'Verified Seller',
    this.status = 'active',
    this.isFeatured = false,
    required this.createdAt,
    this.specifications = const {},
  });

  factory MarketListing.fromJson(Map<String, dynamic> json) {
    return MarketListing(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      formattedPrice: json['formatted_price'] as String? ?? '₹ 0',
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? 'All',
      subcategory: json['subcategory'] as String? ?? '',
      imagePath: json['image_path'] as String? ?? 'assets/images/h.png',
      description: json['description'] as String? ?? '',
      sellerId: json['seller_id'] as String? ?? 'seller_default',
      sellerName: json['seller_name'] as String? ?? 'Verified Seller',
      status: json['status'] as String? ?? 'active',
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      specifications: (json['specifications'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'formatted_price': formattedPrice,
      'location': location,
      'category': category,
      'subcategory': subcategory,
      'image_path': imagePath,
      'description': description,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'status': status,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'specifications': specifications,
    };
  }

  MarketListing copyWith({
    String? id,
    String? title,
    double? price,
    String? formattedPrice,
    String? location,
    String? category,
    String? subcategory,
    String? imagePath,
    String? description,
    String? sellerId,
    String? sellerName,
    String? status,
    bool? isFeatured,
    DateTime? createdAt,
    Map<String, dynamic>? specifications,
  }) {
    return MarketListing(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      formattedPrice: formattedPrice ?? this.formattedPrice,
      location: location ?? this.location,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      specifications: specifications ?? this.specifications,
    );
  }
}
