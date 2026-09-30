import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../products/presentation/car_details_screen.dart';

class ViewedItem {
  final String id;
  final String title;
  final String price;
  final String timeAgo;
  final String imagePath;
  final String category;

  const ViewedItem({
    required this.id,
    required this.title,
    required this.price,
    required this.timeAgo,
    required this.imagePath,
    required this.category,
  });
}

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  final List<ViewedItem> _items = [
    const ViewedItem(
      id: 'v_1',
      title: 'Hyundai Creta SX(O) 1.5 Turbo',
      price: '₹ 14,80,000',
      timeAgo: 'Viewed 2 hours ago',
      imagePath: 'assets/images/h1.png',
      category: 'Vehicles',
    ),
    const ViewedItem(
      id: 'v_2',
      title: 'Apple MacBook Pro 14" M3 Pro',
      price: '₹ 1,74,900',
      timeAgo: 'Viewed yesterday at 4:30 PM',
      imagePath: 'assets/images/h5.png',
      category: 'Electronics',
    ),
    const ViewedItem(
      id: 'v_3',
      title: 'Luxury 3BHK Apartment - Kowdiar',
      price: '₹ 95,00,000',
      timeAgo: 'Viewed 2 days ago',
      imagePath: 'assets/images/h2.png',
      category: 'Property',
    ),
  ];

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear Browsing History?', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text(
          'This will remove all recently viewed items from your profile.',
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _items.clear());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Browsing history cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recently Viewed (${_items.length})',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          if (_items.isNotEmpty)
            TextButton(
              key: const Key('clear_history_btn'),
              onPressed: _clearHistory,
              child: Text(
                'Clear',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFDC2626)),
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'No recently viewed items.',
                style: GoogleFonts.inter(color: const Color(0xFF64748B)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = _items[i];
                return InkWell(
                  onTap: () {
                    if (item.category == 'Vehicles') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarDetailsScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${item.title}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 70,
                            height: 70,
                            color: const Color(0xFFF1F5F9),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.price,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
