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

  final status = context.request.uri.queryParameters['status'];
  var sellerItems = MockDatabase.listings;

  if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
    sellerItems = sellerItems.where((l) => l.status.toLowerCase() == status.toLowerCase()).toList();
  }

  final response = ApiResponse<List<dynamic>>.success(
    data: sellerItems.map((e) => e.toJson()).toList(),
    message: '${sellerItems.length} catalogue items retrieved',
  );

  return Response.json(body: response.toJson((data) => data));
}
