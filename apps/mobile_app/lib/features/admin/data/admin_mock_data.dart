import 'package:flutter/material.dart';

class TopSellingProduct {
  final String title;
  final int soldCount;
  final String revenue;
  final IconData icon;

  const TopSellingProduct({
    required this.title,
    required this.soldCount,
    required this.revenue,
    required this.icon,
  });
}

class AdminRecentOrder {
  final String id;
  final String customer;
  final String amount;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final IconData icon;

  const AdminRecentOrder({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.icon,
  });
}

class AdminCatalogProduct {
  final String id;
  final String title;
  final String categoryAndSku;
  final String price;
  final String status; // 'Active', 'Draft', 'Pending', 'Out Stock'
  final bool isInStock;
  final IconData icon;

  const AdminCatalogProduct({
    required this.id,
    required this.title,
    required this.categoryAndSku,
    required this.price,
    required this.status,
    required this.isInStock,
    required this.icon,
  });
}

class OrderKpiMetric {
  final String label;
  final String value;
  final String trend;
  final Color trendColor;
  final String subtitle;
  final IconData icon;

  const OrderKpiMetric({
    required this.label,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.subtitle,
    required this.icon,
  });
}

class AdminDetailedOrder {
  final String id;
  final String productTitle;
  final String originalPrice;
  final String salePrice;
  final String customerName;
  final String deliveryMethod;
  final String statusLabel;
  final Color statusTextColor;
  final Color statusBgColor;
  final int currentStep; // 0: Placed, 1: Confirmed, 2: Processing, 3: Packed, 4: Shipped, 5: Delivered
  final bool hasStepper;
  final IconData icon;

  const AdminDetailedOrder({
    required this.id,
    required this.productTitle,
    required this.originalPrice,
    required this.salePrice,
    required this.customerName,
    required this.deliveryMethod,
    required this.statusLabel,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.currentStep,
    this.hasStepper = false,
    required this.icon,
  });
}

class AdminMockData {
  static const List<OrderKpiMetric> orderKpis = [
    OrderKpiMetric(
      label: 'Total Orders',
      value: '128',
      trend: '↑ 12.5 %',
      trendColor: Color(0xFF16A34A),
      subtitle: 'VS last 7 days',
      icon: Icons.inventory_2_outlined,
    ),
    OrderKpiMetric(
      label: 'Total Revenue',
      value: '₹ 1,28,450',
      trend: '↑ 8.2 %',
      trendColor: Color(0xFF16A34A),
      subtitle: 'VS last 7 days',
      icon: Icons.currency_rupee_rounded,
    ),
    OrderKpiMetric(
      label: 'Pending Order',
      value: '12',
      trend: '↑ 4.3%',
      trendColor: Color(0xFFD97706),
      subtitle: 'VS last 7 days',
      icon: Icons.shopping_cart_outlined,
    ),
    OrderKpiMetric(
      label: 'Delivered',
      value: '98',
      trend: '↑ 15.7%',
      trendColor: Color(0xFF16A34A),
      subtitle: 'VS last 7 days',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  static const List<AdminDetailedOrder> detailedOrders = [
    AdminDetailedOrder(
      id: 'ORD-101',
      productTitle: 'Wireless Noise Cancelling\nHeadphones',
      originalPrice: '₹ 6,499',
      salePrice: '₹ 6,499',
      customerName: 'Rahul Kumar',
      deliveryMethod: 'Standard Delivery   2 -4 days',
      statusLabel: 'Processing',
      statusTextColor: Color(0xFFD97706),
      statusBgColor: Color(0xFFFEF3C7),
      currentStep: 2,
      hasStepper: true,
      icon: Icons.headphones_rounded,
    ),
    AdminDetailedOrder(
      id: 'ORD-102',
      productTitle: 'Smart Watch',
      originalPrice: '₹ 6,499',
      salePrice: '₹ 2,499',
      customerName: 'Rahul Kumar',
      deliveryMethod: 'Standard Delivery   2 -4 days',
      statusLabel: 'Confirmed',
      statusTextColor: Color(0xFF16A34A),
      statusBgColor: Color(0xFFDCFCE7),
      currentStep: 1,
      hasStepper: false,
      icon: Icons.watch_rounded,
    ),
    AdminDetailedOrder(
      id: 'ORD-103',
      productTitle: 'Sports Shoes',
      originalPrice: '₹ 8,499',
      salePrice: '₹ 7,999',
      customerName: 'Rahul Kumar',
      deliveryMethod: 'Standard Delivery   2 -4 days',
      statusLabel: 'Packed',
      statusTextColor: Color(0xFF0284C7),
      statusBgColor: Color(0xFFE0F2FE),
      currentStep: 3,
      hasStepper: false,
      icon: Icons.directions_run_rounded,
    ),
    AdminDetailedOrder(
      id: 'ORD-104',
      productTitle: 'Perfume 100ml',
      originalPrice: '₹ 8,499',
      salePrice: '₹ 6,499',
      customerName: 'Rahul Kumar',
      deliveryMethod: 'Standard Delivery   2 -4 days',
      statusLabel: 'Shipped',
      statusTextColor: Color(0xFF7C3AED),
      statusBgColor: Color(0xFFEDE9FE),
      currentStep: 4,
      hasStepper: false,
      icon: Icons.sanitizer_rounded,
    ),
  ];

  static const List<TopSellingProduct> topSellingProducts = [
    TopSellingProduct(
      title: 'Wireless Headphones',
      soldCount: 120,
      revenue: '₹ 1,20,000',
      icon: Icons.headphones_rounded,
    ),
    TopSellingProduct(
      title: 'Smart Watch',
      soldCount: 50,
      revenue: '₹ 45,000',
      icon: Icons.watch_rounded,
    ),
    TopSellingProduct(
      title: 'Bluetooth Speaker',
      soldCount: 15,
      revenue: '₹ 30,000',
      icon: Icons.speaker_rounded,
    ),
  ];

  static const List<AdminRecentOrder> recentOrders = [
    AdminRecentOrder(
      id: '#ORD - 12345',
      customer: 'Rahul Kumar',
      amount: '₹ 95,000',
      status: 'Paid',
      statusColor: Color(0xFF16A34A),
      statusBg: Color(0xFFDCFCE7),
      icon: Icons.inventory_2_outlined,
    ),
    AdminRecentOrder(
      id: '#ORD - 12346',
      customer: 'Pooja Sharma',
      amount: '₹ 7,500',
      status: 'Pending',
      statusColor: Color(0xFFD97706),
      statusBg: Color(0xFFFEF3C7),
      icon: Icons.local_shipping_outlined,
    ),
    AdminRecentOrder(
      id: '#ORD - 12347',
      customer: 'Deepka Reddy',
      amount: '₹ 7,500',
      status: 'Paid',
      statusColor: Color(0xFF16A34A),
      statusBg: Color(0xFFDCFCE7),
      icon: Icons.inventory_2_outlined,
    ),
  ];

  static const List<AdminCatalogProduct> catalogProducts = [
    AdminCatalogProduct(
      id: 'prod-1',
      title: 'Wireless Noise Cancelling Headphones',
      categoryAndSku: 'Electronics & Mobiles • SH - HP-001',
      price: '₹ 8,499',
      status: 'Active',
      isInStock: true,
      icon: Icons.headphones_rounded,
    ),
    AdminCatalogProduct(
      id: 'prod-2',
      title: 'Smart Fitness Watch Pro',
      categoryAndSku: 'Electronics & Mobiles • PL - WF-020',
      price: '₹ 11,999',
      status: 'Active',
      isInStock: true,
      icon: Icons.watch_rounded,
    ),
    AdminCatalogProduct(
      id: 'prod-3',
      title: 'Noise Cancelling Earbuds',
      categoryAndSku: 'Electronics & Mobiles • EM - EB-14',
      price: '₹ 4,499',
      status: 'Active',
      isInStock: true,
      icon: Icons.earbuds_rounded,
    ),
    AdminCatalogProduct(
      id: 'prod-4',
      title: 'Wireless Noise Cancelling Over-Ear',
      categoryAndSku: 'Electronics & Mobiles • SH - HP-002',
      price: '₹ 8,499',
      status: 'Active',
      isInStock: true,
      icon: Icons.headset_rounded,
    ),
    AdminCatalogProduct(
      id: 'prod-5',
      title: 'Studio Sound Monitor Pro',
      categoryAndSku: 'Electronics & Audio • ST - MN-900',
      price: '₹ 18,990',
      status: 'Draft',
      isInStock: false,
      icon: Icons.speaker_group_rounded,
    ),
    AdminCatalogProduct(
      id: 'prod-6',
      title: 'Compact Wireless Earphones',
      categoryAndSku: 'Electronics • SH - EB-003',
      price: '₹ 2,999',
      status: 'Out Stock',
      isInStock: false,
      icon: Icons.hearing_rounded,
    ),
  ];
}
