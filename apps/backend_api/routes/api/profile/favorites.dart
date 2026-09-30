import 'dart:io';
import 'package:backend_api/src/database/database_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getFavorites();
    case HttpMethod.post:
      return _toggleFavorite(context);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Future<Response> _getFavorites() async {
  final allListings = await DatabaseService().getListings();
  final favListings = allListings.take(2).toList();

  final response = ApiResponse<List<dynamic>>.success(
    data: favListings.map((e) => e.toJson()).toList(),
    message: '${favListings.length} favorite listings retrieved',
  );
  return Response.json(body: response.toJson((data) => data));
}

Future<Response> _toggleFavorite(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final listingId = body['listing_id'] as String? ?? '';

    if (listingId.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ApiResponse<dynamic>.error(error: 'listing_id is required').toJson((_) => null),
      );
    }

    final isFav = await DatabaseService().toggleFavorite(
      userId: 'usr_default',
      listingId: listingId,
    );

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: {
        'listing_id': listingId,
        'is_favorite': isFav,
      },
      message: isFav ? 'Added to favorites' : 'Removed from favorites',
    );
    return Response.json(body: response.toJson((data) => data));
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: 'Failed to toggle favorite: $e').toJson((_) => null),
    );
  }
}
