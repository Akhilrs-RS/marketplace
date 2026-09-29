import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

class ApiService {
  // Base URL pointing to Dart Frog backend
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080/api';
    // For Android emulator 10.0.2.2, for iOS/macOS localhost
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080/api'
        : 'http://localhost:8080/api';
  }

  final http.Client _client = http.Client();

  // Categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Graceful fallback to static seed data
    }
    return _fallbackCategories;
  }

  // Products
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
    } catch (_) {
      // Graceful fallback to static seed data
    }

    var list = _fallbackProducts;
    if (categoryId != null && categoryId != 'all') {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (search != null && search.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(search.toLowerCase())).toList();
    }
    return list;
  }

  // Product by ID
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

  // Fallback seed data
  static final List<Category> _fallbackCategories = [
    const Category(id: 'cat_electronics', name: 'Electronics', slug: 'electronics', iconName: 'devices'),
    const Category(id: 'cat_fashion', name: 'Fashion & Apparel', slug: 'fashion', iconName: 'checkroom'),
    const Category(id: 'cat_home', name: 'Home & Living', slug: 'home-living', iconName: 'chair'),
    const Category(id: 'cat_footwear', name: 'Footwear', slug: 'footwear', iconName: 'roller_skating'),
    const Category(id: 'cat_audio', name: 'Audio', slug: 'audio', iconName: 'headphones'),
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
    Product(
      id: 'prod_3',
      title: 'Velocity Runners - Carbon Series',
      description: 'Ultra-lightweight responsive carbon plate running shoes engineered for peak marathon performance and everyday comfort.',
      price: 210.00,
      discountPrice: 185.00,
      rating: 4.7,
      reviewCount: 512,
      stock: 60,
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
      ],
      categoryId: 'cat_footwear',
      vendorId: 'ven_103',
      vendorName: 'Strides Athletics',
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
    Product(
      id: 'prod_4',
      title: 'Minimalist Nordic Desk Lamp',
      description: 'Dimmable warm-to-cool LED with Qi-wireless charging pad integrated in the solid walnut base.',
      price: 89.99,
      rating: 4.6,
      reviewCount: 78,
      stock: 35,
      images: [
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800',
      ],
      categoryId: 'cat_home',
      vendorId: 'ven_104',
      vendorName: 'Nordic Studio',
      isFeatured: false,
      createdAt: DateTime.now(),
    ),
    Product(
      id: 'prod_5',
      title: 'Oversized Raw Denim Chore Jacket',
      description: '14oz Japanese selvedge denim crafted with triple-needle stitching and brass hardware.',
      price: 165.00,
      discountPrice: 135.00,
      rating: 4.9,
      reviewCount: 94,
      stock: 18,
      images: [
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
      ],
      categoryId: 'cat_fashion',
      vendorId: 'ven_105',
      vendorName: 'Atelier Indigo',
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
  ];
}
