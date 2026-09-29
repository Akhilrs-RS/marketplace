class VehicleDetail {
  final String listingId;
  final String title;
  final String price;
  final String imagePath;
  final String location;
  final String totalCapacity;
  final String highestSpeed;
  final String engineOutput;
  final String fuelType;
  final String transmission;
  final String owner;
  final String description;
  final List<String> highlights;

  const VehicleDetail({
    required this.listingId,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.location,
    required this.totalCapacity,
    required this.highestSpeed,
    required this.engineOutput,
    this.fuelType = 'Petrol',
    this.transmission = 'Automatic',
    this.owner = '1st Owner • Verified',
    this.description = '',
    this.highlights = const [],
  });

  factory VehicleDetail.fromJson(Map<String, dynamic> json) {
    return VehicleDetail(
      listingId: json['listing_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as String? ?? '',
      imagePath: json['image_path'] as String? ?? 'assets/images/h1.png',
      location: json['location'] as String? ?? '',
      totalCapacity: json['total_capacity'] as String? ?? '6 Seats',
      highestSpeed: json['highest_speed'] as String? ?? '200 KM/H',
      engineOutput: json['engine_output'] as String? ?? '500 HP',
      fuelType: json['fuel_type'] as String? ?? 'Petrol',
      transmission: json['transmission'] as String? ?? 'Automatic',
      owner: json['owner'] as String? ?? '1st Owner • Verified',
      description: json['description'] as String? ?? '',
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listing_id': listingId,
      'title': title,
      'price': price,
      'image_path': imagePath,
      'location': location,
      'total_capacity': totalCapacity,
      'highest_speed': highestSpeed,
      'engine_output': engineOutput,
      'fuel_type': fuelType,
      'transmission': transmission,
      'owner': owner,
      'description': description,
      'highlights': highlights,
    };
  }
}
