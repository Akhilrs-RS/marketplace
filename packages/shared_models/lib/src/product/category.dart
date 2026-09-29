class Category {
  final String id;
  final String name;
  final String slug;
  final String? iconName;
  final String? imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.iconName,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      iconName: json['icon_name'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon_name': iconName,
      'image_url': imageUrl,
    };
  }
}
