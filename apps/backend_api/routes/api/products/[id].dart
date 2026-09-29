import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Response onRequest(RequestContext context, String id) {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  try {
    final product = MockDatabase.products.firstWhere((p) => p.id == id);
    return Response.json(
      body: ApiResponse<Map<String, dynamic>>.success(
        data: product.toJson(),
        message: 'Product retrieved',
      ).toJson((data) => data),
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(
        error: 'Product with ID "$id" not found',
      ).toJson((_) => null),
    );
  }
}
