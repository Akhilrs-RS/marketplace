import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shop_details_screen.dart';

class TrustedBusinessEntry {
  final String id;
  final String name;
  final String category;
  final String location;
  final String rating;
  final String reviewCount;
  final int activeListingsCount;
  final String imagePath;
  final String badge;
  final String specialty;

  const TrustedBusinessEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.activeListingsCount,
    required this.imagePath,
    this.badge = 'Verified Partner',
    required this.specialty,
  });
}

class TrustedBusinessesScreen extends StatefulWidget {
  const TrustedBusinessesScreen({super.key});

  @override
  State<TrustedBusinessesScreen> createState() => _TrustedBusinessesScreenState();
}

class _TrustedBusinessesScreenState extends State<TrustedBusinessesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'All',
    'Property',
    'Electronics',
    'Vehicles',
    'Mobiles',
    'Furniture',
    'Jobs',
    'Services',
  ];

  final List<TrustedBusinessEntry> _businesses = const [
    TrustedBusinessEntry(
      id: 'biz_1',
      name: 'Greenfield Realtors',
      category: 'Property',
      location: 'Kowdiar, Thiruvananthapuram',
      rating: '4.8',
      reviewCount: '142 reviews',
      activeListingsCount: 14,
      imagePath: 'assets/images/h2.png',
      badge: 'RERA Certified',
      specialty: 'Luxury Apartments & Seaside Villas',
    ),
    TrustedBusinessEntry(
      id: 'biz_2',
      name: 'TechZone Electronics',
      category: 'Electronics',
      location: 'MG Road, Kochi',
      rating: '4.8',
      reviewCount: '210 reviews',
      activeListingsCount: 28,
      imagePath: 'assets/images/h5.png',
      badge: 'Apple Authorized',
      specialty: 'MacBooks, Sony Audio & 4K OLED Displays',
    ),
    TrustedBusinessEntry(
      id: 'biz_3',
      name: 'Lumen Labs',
      category: 'Jobs',
      location: 'Remote / InfoPark, Kochi',
      rating: '4.6',
      reviewCount: '85 reviews',
      activeListingsCount: 6,
      imagePath: 'assets/images/h3.png',
      badge: 'Direct Employer',
      specialty: 'Engineering, Mobile Dev & AI Agents',
    ),
    TrustedBusinessEntry(
      id: 'biz_4',
      name: 'Apex Motor Hub',
      category: 'Vehicles',
      location: 'Kowdiar, Thiruvananthapuram',
      rating: '4.9',
      reviewCount: '320 reviews',
      activeListingsCount: 18,
      imagePath: 'assets/images/h1.png',
      badge: 'Trusted Dealer',
      specialty: 'Certified Pre-Owned Cars & SUVs',
    ),
    TrustedBusinessEntry(
      id: 'biz_5',
      name: 'Premium Tech Hub',
      category: 'Mobiles',
      location: 'Indiranagar, Bengaluru',
      rating: '4.9',
      reviewCount: '195 reviews',
      activeListingsCount: 32,
      imagePath: 'assets/images/h6.png',
      badge: 'Official Dealer',
      specialty: 'iPhones, Galaxy S24 Ultra & Flagship Gear',
    ),
    TrustedBusinessEntry(
      id: 'biz_6',
      name: 'Heritage Woodcraft',
      category: 'Furniture',
      location: 'HSR Layout, Bengaluru',
      rating: '4.9',
      reviewCount: '110 reviews',
      activeListingsCount: 15,
      imagePath: 'assets/images/h8.png',
      badge: 'Handcrafted Wood',
      specialty: 'Solid European Oak & Living Room Sets',
    ),
    TrustedBusinessEntry(
      id: 'biz_7',
      name: 'Urban Clean Pros',
      category: 'Services',
      location: 'Kakkanad, Kochi',
      rating: '4.9',
      reviewCount: '240 reviews',
      activeListingsCount: 8,
      imagePath: 'assets/images/h7.png',
      badge: 'Background Verified',
      specialty: 'Home Deep Cleaning & Sanitization',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TrustedBusinessEntry> get _filteredBusinesses {
    return _businesses.where((b) {
      final matchesCat = _selectedCategory == 'All' ||
          b.category.toLowerCase() == _selectedCategory.toLowerCase();
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          b.name.toLowerCase().contains(q) ||
          b.location.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q) ||
          b.specialty.toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();
  }

  void _openShop(TrustedBusinessEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopDetailsScreen(
          business: ShopDetailsData(
            id: entry.id,
            name: entry.name,
            rating: entry.rating,
            reviewCount: entry.reviewCount,
            category: entry.category,
            location: entry.location,
            imagePath: entry.imagePath,
            verifiedBadge: entry.badge,
            description: '${entry.name} is a premier verified business specializing in ${entry.specialty}.',
            listings: ShopRegistry.getShop(entry.name).listings,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredBusinesses;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Trusted Businesses',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.verified_user_rounded,
              color: Color(0xFF10B981),
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 1. Search Bar Pill ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search verified shops & dealers',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 18),
                    )
                  else
                    const Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8), size: 20),
                ],
              ),
            ),
          ),

          // ── 2. Category Filter Chips ──
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // ── 3. Businesses Directory List ──
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.store_mall_directory_outlined, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'No businesses found in $_selectedCategory',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
                    itemCount: list.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 14),
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo Avatar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    color: const Color(0xFFF1F5F9),
                                    child: Image.asset(
                                      item.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => const Icon(Icons.storefront_rounded, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Name, Rating, and Category
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${item.category} • ${item.location}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                                          const SizedBox(width: 3),
                                          Text(
                                            item.rating,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCFCE7),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              item.badge,
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF16A34A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Specialty Tag
                            Text(
                              item.specialty,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF475569),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // "View Shop" Outlined Button
                            SizedBox(
                              width: double.infinity,
                              height: 38,
                              child: OutlinedButton(
                                key: Key('view_shop_btn_${item.id}'),
                                onPressed: () => _openShop(item),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF6366F1), width: 1.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Shop',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF6366F1),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF6366F1)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
