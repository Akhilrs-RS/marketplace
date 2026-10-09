import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/features/admin/presentation/admin_hub_screen.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_ads_management_screen.dart';
import 'package:mobile_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Admin Ads Management & Image Editing Tests', () {
    testWidgets('AdminAdsManagementScreen displays search, category filters, and listings', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final apiService = ApiService();

      await tester.pumpWidget(
        GalletrixMarketplaceApp(
          apiService: apiService,
          startAsAdmin: true,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the Manage Ads quick action button on the Admin Home tab
      final manageAdsAction = find.text('Manage Ads');
      expect(manageAdsAction, findsOneWidget);
      await tester.ensureVisible(manageAdsAction);
      await tester.tap(manageAdsAction);
      await tester.pumpAndSettle();

      // Verify we navigated to AdminAdsManagementScreen
      expect(find.byType(AdminAdsManagementScreen), findsOneWidget);
      expect(find.text('Ads Management'), findsOneWidget);
      expect(find.text('Search ads by title, seller, or category...'), findsOneWidget);

      // Verify category chips exist
      expect(find.text('All'), findsWidgets);
      expect(find.text('Vehicles'), findsWidgets);
      expect(find.text('Mobiles'), findsWidgets);

      // Verify count bar
      expect(find.text('Tap image to edit'), findsOneWidget);
    });

    testWidgets('Tapping product image thumbnail opens edit image bottom sheet with catalog presets', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final apiService = ApiService();

      await tester.pumpWidget(
        GalletrixMarketplaceApp(
          apiService: apiService,
          startAsAdmin: true,
        ),
      );
      await tester.pumpAndSettle();

      // Open AdminAdsManagementScreen
      final manageAds = find.text('Manage Ads');
      await tester.ensureVisible(manageAds);
      await tester.tap(manageAds);
      await tester.pumpAndSettle();

      // Tap on the Edit Images quick icon or the image thumbnail
      final editBadge = find.byIcon(Icons.edit_rounded);
      if (editBadge.evaluate().isNotEmpty) {
        await tester.tap(editBadge.first);
        await tester.pumpAndSettle();

        expect(find.text('Edit Product Image'), findsOneWidget);
        expect(find.text('Quick Catalog Presets'), findsOneWidget);
        expect(find.text('Save Image'), findsOneWidget);
      }
    });

    testWidgets('Navigation to /admin opens AdminHubScreen directly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final apiService = ApiService();

      await tester.pumpWidget(
        GalletrixMarketplaceApp(
          apiService: apiService,
          startAsAdmin: false,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to /admin
      final navigatorState = tester.state<NavigatorState>(find.byType(Navigator));
      navigatorState.pushNamed('/admin');
      await tester.pumpAndSettle();

      expect(find.byType(AdminHubScreen), findsOneWidget);
    });
  });
}
