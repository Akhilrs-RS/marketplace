import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getListing(id);
    case HttpMethod.patch:
      return _updateListing(context, id);
    case HttpMethod.delete:
      return _deleteListing(id);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getListing(String id) {
  try {
    final item = MockDatabase.listings.firstWhere((e) => e.id == id);
    final response = ApiResponse<Map<String, dynamic>>.success(
      data: item.toJson(),
      message: 'Listing retrieved successfully',
    );
    return Response.json(body: response.toJson((data) => data));
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
    );
  }
}

Future<Response> _updateListing(RequestContext context, String id) async {
  final index = MockDatabase.listings.indexWhere((e) => e.id == id);
  if (index == -1) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
    );
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final existing = MockDatabase.listings[index];
    final updated = MarketListing(
      id: existing.id,
      title: body['title'] as String? ?? existing.title,
      price: (body['price'] as num?)?.toDouble() ?? existing.price,
      formattedPrice: body['formatted_price'] as String? ?? existing.formattedPrice,
      location: body['location'] as String? ?? existing.location,
      category: body['category'] as String? ?? existing.category,
      subcategory: body['subcategory'] as String? ?? existing.subcategory,
      imagePath: body['image_path'] as String? ?? existing.imagePath,
      description: body['description'] as String? ?? existing.description,
      sellerId: existing.sellerId,
      sellerName: existing.sellerName,
      status: body['status'] as String? ?? existing.status,
      isFeatured: body['is_featured'] as bool? ?? existing.isFeatured,
      createdAt: existing.createdAt,
      specifications: body['specifications'] != null
          ? Map<String, dynamic>.from(body['specifications'] as Map)
          : existing.specifications,
    );

    MockDatabase.listings[index] = updated;

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: updated.toJson(),
      message: 'Listing updated successfully',
    );
    return Response.json(body: response.toJson((data) => data));
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: 'Failed to update listing: $e').toJson((_) => null),
    );
  }
}

Response _deleteListing(String id) {
  final index = MockDatabase.listings.indexWhere((e) => e.id == id);
  if (index == -1) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
    );
  }

  MockDatabase.listings.removeAt(index);
  final response = ApiResponse<dynamic>.success(
    data: null,
    message: 'Listing deleted successfully',
  );
  return Response.json(body: response.toJson((data) => null));
}
