import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/features/admin/presentation/admin_hub_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_add_product_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_analytics_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_onboarding_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_orders_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_products_screen.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_bottom_nav_bar.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_metrics_grid.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_promo_banner.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_quick_actions.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_recent_orders.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_search_bar.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_shop_banner.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_top_header.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_top_selling_products.dart';
import 'package:mobile_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MarketPlace Hub Admin Screen Tests', () {
    testWidgets('renders all Figma Home components and switches across all 5 admin tabs', (tester) async {
      final apiService = ApiService();

      await tester.pumpWidget(
        GalletrixMarketplaceApp(
          apiService: apiService,
          startAsAdmin: true,
        ),
      );
      await tester.pumpAndSettle();

      // ── 1. Verify Home Header & Greeting ──
      expect(find.byType(AdminHubScreen), findsOneWidget);
      expect(find.byType(AdminTopHeader), findsOneWidget);
      expect(find.text('MarketPlace Hub'), findsOneWidget);
      expect(find.text('Welcome back ,'), findsOneWidget);
      expect(find.text('Zara Philip'), findsOneWidget);

      // ── 2. Verify Shop Banner ──
      expect(find.byType(AdminShopBanner), findsOneWidget);
      expect(find.text('Your shop is all set !'), findsOneWidget);
      expect(find.text('View shop'), findsOneWidget);

      // ── 3. Verify Search Bar ──
      expect(find.byType(AdminSearchBar), findsOneWidget);
      expect(find.text('Search product ,cars, jobs, property & more'), findsOneWidget);

      // ── 4. Verify 8 Metrics Cards ──
      expect(find.byType(AdminMetricsGrid), findsOneWidget);
      expect(find.text('Total Sales'), findsOneWidget);
      expect(find.text('₹ 12845'), findsOneWidget);
      expect(find.text('Orders'), findsWidgets);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('Products'), findsWidgets);
      expect(find.text('246'), findsOneWidget);

      // ── 5. Verify Quick Actions ──
      expect(find.byType(AdminQuickActions), findsOneWidget);
      expect(find.text('Quick Action'), findsOneWidget);

      // ── 6. Verify Top Selling Products ──
      expect(find.byType(AdminTopSellingProducts), findsOneWidget);
      expect(find.text('Top Selling Products'), findsOneWidget);
      expect(find.text('Wireless Headphones'), findsOneWidget);

      // ── 7. Verify Recent Orders ──
      expect(find.byType(AdminRecentOrders), findsOneWidget);
      expect(find.text('Recent Orders'), findsOneWidget);
      expect(find.text('#ORD - 12345'), findsOneWidget);
      expect(find.text('Rahul Kumar'), findsOneWidget);

      // ── 8. Verify Promo Banner ──
      expect(find.byType(AdminPromoBanner), findsOneWidget);
      expect(find.text('HOT DEAL'), findsOneWidget);

      // ── 9. Verify Floating Bottom Navigation Bar ──
      expect(find.byType(AdminBottomNavBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsWidgets);
      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);

      // ── 10. Test Tab 1: Products Screen ──
      await tester.tap(find.text('Products').last);
      await tester.pumpAndSettle();
      expect(find.byType(AdminProductsScreen), findsOneWidget);
      expect(find.textContaining('Active'), findsWidgets);

      // ── 11. Test Tab 2: Add Product Screen (via Center Add Icon in Bottom Bar) ──
      await tester.tap(
        find.descendant(
          of: find.byType(AdminBottomNavBar),
          matching: find.byIcon(Icons.add_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdminAddProductScreen), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Specifications'), findsOneWidget);
      expect(find.textContaining('Save to Catalog'), findsOneWidget);

      // ── 12. Test Tab 3: Order Screen ──
      await tester.tap(find.text('Order'));
      await tester.pumpAndSettle();
      expect(find.byType(AdminOrdersScreen), findsOneWidget);
      expect(find.text('Orders'), findsWidgets);
      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.text('Total Revenue'), findsOneWidget);
      expect(find.text('Rahul Kumar'), findsWidgets);

      // ── 13. Test Tab 4: Analytics Screen ──
      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();
      expect(find.byType(AdminAnalyticsScreen), findsOneWidget);
      expect(find.text('BUSINESS PERFORMANCE'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
    });

    testWidgets('renders AdminOnboardingScreen properly', (tester) async {
      bool loginCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AdminOnboardingScreen(
            onLogin: () => loginCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('WELCOME'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      await tester.tap(find.text('Login'));
      expect(loginCalled, isTrue);
    });
  });
}
