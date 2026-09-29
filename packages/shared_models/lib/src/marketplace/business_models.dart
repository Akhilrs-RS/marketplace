class VehicleDealershipModel {
  final String id;
  final String name;
  final String location;
  final String category;
  final String rating;
  final String badge;
  final String imagePath;

  const VehicleDealershipModel({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    this.badge = 'Trusted Dealer',
    required this.imagePath,
  });

  factory VehicleDealershipModel.fromJson(Map<String, dynamic> json) {
    return VehicleDealershipModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: json['rating'] as String? ?? '4.8',
      badge: json['badge'] as String? ?? 'Trusted Dealer',
      imagePath: json['image_path'] as String? ?? 'assets/images/h1.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'category': category,
      'rating': rating,
      'badge': badge,
      'image_path': imagePath,
    };
  }
}

class TrustedBusinessModel {
  final String id;
  final String name;
  final String category;
  final String rating;
  final int verifiedListingsCount;
  final String imagePath;

  const TrustedBusinessModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.verifiedListingsCount,
    required this.imagePath,
  });

  factory TrustedBusinessModel.fromJson(Map<String, dynamic> json) {
    return TrustedBusinessModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: json['rating'] as String? ?? '4.9',
      verifiedListingsCount: json['verified_listings_count'] as int? ?? 100,
      imagePath: json['image_path'] as String? ?? 'assets/images/h1.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'verified_listings_count': verifiedListingsCount,
      'image_path': imagePath,
    };
  }
}
