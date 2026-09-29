import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getMessages(id);
    case HttpMethod.post:
      return _sendMessage(context, id);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getMessages(String conversationId) {
  final list = MockDatabase.messages[conversationId] ?? [];
  final response = ApiResponse<List<dynamic>>.success(
    data: list.map((m) => m.toJson()).toList(),
    message: '${list.length} messages retrieved',
  );
  return Response.json(body: response.toJson((data) => data));
}

Future<Response> _sendMessage(RequestContext context, String conversationId) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final content = (body['content'] ?? body['text']) as String? ?? '';

    if (content.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ApiResponse<dynamic>.error(error: 'Content cannot be empty').toJson((_) => null),
      );
    }

    final newMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user_alex',
      content: content,
      sentAt: DateTime.now(),
      isFromMe: true,
    );

    MockDatabase.messages.putIfAbsent(conversationId, () => []).add(newMsg);

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: newMsg.toJson(),
      message: 'Message sent',
    );
    return Response.json(statusCode: HttpStatus.created, body: response.toJson((data) => data));
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: 'Failed to send message: $e').toJson((_) => null),
    );
  }
}
