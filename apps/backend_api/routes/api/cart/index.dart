import 'dart:convert';
import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getCart();
    case HttpMethod.post:
      return _addToCart(context);
    case HttpMethod.delete:
      return _clearCart();
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getCart() {
  final summary = CartSummary.fromItems(MockDatabase.cartItems);
  return Response.json(
    body: ApiResponse<Map<String, dynamic>>.success(
      data: summary.toJson(),
      message: 'Cart retrieved',
    ).toJson((data) => data),
  );
}

Future<Response> _addToCart(RequestContext context) async {
  try {
    final body = await context.request.body();
    final json = jsonDecode(body) as Map<String, dynamic>;

    final productId = json['product_id'] as String?;
    final quantity = (json['quantity'] as num?)?.toInt() ?? 1;
    final variant = json['selected_variant'] as String?;

    if (productId == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ApiResponse<dynamic>.error(error: 'product_id is required').toJson((_) => null),
      );
    }

    final product = MockDatabase.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    // Check if item already in cart
    final existingIndex = MockDatabase.cartItems.indexWhere(
      (item) => item.productId == productId && item.selectedVariant == variant,
    );

    if (existingIndex >= 0) {
      final existing = MockDatabase.cartItems[existingIndex];
      MockDatabase.cartItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      MockDatabase.cartItems.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          product: product,
          quantity: quantity,
          unitPrice: product.effectivePrice,
          selectedVariant: variant,
        ),
      );
    }

    final summary = CartSummary.fromItems(MockDatabase.cartItems);
    return Response.json(
      body: ApiResponse<Map<String, dynamic>>.success(
        data: summary.toJson(),
        message: 'Item added to cart',
      ).toJson((data) => data),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: e.toString()).toJson((_) => null),
    );
  }
}

Response _clearCart() {
  MockDatabase.cartItems.clear();
  final summary = CartSummary.fromItems(MockDatabase.cartItems);
  return Response.json(
    body: ApiResponse<Map<String, dynamic>>.success(
      data: summary.toJson(),
      message: 'Cart cleared',
    ).toJson((data) => data),
  );
}
