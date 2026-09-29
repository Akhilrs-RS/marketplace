class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String avatarUrl;
  final int favoritesCount;
  final int savedSearchesCount;
  final int recentlyViewedCount;
  final int activeEnquiriesCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.avatarUrl,
    this.favoritesCount = 1,
    this.savedSearchesCount = 1,
    this.recentlyViewedCount = 1,
    this.activeEnquiriesCount = 4,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Alex Morgan',
      phone: json['phone'] as String? ?? '+7 904 599 xxx 11',
      email: json['email'] as String? ?? 'alexg@gamil.com',
      address: json['address'] as String? ?? 'St. Petersburg, Vos....',
      avatarUrl: json['avatar_url'] as String? ?? 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300',
      favoritesCount: json['favorites_count'] as int? ?? 1,
      savedSearchesCount: json['saved_searches_count'] as int? ?? 1,
      recentlyViewedCount: json['recently_viewed_count'] as int? ?? 1,
      activeEnquiriesCount: json['active_enquiries_count'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'avatar_url': avatarUrl,
      'favorites_count': favoritesCount,
      'saved_searches_count': savedSearchesCount,
      'recently_viewed_count': recentlyViewedCount,
      'active_enquiries_count': activeEnquiriesCount,
    };
  }
}
