import 'dart:io';
import 'package:backend_api/src/database/database_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  final status = context.request.uri.queryParameters['status'];
  final sellerItems = await DatabaseService().getListings(status: status);

  final response = ApiResponse<List<dynamic>>.success(
    data: sellerItems.map((e) => e.toJson()).toList(),
    message: '${sellerItems.length} catalogue items retrieved',
  );

  return Response.json(body: response.toJson((data) => data));
}
