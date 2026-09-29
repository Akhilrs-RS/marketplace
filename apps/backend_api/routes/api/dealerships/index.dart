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

  final category = context.request.uri.queryParameters['category'];
  var dealers = MockDatabase.dealerships;

  if (category != null && category.isNotEmpty) {
    dealers = dealers.where((d) => d.category.toLowerCase().contains(category.toLowerCase())).toList();
  }

  final response = ApiResponse<List<dynamic>>.success(
    data: dealers.map((d) => d.toJson()).toList(),
    message: '${dealers.length} dealerships retrieved',
  );

  return Response.json(body: response.toJson((data) => data));
}
