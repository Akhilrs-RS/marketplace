import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/admin/presentation/screens/admin_orders_screen.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_order_item_card.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_order_stepper.dart';
import 'package:mobile_app/features/admin/presentation/widgets/admin_orders_kpi_row.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminOrdersScreen Widget Tests', () {
    testWidgets('renders all Figma Order screen components and filters correctly', (tester) async {
      bool backCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AdminOrdersScreen(
            onBack: () => backCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Header & App Bar
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Sharma Electronics'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // 2. Verify Filter Chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);
      expect(find.text('Confirmed'), findsWidgets);
      expect(find.text('Processing'), findsWidgets);
      expect(find.text('Packed'), findsWidgets);
      expect(find.text('Shipped'), findsWidgets);
      expect(find.text('Delivered'), findsWidgets);

      // 3. Verify KPI Row & 4 Cards
      expect(find.byType(AdminOrdersKpiRow), findsOneWidget);
      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('Total Revenue'), findsOneWidget);
      expect(find.text('₹ 1,28,450'), findsOneWidget);
      expect(find.text('Pending Order'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Delivered'), findsWidgets);
      expect(find.text('98'), findsOneWidget);

      // 4. Verify Order Item Cards
      expect(find.byType(AdminOrderItemCard), findsNWidgets(4));
      expect(find.text('Smart Watch'), findsOneWidget);
      expect(find.text('Sports Shoes'), findsOneWidget);
      expect(find.text('Perfume 100ml'), findsOneWidget);

      // 5. Verify 6-Stage Stepper on Card 1
      expect(find.byType(AdminOrderStepper), findsOneWidget);
      expect(find.text('Placed'), findsOneWidget);

      // 6. Test Back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      expect(backCalled, isTrue);

      // 7. Test Filtering by Chip (tap first instance which is the filter chip)
      await tester.tap(find.text('Confirmed').first);
      await tester.pumpAndSettle();
      expect(find.byType(AdminOrderItemCard), findsOneWidget);
      expect(find.text('Smart Watch'), findsOneWidget);
    });
  });
}
