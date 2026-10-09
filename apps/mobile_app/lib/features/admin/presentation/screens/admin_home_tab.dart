import 'package:flutter/material.dart';
import '../../cubit/admin_auth_state.dart';
import '../widgets/admin_metrics_grid.dart';
import '../widgets/admin_promo_banner.dart';
import '../widgets/admin_quick_actions.dart';
import '../widgets/admin_recent_orders.dart';
import '../widgets/admin_search_bar.dart';
import '../widgets/admin_shop_banner.dart';
import '../widgets/admin_top_header.dart';
import '../widgets/admin_top_selling_products.dart';

class AdminHomeTab extends StatelessWidget {
  final AdminAuthState authState;
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onAddProduct;
  final VoidCallback onInventoryTap;
  final VoidCallback onViewOrders;
  final VoidCallback onCreateOffers;
  final VoidCallback onReports;
  final VoidCallback? onManageAds;

  const AdminHomeTab({
    super.key,
    required this.authState,
    required this.onNotificationsTap,
    required this.onAvatarTap,
    required this.onAddProduct,
    required this.onInventoryTap,
    required this.onViewOrders,
    required this.onCreateOffers,
    required this.onReports,
    this.onManageAds,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Top Dark Header ──
          AdminTopHeader(
            userName: authState.userName,
            avatarUrl: authState.avatarUrl,
            onNotificationsTap: onNotificationsTap,
            onAvatarTap: onAvatarTap,
          ),

          // ── 2. Shop Banner with Hyundai Car Graphic ──
          AdminShopBanner(
            onViewShop: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Zara Philip Shopfront...')),
              );
            },
          ),

          const SizedBox(height: 12),

          // ── 3. Main White Curved Content Sheet ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Search Bar with Circular Green Arrow
                AdminSearchBar(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching admin inventory...')),
                    );
                  },
                ),

                // 8 Metric KPI Cards (Total Sales, Orders, Products, etc.)
                const AdminMetricsGrid(),

                // 6 Quick Action Lavender Tiles
                AdminQuickActions(
                  onAddProduct: onAddProduct,
                  onViewOrders: onViewOrders,
                  onCreateOffers: onCreateOffers,
                  onReports: onReports,
                  onManageAds: onManageAds,
                ),

                const SizedBox(height: 20),

                // Top Selling Products Section
                AdminTopSellingProducts(
                  onViewAll: onInventoryTap,
                ),

                const SizedBox(height: 24),

                // Recent Orders Section with Status Badges
                AdminRecentOrders(
                  onViewAll: onViewOrders,
                ),

                const SizedBox(height: 24),

                // Bottom Hot Deal Alert Card
                AdminPromoBanner(
                  onActionTap: onCreateOffers,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
