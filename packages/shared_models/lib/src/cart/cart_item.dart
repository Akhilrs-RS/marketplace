import '../product/product.dart';

class CartItem {
  final String id;
  final String productId;
  final Product? product;
  final int quantity;
  final double unitPrice;
  final String? selectedVariant;

  const CartItem({
    required this.id,
    required this.productId,
    this.product,
    required this.quantity,
    required this.unitPrice,
    this.selectedVariant,
  });

  double get subtotal => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      selectedVariant: json['selected_variant'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      if (product != null) 'product': product!.toJson(),
      'quantity': quantity,
      'unit_price': unitPrice,
      'selected_variant': selectedVariant,
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    Product? product,
    int? quantity,
    double? unitPrice,
    String? selectedVariant,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      selectedVariant: selectedVariant ?? this.selectedVariant,
    );
  }
}

class CartSummary {
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;

  const CartSummary({
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
  });

  factory CartSummary.fromItems(List<CartItem> items, {double shippingFee = 5.0, double discount = 0.0}) {
    final sub = items.fold<double>(0.0, (acc, item) => acc + item.subtotal);
    final tot = sub > 0 ? (sub + shippingFee - discount).clamp(0.0, double.infinity) : 0.0;
    return CartSummary(
      items: items,
      subtotal: sub,
      shippingFee: items.isEmpty ? 0.0 : shippingFee,
      discount: discount,
      total: tot,
    );
  }

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingFee: (json['shipping_fee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'discount': discount,
      'total': total,
    };
  }
}
