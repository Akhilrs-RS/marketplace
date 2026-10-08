import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class AdminQuickActions extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onViewOrders;
  final VoidCallback onCreateOffers;
  final VoidCallback onReports;

  const AdminQuickActions({
    super.key,
    required this.onAddProduct,
    required this.onViewOrders,
    required this.onCreateOffers,
    required this.onReports,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionItem(
        icon: Icons.add_rounded,
        label: 'Add Product',
        onTap: onAddProduct,
      ),
      QuickActionItem(
        icon: Icons.inventory_2_outlined,
        label: 'Add Product',
        onTap: onAddProduct,
      ),
      QuickActionItem(
        icon: Icons.shopping_cart_outlined,
        label: 'View Orders',
        onTap: onViewOrders,
      ),
      QuickActionItem(
        icon: Icons.local_offer_outlined,
        label: 'Create Offers',
        onTap: onCreateOffers,
      ),
      QuickActionItem(
        icon: Icons.post_add_rounded,
        label: 'Add Product',
        onTap: onAddProduct,
      ),
      QuickActionItem(
        icon: Icons.description_outlined,
        label: 'Reports',
        onTap: onReports,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Action',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              return _buildActionCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(QuickActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF5FF), // Soft Lavender tint
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF3E8FF),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE), // Lavender icon box
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                item.icon,
                color: const Color(0xFF7C3AED), // Vivid purple icon
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
