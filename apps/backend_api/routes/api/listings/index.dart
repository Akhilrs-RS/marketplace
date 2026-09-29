import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getListings(context);
    case HttpMethod.post:
      return _createListing(context);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getListings(RequestContext context) {
  final params = context.request.uri.queryParameters;
  final category = params['category'];
  final subcategory = params['subcategory'];
  final query = params['q']?.toLowerCase();
  final status = params['status'] ?? 'active';

  var results = List<MarketListing>.from(MockDatabase.listings);

  // Filter by status if specified
  if (status != 'all') {
    results = results.where((item) => item.status == status).toList();
  }

  // Filter by category
  if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
    results = results.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Filter by subcategory
  if (subcategory != null && subcategory.isNotEmpty) {
    results = results.where((item) => item.subcategory.toLowerCase() == subcategory.toLowerCase()).toList();
  }

  // Filter by search query
  if (query != null && query.isNotEmpty) {
    results = results.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.formattedPrice.toLowerCase().contains(query);
    }).toList();
  }

  final response = ApiResponse<List<dynamic>>.success(
    data: results.map((e) => e.toJson()).toList(),
    message: '${results.length} listings retrieved',
  );

  return Response.json(body: response.toJson((data) => data));
}

Future<Response> _createListing(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final newListing = MarketListing(
      id: 'list_${DateTime.now().millisecondsSinceEpoch}',
      title: body['title'] as String? ?? 'Untitled Listing',
      price: (body['price'] as num?)?.toDouble() ?? 0.0,
      formattedPrice: body['formatted_price'] as String? ?? '₹ ${body['price'] ?? 0}',
      location: body['location'] as String? ?? 'Bengaluru',
      category: body['category'] as String? ?? 'All',
      subcategory: body['subcategory'] as String? ?? '',
      imagePath: body['image_path'] as String? ?? 'assets/images/h.png',
      description: body['description'] as String? ?? '',
      sellerId: 'ven_alex_m',
      sellerName: 'Alex Morgan',
      status: 'active',
      isFeatured: false,
      createdAt: DateTime.now(),
      specifications: (body['specifications'] as Map<String, dynamic>?) ?? {},
    );

    MockDatabase.listings.insert(0, newListing);

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: newListing.toJson(),
      message: 'Listing created successfully',
    );
    return Response.json(statusCode: HttpStatus.created, body: response.toJson((data) => data));
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: 'Failed to create listing: $e').toJson((_) => null),
    );
  }
}
