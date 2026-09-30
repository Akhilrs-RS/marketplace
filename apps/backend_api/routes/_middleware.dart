import 'package:backend_api/src/database/database_service.dart';
import 'package:dart_frog/dart_frog.dart';

bool _dbInitialized = false;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(_corsHeaders())
      .use(_dbMiddleware());
}

Middleware _dbMiddleware() {
  return (handler) {
    return (context) async {
      if (!_dbInitialized) {
        _dbInitialized = true;
        await DatabaseService().initialize();
      }
      return handler(context);
    };
  };
}

Middleware _corsHeaders() {
  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
          },
        );
      }
      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        },
      );
    };
  };
}
