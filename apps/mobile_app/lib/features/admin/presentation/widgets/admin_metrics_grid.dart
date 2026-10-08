import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminMetricItem {
  final String title;
  final String value;
  final String trendPercent;
  final String period;

  const AdminMetricItem({
    required this.title,
    required this.value,
    required this.trendPercent,
    this.period = 'Vs last 7 days',
  });
}

class AdminMetricsGrid extends StatelessWidget {
  final List<AdminMetricItem> metrics;

  const AdminMetricsGrid({
    super.key,
    this.metrics = defaultMetrics,
  });

  static const List<AdminMetricItem> defaultMetrics = [
    AdminMetricItem(
      title: 'Total Sales',
      value: '₹ 12845',
      trendPercent: '12.5%',
    ),
    AdminMetricItem(
      title: 'Orders',
      value: '128',
      trendPercent: '8.2%',
    ),
    AdminMetricItem(
      title: 'Products',
      value: '246',
      trendPercent: '15.3%',
    ),
    AdminMetricItem(
      title: 'Shop Visits',
      value: '8,420',
      trendPercent: '22.1%',
    ),
    AdminMetricItem(
      title: 'Product Views',
      value: '42,680',
      trendPercent: '12.6%',
    ),
    AdminMetricItem(
      title: 'Enquiries',
      value: '86',
      trendPercent: '15.3%',
    ),
    AdminMetricItem(
      title: 'Wishlist',
      value: '324',
      trendPercent: '8.8%',
    ),
    AdminMetricItem(
      title: 'Followers',
      value: '1,240',
      trendPercent: '14.2%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          // Row 1 (Items 0..3)
          Row(
            children: List.generate(4, (index) {
              if (index < metrics.length) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _buildMetricCard(metrics[index]),
                  ),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
          const SizedBox(height: 8),
          // Row 2 (Items 4..7)
          Row(
            children: List.generate(4, (index) {
              final actualIndex = index + 4;
              if (actualIndex < metrics.length) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _buildMetricCard(metrics[actualIndex]),
                  ),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(AdminMetricItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            item.value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                size: 9,
                color: Color(0xFF16A34A),
              ),
              const SizedBox(width: 1),
              Text(
                item.trendPercent,
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            item.period,
            style: GoogleFonts.inter(
              fontSize: 7.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
