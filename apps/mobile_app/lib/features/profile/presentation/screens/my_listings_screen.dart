import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../selling/presentation/screens/select_listing_category_screen.dart';
import '../../../products/presentation/car_details_screen.dart';

class MyListingItem {
  final String id;
  final String title;
  final String price;
  final String views;
  final String inquiries;
  final String imagePath;
  String status; // 'Active', 'Under Review', 'Sold'

  MyListingItem({
    required this.id,
    required this.title,
    required this.price,
    required this.views,
    required this.inquiries,
    required this.imagePath,
    required this.status,
  });
}

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MyListingItem> _listings = [
    MyListingItem(
      id: 'lst_1',
      title: 'Hyundai Creta SX(O) 1.5 Turbo',
      price: '₹ 14,80,000',
      views: '1,420 views',
      inquiries: '24 inquiries',
      imagePath: 'assets/images/h1.png',
      status: 'Active',
    ),
    MyListingItem(
      id: 'lst_2',
      title: 'Apple iPhone 15 Pro Max 256GB',
      price: '₹ 92,000',
      views: '540 views',
      inquiries: '8 inquiries',
      imagePath: 'assets/images/h6.png',
      status: 'Active',
    ),
    MyListingItem(
      id: 'lst_3',
      title: 'Sony WH-1000XM5 Black',
      price: '₹ 22,000',
      views: '310 views',
      inquiries: '4 inquiries',
      imagePath: 'assets/images/h5.png',
      status: 'Under Review',
    ),
    MyListingItem(
      id: 'lst_4',
      title: 'MacBook Air M2 16GB',
      price: '₹ 75,000',
      views: '2,800 views',
      inquiries: '45 inquiries',
      imagePath: 'assets/images/h5.png',
      status: 'Sold',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAsSold(MyListingItem item) {
    setState(() {
      item.status = 'Sold';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked "${item.title}" as Sold!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _boostListing(MyListingItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Boosting "${item.title}" to top of search results!'),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeListings = _listings.where((l) => l.status == 'Active').toList();
    final reviewListings = _listings.where((l) => l.status == 'Under Review').toList();
    final soldListings = _listings.where((l) => l.status == 'Sold').toList();

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
          'My Listings (${_listings.length})',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6366F1),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 2.5,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: [
            Tab(text: 'Active (${activeListings.length})'),
            Tab(text: 'Under Review (${reviewListings.length})'),
            Tab(text: 'Sold (${soldListings.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('post_new_ad_fab'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SelectListingCategoryScreen()),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Post New Ad', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(activeListings, showActions: true),
          _buildList(reviewListings, showActions: false),
          _buildList(soldListings, showActions: false),
        ],
      ),
    );
  }

  Widget _buildList(List<MyListingItem> list, {required bool showActions}) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'No listings in this category',
          style: GoogleFonts.inter(color: const Color(0xFF64748B)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: list.length,
      separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final item = list[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (item.title.contains('Creta')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CarDetailsScreen()),
                    );
                  }
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(item.imagePath, width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.price,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.views} • ${item.inquiries}',
                            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (showActions) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _markAsSold(item),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Mark as Sold',
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _boostListing(item),
                        icon: const Icon(Icons.rocket_launch_rounded, size: 14),
                        label: Text(
                          'Boost Ad',
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEDE9FE),
                          foregroundColor: const Color(0xFF6366F1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
