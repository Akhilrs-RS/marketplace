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

  final type = context.request.uri.queryParameters['type'];
  var convs = MockDatabase.conversations;

  if (type == 'buying') {
    convs = convs.where((c) => c.isBuying).toList();
  } else if (type == 'selling') {
    convs = convs.where((c) => !c.isBuying).toList();
  }

  final response = ApiResponse<List<dynamic>>.success(
    data: convs.map((c) => c.toJson()).toList(),
    message: '${convs.length} conversations retrieved',
  );

  return Response.json(body: response.toJson((data) => data));
}
