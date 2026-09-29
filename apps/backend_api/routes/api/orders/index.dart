import 'dart:convert';
import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getOrders();
    case HttpMethod.post:
      return _createOrder(context);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getOrders() {
  final orders = MockDatabase.orders;
  return Response.json(
    body: ApiResponse<List<dynamic>>.success(
      data: orders.map((o) => o.toJson()).toList(),
      message: 'Orders retrieved',
    ).toJson((data) => data),
  );
}

Future<Response> _createOrder(RequestContext context) async {
  try {
    final body = await context.request.body();
    final json = jsonDecode(body) as Map<String, dynamic>;

    final shippingAddress = ShippingAddress.fromJson(
      json['shipping_address'] as Map<String, dynamic>,
    );
    final paymentMethod = json['payment_method'] as String? ?? 'Credit Card';

    if (MockDatabase.cartItems.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ApiResponse<dynamic>.error(error: 'Cart is empty. Cannot place order.').toJson((_) => null),
      );
    }

    final summary = CartSummary.fromItems(MockDatabase.cartItems);
    final order = Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: 'usr_guest',
      items: List.from(MockDatabase.cartItems),
      totalAmount: summary.total,
      status: OrderStatus.confirmed,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    MockDatabase.orders.insert(0, order);
    MockDatabase.cartItems.clear();

    return Response.json(
      body: ApiResponse<Map<String, dynamic>>.success(
        data: order.toJson(),
        message: 'Order created successfully',
      ).toJson((data) => data),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: e.toString()).toJson((_) => null),
    );
  }
}
