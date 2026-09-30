import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/api/categories/index.dart' as categories_route;
import '../../routes/api/products/index.dart' as products_route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}

void main() {
  group('Marketplace Backend API', () {
    test('GET /api/categories returns categories list', () async {
      final context = _MockRequestContext();
      final request = _MockRequest();
      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await categories_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      expect(body['data'], isList);
      expect((body['data'] as List).isNotEmpty, isTrue);
    });

    test('GET /api/products returns products list', () async {
      final context = _MockRequestContext();
      final request = _MockRequest();
      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost:8080/api/products'));

      final response = await products_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      expect(body['data'], isList);
      expect((body['data'] as List).isNotEmpty, isTrue);
    });
  });
}
