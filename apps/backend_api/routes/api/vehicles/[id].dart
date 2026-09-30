import 'dart:io';
import 'package:backend_api/src/database/database_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  var detail = await DatabaseService().getVehicleDetail(id);
  detail ??= await DatabaseService().getVehicleDetail('list_creta_2022');

  if (detail == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: ApiResponse<dynamic>.error(error: 'Vehicle details not found').toJson((_) => null),
    );
  }

  final response = ApiResponse<Map<String, dynamic>>.success(
    data: detail.toJson(),
    message: 'Vehicle details retrieved successfully',
  );

  return Response.json(body: response.toJson((data) => data));
}
