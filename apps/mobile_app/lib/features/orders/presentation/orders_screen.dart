import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import '../../../core/theme/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mockOrders = [
      Order(
        id: 'ord_9042',
        userId: 'usr_guest',
        items: const [
          CartItem(
            id: 'item_1',
            productId: 'prod_3',
            quantity: 1,
            unitPrice: 185.00,
            selectedVariant: 'Size 42 - Carbon Black',
          ),
          CartItem(
            id: 'item_2',
            productId: 'prod_4',
            quantity: 1,
            unitPrice: 89.99,
            selectedVariant: 'Solid Walnut Base',
          ),
        ],
        totalAmount: 279.99,
        status: OrderStatus.shipped,
        shippingAddress: const ShippingAddress(
          fullName: 'Alex Morgan',
          street: '742 Evergreen Terrace',
          city: 'San Francisco',
          state: 'CA',
          postalCode: '94107',
          country: 'United States',
          phoneNumber: '+1 (555) 019-2834',
        ),
        paymentMethod: 'Apple Pay',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      ),
      Order(
        id: 'ord_8820',
        userId: 'usr_guest',
        items: const [
          CartItem(
            id: 'item_3',
            productId: 'prod_1',
            quantity: 1,
            unitPrice: 249.99,
            selectedVariant: 'Pulse Midnight',
          ),
        ],
        totalAmount: 254.99,
        status: OrderStatus.delivered,
        shippingAddress: const ShippingAddress(
          fullName: 'Alex Morgan',
          street: '742 Evergreen Terrace',
          city: 'San Francisco',
          state: 'CA',
          postalCode: '94107',
          country: 'United States',
          phoneNumber: '+1 (555) 019-2834',
        ),
        paymentMethod: 'Visa ending in 4242',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockOrders.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 16),
        itemBuilder: (ctx, i) {
          final order = mockOrders[i];
          final isDelivered = order.status == OrderStatus.delivered;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDelivered
                            ? AppColors.accent.withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.name.toUpperCase(),
                        style: TextStyle(
                          color: isDelivered ? AppColors.accent : AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${order.items.length} items • \$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Delivering to: ${order.shippingAddress.formattedAddress}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paid via ${order.paymentMethod}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Track Package', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
