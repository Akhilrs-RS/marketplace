import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../cubit/admin_auth_cubit.dart';
import '../cubit/admin_auth_state.dart';
import 'screens/admin_add_product_screen.dart';
import 'screens/admin_ads_management_screen.dart';
import 'screens/admin_analytics_screen.dart';
import 'screens/admin_home_tab.dart';
import 'screens/admin_onboarding_screen.dart';
import 'screens/admin_orders_screen.dart';
import 'screens/admin_products_screen.dart';
import 'widgets/admin_bottom_nav_bar.dart';

class AdminHubScreen extends StatefulWidget {
  final VoidCallback? onSwitchToBuyer;

  const AdminHubScreen({
    super.key,
    this.onSwitchToBuyer,
  });

  @override
  State<AdminHubScreen> createState() => _AdminHubScreenState();
}

class _AdminHubScreenState extends State<AdminHubScreen> {
  int _currentNavIndex = 0;

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  void _previewOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminOnboardingScreen(
          onLogin: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _openAdsManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminAdsManagementScreen()),
    );
  }

  void _showAdminProfileSheet(BuildContext context, AdminAuthState authState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFFBBF24),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(authState.avatarUrl),
                        onBackgroundImageError: (_, _) {},
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.userName,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            authState.shopName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Admin',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.campaign_outlined, color: Color(0xFF7C3AED)),
                  title: Text('Manage User Ads & Product Images', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('Edit product images, add or delete marketplace ads', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openAdsManagement();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.palette_outlined, color: Color(0xFF7C3AED)),
                  title: Text('View Welcome / Onboarding Screen', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('Preview the Figma onboarding & login screen', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    _previewOnboarding();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.storefront_rounded, color: Color(0xFF7C3AED)),
                  title: Text('Shop Settings', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('Manage opening hours, branding, and contact details', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  title: Text('Admin Sign Out', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                  subtitle: Text('End administrative session', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out from Marketplace Hub')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(AdminAuthState authState) {
    switch (_currentNavIndex) {
      case 0:
        return AdminHomeTab(
          authState: authState,
          onNotificationsTap: _openNotifications,
          onAvatarTap: () => _showAdminProfileSheet(context, authState),
          onAddProduct: () => setState(() => _currentNavIndex = 2),
          onInventoryTap: () => setState(() => _currentNavIndex = 1),
          onViewOrders: () => setState(() => _currentNavIndex = 3),
          onCreateOffers: () => setState(() => _currentNavIndex = 2),
          onReports: () => setState(() => _currentNavIndex = 4),
          onManageAds: _openAdsManagement,
        );
      case 1:
        return AdminProductsScreen(
          onNotificationsTap: _openNotifications,
          onAvatarTap: () => _showAdminProfileSheet(context, authState),
          onAddProduct: () => setState(() => _currentNavIndex = 2),
        );
      case 2:
        return AdminAddProductScreen(
          onBack: () => setState(() => _currentNavIndex = 0),
        );
      case 3:
        return AdminOrdersScreen(
          onBack: () => setState(() => _currentNavIndex = 0),
          onNotificationsTap: _openNotifications,
          onAvatarTap: () => _showAdminProfileSheet(context, authState),
        );
      case 4:
        return AdminAnalyticsScreen(
          onBack: () => setState(() => _currentNavIndex = 0),
        );
      default:
        return AdminHomeTab(
          authState: authState,
          onNotificationsTap: _openNotifications,
          onAvatarTap: () => _showAdminProfileSheet(context, authState),
          onAddProduct: () => setState(() => _currentNavIndex = 2),
          onInventoryTap: () => setState(() => _currentNavIndex = 1),
          onViewOrders: () => setState(() => _currentNavIndex = 3),
          onCreateOffers: () => setState(() => _currentNavIndex = 2),
          onReports: () => setState(() => _currentNavIndex = 4),
          onManageAds: _openAdsManagement,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        final isFullScreenForm = _currentNavIndex == 2 || _currentNavIndex == 3 || _currentNavIndex == 4;

        return Scaffold(
          backgroundColor: isFullScreenForm ? Colors.white : const Color(0xFF0B0E14),
          body: Stack(
            children: [
              // Active Screen Body
              SafeArea(
                bottom: false,
                child: _buildBody(authState),
              ),

              // Floating Frosted Glass Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AdminBottomNavBar(
                  currentIndex: _currentNavIndex,
                  onTabSelected: (index) {
                    setState(() => _currentNavIndex = index);
                  },
                  onAddPressed: () {
                    setState(() => _currentNavIndex = 2);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
