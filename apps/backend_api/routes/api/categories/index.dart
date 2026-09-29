import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  final categories = MockDatabase.categories;
  final response = ApiResponse<List<dynamic>>.success(
    data: categories.map((c) => c.toJson()).toList(),
    message: 'Categories retrieved successfully',
  );

  return Response.json(body: response.toJson((data) => data));
}
