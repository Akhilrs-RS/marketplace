import 'dart:io';
import 'package:backend_api/src/database/database_service.dart';
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

Future<Response> _getListings(RequestContext context) async {
  final params = context.request.uri.queryParameters;
  final category = params['category'];
  final subcategory = params['subcategory'];
  final query = params['q'];
  final status = params['status'] ?? 'active';
  final sort = params['sort'];

  final results = await DatabaseService().getListings(
    category: category,
    subcategory: subcategory,
    q: query,
    status: status,
    sort: sort,
  );

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
      id: body['id'] as String? ?? 'list_${DateTime.now().millisecondsSinceEpoch}',
      title: body['title'] as String? ?? 'Untitled Listing',
      price: (body['price'] as num?)?.toDouble() ?? 0.0,
      formattedPrice: body['formatted_price'] as String? ?? '₹ ${body['price'] ?? 0}',
      location: body['location'] as String? ?? 'Bengaluru',
      category: body['category'] as String? ?? 'All',
      subcategory: body['subcategory'] as String? ?? '',
      imagePath: body['image_path'] as String? ?? 'assets/images/h.png',
      description: body['description'] as String? ?? '',
      sellerId: body['seller_id'] as String? ?? 'ven_alex_m',
      sellerName: body['seller_name'] as String? ?? 'Alex Morgan',
      status: body['status'] as String? ?? 'active',
      isFeatured: body['is_featured'] as bool? ?? false,
      createdAt: DateTime.now(),
      specifications: (body['specifications'] as Map<String, dynamic>?) ?? {},
    );

    final saved = await DatabaseService().createListing(newListing);

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: saved.toJson(),
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
