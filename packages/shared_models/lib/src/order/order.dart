import '../cart/cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phoneNumber;

  const ShippingAddress({
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phoneNumber,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['full_name'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postal_code'] as String,
      country: json['country'] as String,
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'phone_number': phoneNumber,
    };
  }

  String get formattedAddress => '$street, $city, $state $postalCode, $country';
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveredAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      shippingAddress: ShippingAddress.fromJson(json['shipping_address'] as Map<String, dynamic>),
      paymentMethod: json['payment_method'] as String? ?? 'card',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'status': status.name,
      'shipping_address': shippingAddress.toJson(),
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      if (deliveredAt != null) 'delivered_at': deliveredAt!.toIso8601String(),
    };
  }
}
