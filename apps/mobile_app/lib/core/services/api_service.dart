import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

class ApiService {
  final http.Client _client;

  ApiService([http.Client? client]) : _client = client ?? http.Client();

  // Base URL pointing to Dart Frog backend
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080/api';
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080/api'
        : 'http://localhost:8080/api';
  }

  // ==========================================
  // 1. Categories
  // ==========================================
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return _fallbackCategories;
  }

  // ==========================================
  // 2. Marketplace Listings & Search
  // ==========================================
  Future<List<MarketListing>> getListings({
    String? category,
    String? subcategory,
    String? q,
    String? status,
    String? sort,
  }) async {
    try {
      final params = <String, String>{};
      if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
        params['category'] = category;
      }
      if (subcategory != null && subcategory.isNotEmpty) {
        params['subcategory'] = subcategory;
      }
      if (q != null && q.isNotEmpty) {
        params['q'] = q;
      }
      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }
      if (sort != null && sort.isNotEmpty) {
        params['sort'] = sort;
      }

      final uri = Uri.parse('$baseUrl/listings').replace(queryParameters: params);
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => MarketListing.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    // Fallback filtering
    var list = _fallbackListings;
    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      list = list.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (q != null && q.isNotEmpty) {
      final query = q.toLowerCase();
      list = list.where((item) =>
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.formattedPrice.toLowerCase().contains(query)).toList();
    }
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      list = list.where((item) => item.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return list;
  }

  Future<MarketListing?> getListingById(String id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/listings/$id')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return MarketListing.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    try {
      return _fallbackListings.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<MarketListing?> createListing(MarketListing listing) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/listings'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(listing.toJson()),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return MarketListing.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    // Add to local fallback list for offline simulation
    _fallbackListings.insert(0, listing);
    return listing;
  }

  Future<MarketListing?> updateListing(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .patch(
            Uri.parse('$baseUrl/listings/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(updates),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return MarketListing.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    final idx = _fallbackListings.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final old = _fallbackListings[idx];
      final updated = old.copyWith(
        title: updates['title'] as String?,
        imagePath: (updates['image_path'] ?? updates['imagePath']) as String?,
        status: updates['status'] as String?,
        description: updates['description'] as String?,
      );
      _fallbackListings[idx] = updated;
      return updated;
    }
    return null;
  }

  Future<bool> deleteListing(String id) async {
    try {
      final response = await _client
          .delete(Uri.parse('$baseUrl/listings/$id'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        _fallbackListings.removeWhere((e) => e.id == id);
        return true;
      }
    } catch (_) {}

    _fallbackListings.removeWhere((e) => e.id == id);
    return true;
  }

  // ==========================================
  // 3. Vehicles Details
  // ==========================================
  Future<VehicleDetail?> getVehicleDetail(String id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/vehicles/$id')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return VehicleDetail.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    return _fallbackVehicleDetail;
  }

  // ==========================================
  // 4. Seller Dashboard
  // ==========================================
  Future<SellerMetrics> getSellerMetrics() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/seller/metrics')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return SellerMetrics.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    return const SellerMetrics(
      activeListings: 12,
      totalViews: 2400,
      enquiries: 38,
      messages: 7,
      growthPercent: 16,
      period: 'This Month',
    );
  }

  Future<List<MarketListing>> getSellerCatalogue({String? status}) async {
    try {
      final params = <String, String>{};
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        params['status'] = status;
      }
      final uri = Uri.parse('$baseUrl/seller/catalogue').replace(queryParameters: params);
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => MarketListing.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    var list = _fallbackListings;
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      list = list.where((item) => item.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return list;
  }

  // ==========================================
  // 5. Chat & Conversations
  // ==========================================
  Future<List<ConversationSummary>> getConversations({required bool isBuying}) async {
    try {
      final type = isBuying ? 'buying' : 'selling';
      final response = await _client.get(Uri.parse('$baseUrl/conversations?type=$type')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => ConversationSummary.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return _fallbackConversations.where((c) => c.isBuying == isBuying).toList();
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/conversations/$conversationId/messages'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return [
      ChatMessage(
        id: 'msg_1',
        conversationId: conversationId,
        senderId: 'usr_seller',
        content: 'Yes, You can inspect it tomorrow',
        sentAt: DateTime.now().subtract(const Duration(hours: 3)),
        isFromMe: false,
      ),
      ChatMessage(
        id: 'msg_2',
        conversationId: conversationId,
        senderId: 'usr_buyer',
        content: 'Hi Rohan, yes! Can I inspect it tomorrow morning around 11?',
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
        isFromMe: true,
      ),
      ChatMessage(
        id: 'msg_3',
        conversationId: conversationId,
        senderId: 'usr_seller',
        content: 'Yes, You can inspect it tomorrow. Location is near Kowdiar Palace.',
        sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isFromMe: false,
      ),
    ];
  }

  Future<ChatMessage?> sendMessage(String conversationId, String text) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/conversations/$conversationId/messages'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'content': text, 'text': text}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ChatMessage.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'usr_me',
      content: text,
      sentAt: DateTime.now(),
      isFromMe: true,
    );
  }

  // ==========================================
  // 6. User Profile & Favorites
  // ==========================================
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/profile')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    return const UserProfile(
      id: 'usr_101',
      name: 'Alex Morgan',
      phone: '+7 904 599 xxx 11',
      email: 'alexg@gamil.com',
      address: 'St. Petersburg, Vos....',
      avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300',
      favoritesCount: 1,
      savedSearchesCount: 1,
      recentlyViewedCount: 1,
      activeEnquiriesCount: 4,
    );
  }

  Future<bool> toggleFavorite(String listingId) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/profile/favorites'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'listing_id': listingId}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        return data['is_favorited'] as bool? ?? false;
      }
    } catch (_) {}
    return true;
  }

  // ==========================================
  // 7. Dealerships & Trusted Businesses
  // ==========================================
  Future<List<VehicleDealershipModel>> getDealerships() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/dealerships')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => VehicleDealershipModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return const [
      VehicleDealershipModel(
        id: 'deal_1',
        name: 'Apex Motor Hub',
        location: 'Kowdiar, Thiruvananthapuram',
        category: 'Car Dealership',
        rating: '4.8',
        imagePath: 'assets/images/h1.png',
      ),
      VehicleDealershipModel(
        id: 'deal_2',
        name: 'Velocity Pre-Owned Cars',
        location: 'HSR Layout, Bengaluru',
        category: 'Used Cars',
        rating: '4.9',
        imagePath: 'assets/images/h1.png',
      ),
    ];
  }

  Future<List<TrustedBusinessModel>> getTrustedBusinesses() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/businesses/trusted')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => TrustedBusinessModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return const [
      TrustedBusinessModel(
        id: 'biz_1',
        name: 'Skyline Prime Realty',
        category: 'Property',
        rating: '4.9',
        verifiedListingsCount: 14,
        imagePath: 'assets/images/h2.png',
      ),
      TrustedBusinessModel(
        id: 'biz_2',
        name: 'TechZone Retail',
        category: 'Mobiles',
        rating: '4.7',
        verifiedListingsCount: 28,
        imagePath: 'assets/images/h6.png',
      ),
    ];
  }

  // ==========================================
  // Legacy / Products Support
  // ==========================================
  Future<List<Product>> getProducts({String? categoryId, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (categoryId != null && categoryId != 'all') queryParams['category'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['q'] = search;

      final uri = Uri.parse('$baseUrl/products').replace(queryParameters: queryParams);
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    var list = _fallbackProducts;
    if (categoryId != null && categoryId != 'all') {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (search != null && search.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(search.toLowerCase())).toList();
    }
    return list;
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/products/$id')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Product.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}
    try {
      return _fallbackProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // Fallback Seed Data
  // ==========================================
  static final List<Category> _fallbackCategories = [
    const Category(id: 'cat_vehicles', name: 'Vehicles', slug: 'vehicles', iconName: 'directions_car'),
    const Category(id: 'cat_property', name: 'Property', slug: 'property', iconName: 'home_work'),
    const Category(id: 'cat_furniture', name: 'Furniture', slug: 'furniture', iconName: 'chair'),
    const Category(id: 'cat_mobiles', name: 'Mobiles', slug: 'mobiles', iconName: 'phone_android'),
    const Category(id: 'cat_jobs', name: 'Jobs', slug: 'jobs', iconName: 'work_outline'),
    const Category(id: 'cat_groceries', name: 'Groceries', slug: 'groceries', iconName: 'shopping_basket'),
    const Category(id: 'cat_services', name: 'Services', slug: 'services', iconName: 'build_outlined'),
    const Category(id: 'cat_electronics', name: 'Electronics', slug: 'electronics', iconName: 'devices'),
  ];

  static final List<MarketListing> _fallbackListings = [
    MarketListing(
      id: 'list_creta_2022',
      title: '2022 Hyundai Creta EX',
      price: 725000,
      formattedPrice: '₹ 7,25,000',
      location: 'Thiruvananthapuram',
      category: 'Vehicles',
      subcategory: 'Car',
      imagePath: 'assets/images/h1.png',
      description: 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience.',
      sellerId: 'ven_hyundai_hub',
      sellerName: 'Hyundai Auto Hub',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      specifications: const {
        'total_capacity': '6 Seats',
        'highest_speed': '200 KM/H',
        'engine_output': '500 HP',
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'owner': '1st Owner • Verified',
      },
    ),
    MarketListing(
      id: 'list_apt_kowdiar',
      title: '3BHK Apartment -\nKowdiar',
      price: 9500000,
      formattedPrice: '₹ 95,00,000',
      location: 'Thiruvananthapuram',
      category: 'Property',
      subcategory: 'Apartment',
      imagePath: 'assets/images/h2.png',
      description: 'Luxury 3BHK premium apartment with scenic balcony view, high-end fittings, and covered parking.',
      sellerId: 'ven_skyline',
      sellerName: 'Skyline Prime Realty',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    MarketListing(
      id: 'list_apt_sushil',
      title: 'Sushil 2BHK\nApartment',
      price: 42000,
      formattedPrice: '₹ 42,000 /mo',
      location: 'HSR Layout, Bengaluru',
      category: 'Property',
      subcategory: 'Rent',
      imagePath: 'assets/images/h8.png',
      description: 'Spacious 2BHK ready-to-move apartment located in prime HSR Layout Sector 2.',
      sellerId: 'ven_sushil_props',
      sellerName: 'Sushil Properties',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    MarketListing(
      id: 'list_oak_dining_1',
      title: 'Solid Oak Dining\nTable',
      price: 725000,
      formattedPrice: '₹ 7,25,000',
      location: 'HSR Layout, Bengaluru',
      category: 'Furniture',
      subcategory: 'Dining Sets',
      imagePath: 'assets/images/h.png',
      description: 'Handcrafted solid European oak dining table with seating for up to 8 guests.',
      sellerId: 'ven_woodcraft',
      sellerName: 'Heritage Woodcraft',
      status: 'active',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MarketListing(
      id: 'list_phone_flagship',
      title: 'Flagship Phone -\n256GB',
      price: 62900,
      formattedPrice: '₹ 62,900',
      location: 'Thiruvananthapuram',
      category: 'Mobiles',
      subcategory: 'Smartphones',
      imagePath: 'assets/images/h6.png',
      description: 'Brand new condition, 100% battery health, original bill, box and complete accessories.',
      sellerId: 'ven_tech_zone',
      sellerName: 'TechZone Retail',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    MarketListing(
      id: 'list_job_frontend',
      title: 'Senior Frontend\nEngineer',
      price: 2400000,
      formattedPrice: '₹ 18 - 24 LPA',
      location: 'Bengaluru',
      category: 'Jobs',
      subcategory: 'Engineering',
      imagePath: 'assets/images/h3.png',
      description: 'Join a hyper-growth venture building cross-platform Flutter and Next.js applications.',
      sellerId: 'ven_galletrix_hr',
      sellerName: 'Galletrix Talent',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MarketListing(
      id: 'list_apt_kakkanad',
      title: '3BHK Apartment in\nKakkanad',
      price: 12500000,
      formattedPrice: '₹ 1.25 Crore',
      location: 'Bengaluru',
      category: 'Property',
      subcategory: 'Apartment',
      imagePath: 'assets/images/h2.png',
      description: 'Overlooking Infopark with premium clubhouse amenities, swimming pool, and 24x7 security.',
      sellerId: 'ven_urban_nest',
      sellerName: 'Urban Nest Realty',
      status: 'active',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    ),
    MarketListing(
      id: 'list_veg_combo',
      title: 'Organic Vegetables\nCombo Pack',
      price: 499,
      formattedPrice: '₹ 499',
      location: 'Kakkanad',
      category: 'Groceries',
      subcategory: 'Vegetables',
      imagePath: 'assets/images/h4.png',
      description: 'Fresh organic farm-picked daily essential vegetables box (5kg assortment).',
      sellerId: 'ven_green_harvest',
      sellerName: 'Green Harvest Farms',
      status: 'active',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MarketListing(
      id: 'list_clean_service',
      title: 'Home Deep\nCleaning Service',
      price: 2500,
      formattedPrice: '₹ 2,500',
      location: 'Kakkanad',
      category: 'Services',
      subcategory: 'Cleaning',
      imagePath: 'assets/images/h7.png',
      description: 'Comprehensive 4-hour home sanitization and deep cleaning by verified professionals.',
      sellerId: 'ven_clean_pros',
      sellerName: 'Urban Clean Pros',
      status: 'active',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
    ),
    MarketListing(
      id: 'list_macbook_m2',
      title: 'MacBook Air M2 13"',
      price: 98000,
      formattedPrice: '₹ 98,000',
      location: 'Kochi',
      category: 'Mobiles',
      subcategory: 'Laptops',
      imagePath: 'assets/images/h5.png',
      description: 'Apple M2 chip, 8GB unified memory, 256GB SSD, Midnight finish with AppleCare+ warranty.',
      sellerId: 'ven_alex_m',
      sellerName: 'Alex Morgan',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    MarketListing(
      id: 'list_iphone_15_pro',
      title: 'iPhone 15 Pro\nMax 256GB',
      price: 134900,
      formattedPrice: '₹ 1,34,900',
      location: 'Indiranagar, Bengaluru',
      category: 'Mobiles',
      subcategory: 'Smartphones',
      imagePath: 'assets/images/h6.png',
      description: 'Natural Titanium, immaculate condition with Apple warranty till December.',
      sellerId: 'ven_premium_tech',
      sellerName: 'Premium Tech Hub',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
    ),
    MarketListing(
      id: 'list_s24_ultra',
      title: 'Samsung Galaxy\nS24 Ultra 5G',
      price: 109999,
      formattedPrice: '₹ 1,09,999',
      location: 'HSR Layout, Bengaluru',
      category: 'Mobiles',
      subcategory: 'Smartphones',
      imagePath: 'assets/images/h6.png',
      description: 'Titanium Gray 12GB/512GB, Galaxy AI unlocked with S-Pen.',
      sellerId: 'ven_galaxy_hub',
      sellerName: 'Galaxy Official Reseller',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
    ),
  ];

  static const VehicleDetail _fallbackVehicleDetail = VehicleDetail(
    listingId: 'list_creta_2022',
    title: 'Hyundai Creta SX',
    price: '₹ 7,25,000',
    imagePath: 'assets/images/h1.png',
    location: 'Thiruvananthapuram',
    totalCapacity: '6 Seats',
    highestSpeed: '200 KM/H',
    engineOutput: '500 HP',
    fuelType: 'Petrol',
    transmission: 'Automatic',
    owner: '1st Owner • Verified',
    description:
        'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience featuring a panoramic sunroof, premium upholstery, and wireless connectivity.',
    highlights: [
      'Panoramic Sunroof',
      'Bose 8-Speaker Audio',
      'Wireless Phone Charger',
      'Full Service Record Available',
    ],
  );

  static final List<ConversationSummary> _fallbackConversations = [
    const ConversationSummary(
      id: 'conv_1',
      senderName: 'Rohan Sharma',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      itemTag: 'Hyundai Creta 2022',
      itemThumbnail: 'assets/images/h1.png',
      lastMessage: 'Yes, You can inspect it tomorrow',
      timestamp: '10:41',
      isBuying: true,
      unreadCount: 1,
    ),
    const ConversationSummary(
      id: 'conv_2',
      senderName: 'Urban Nest Realty',
      senderAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
      itemTag: '3BHK Kakkanad Apartment',
      itemThumbnail: 'assets/images/h2.png',
      lastMessage: 'The viewing is confirmed for 4 PM',
      timestamp: 'Yesterday',
      isBuying: true,
      unreadCount: 0,
    ),
    const ConversationSummary(
      id: 'conv_3',
      senderName: 'Priya Varma',
      senderAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      itemTag: 'MacBook Air M2 13"',
      itemThumbnail: 'assets/images/h5.png',
      lastMessage: 'Is the price negotiable?',
      timestamp: 'Sep 27',
      isBuying: false,
      unreadCount: 2,
    ),
  ];

  static final List<Product> _fallbackProducts = [
    Product(
      id: 'prod_1',
      title: 'Galletrix Pulse ANC Wireless Headphones',
      description: 'Studio-grade noise cancellation with 40-hour battery life, spatial audio tracking, and ultra-plush memory foam earcups.',
      price: 299.99,
      discountPrice: 249.99,
      rating: 4.9,
      reviewCount: 342,
      stock: 45,
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
      ],
      categoryId: 'cat_audio',
      vendorId: 'ven_101',
      vendorName: 'Acoustic Labs',
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
    Product(
      id: 'prod_2',
      title: 'Horizon Pro Mechanical Keyboard (RGB)',
      description: 'Custom hot-swappable switches, aircraft-grade CNC aluminum chassis, Bluetooth 5.3 + 2.4GHz multi-device pairing.',
      price: 179.00,
      discountPrice: 149.00,
      rating: 4.8,
      reviewCount: 189,
      stock: 22,
      images: [
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800',
      ],
      categoryId: 'cat_electronics',
      vendorId: 'ven_102',
      vendorName: 'KeyCrafters',
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
  ];
}
