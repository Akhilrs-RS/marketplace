class SellerMetrics {
  final int activeListings;
  final int totalViews;
  final int enquiries;
  final int messages;
  final int growthPercent;
  final String period;

  const SellerMetrics({
    required this.activeListings,
    required this.totalViews,
    required this.enquiries,
    required this.messages,
    this.growthPercent = 16,
    this.period = 'This Month',
  });

  factory SellerMetrics.fromJson(Map<String, dynamic> json) {
    return SellerMetrics(
      activeListings: json['active_listings'] as int? ?? 12,
      totalViews: json['total_views'] as int? ?? 2400,
      enquiries: json['enquiries'] as int? ?? 38,
      messages: json['messages'] as int? ?? 7,
      growthPercent: json['growth_percent'] as int? ?? 16,
      period: json['period'] as String? ?? 'This Month',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_listings': activeListings,
      'total_views': totalViews,
      'enquiries': enquiries,
      'messages': messages,
      'growth_percent': growthPercent,
      'period': period,
    };
  }
}

class SellerProfile {
  final String id;
  final String name;
  final String type; // 'individual' or 'business'
  final bool isVerified;
  final int rating;
  final int totalSales;

  const SellerProfile({
    required this.id,
    required this.name,
    this.type = 'individual',
    this.isVerified = true,
    this.rating = 5,
    this.totalSales = 24,
  });

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'individual',
      isVerified: json['is_verified'] as bool? ?? true,
      rating: json['rating'] as int? ?? 5,
      totalSales: json['total_sales'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_verified': isVerified,
      'rating': rating,
      'total_sales': totalSales,
    };
  }
}
