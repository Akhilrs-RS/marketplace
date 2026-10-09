import 'dart:io';
import 'package:backend_api/src/database/database_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getListing(id);
    case HttpMethod.put:
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

Future<Response> _getListing(String id) async {
  final item = await DatabaseService().getListingById(id);
  if (item == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
    );
  }

  final response = ApiResponse<Map<String, dynamic>>.success(
    data: item.toJson(),
    message: 'Listing retrieved successfully',
  );
  return Response.json(body: response.toJson((data) => data));
}

Future<Response> _updateListing(RequestContext context, String id) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final updated = await DatabaseService().updateListing(id, body);
    if (updated == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
      );
    }

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

Future<Response> _deleteListing(String id) async {
  final deleted = await DatabaseService().deleteListing(id);
  if (!deleted) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Listing not found').toJson((_) => null),
    );
  }

  final response = ApiResponse<dynamic>.success(
    data: null,
    message: 'Listing deleted successfully',
  );
  return Response.json(body: response.toJson((data) => null));
}
