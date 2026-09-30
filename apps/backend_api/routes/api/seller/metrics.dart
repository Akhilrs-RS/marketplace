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

  final metrics = await DatabaseService().getSellerMetrics('ven_default');
  final response = ApiResponse<Map<String, dynamic>>.success(
    data: metrics.toJson(),
    message: 'Seller metrics retrieved successfully',
  );

  return Response.json(body: response.toJson((data) => data));
}
