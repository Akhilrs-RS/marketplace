import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_service.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../products/presentation/car_details_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class ExploreListingItem {
  final String imagePath;
  final String price;
  final String title;
  final String location;
  final String category;

  const ExploreListingItem({
    required this.imagePath,
    required this.price,
    required this.title,
    required this.location,
    required this.category,
  });
}

class ExploreScreen extends StatefulWidget {
  final String? initialQuery;
  final bool autoFocus;

  const ExploreScreen({
    super.key,
    this.initialQuery,
    this.autoFocus = false,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<ExploreListingItem> _liveListings = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchQuery = widget.initialQuery!.trim();
    }
    _loadLiveListings();
  }

  @override
  void didUpdateWidget(ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != null && widget.initialQuery != oldWidget.initialQuery) {
      _searchController.text = widget.initialQuery!;
      setState(() {
        _searchQuery = widget.initialQuery!.trim();
      });
    }
  }

  Future<void> _loadLiveListings() async {
    try {
      final items = await ApiService().getListings();
      if (items.isNotEmpty && mounted) {
        setState(() {
          _liveListings = items.map((e) => ExploreListingItem(
            imagePath: e.imagePath,
            price: e.formattedPrice,
            title: e.title,
            location: e.location,
            category: e.category,
          )).toList();
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // All listings - starting with the exact 11 items matching Figma screenshot
  final List<ExploreListingItem> _allListings = const [
    // 1. Vehicles
    ExploreListingItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 7,25,000',
      title: '2022 Hyundai Creta EX',
      location: 'Thiruvananthapuram',
      category: 'Vehicles',
    ),
    // 2. Property
    ExploreListingItem(
      imagePath: 'assets/images/h2.png',
      price: '₹ 95,00,000',
      title: '3BHK Apartment -\nKowdiar',
      location: 'Thiruvananthapuram',
      category: 'Property',
    ),
    // 3. Property
    ExploreListingItem(
      imagePath: 'assets/images/h8.png',
      price: '₹ 42,000 /mo',
      title: 'Sushil 2BHK\nApartment',
      location: 'HSR Layout, Bengaluru',
      category: 'Property',
    ),
    // 4. Furniture
    ExploreListingItem(
      imagePath: 'assets/images/h.png',
      price: '₹ 7,25,000',
      title: 'Solid Oak Dining\nTable',
      location: 'HSR Layout, Bengaluru',
      category: 'Furniture',
    ),
    // 5. Mobiles
    ExploreListingItem(
      imagePath: 'assets/images/h6.png',
      price: '₹ 62,900',
      title: 'Flagship Phone -\n256GB',
      location: 'Thiruvananthapuram',
      category: 'Mobiles',
    ),
    // 6. Jobs
    ExploreListingItem(
      imagePath: 'assets/images/h3.png',
      price: '₹ 18 - 24 LPA',
      title: 'Senior Frontend\nEngineer',
      location: 'Bengaluru',
      category: 'Jobs',
    ),
    // 7. Property
    ExploreListingItem(
      imagePath: 'assets/images/h2.png',
      price: '₹ 1.25 Crore',
      title: '3BHK Apartment in\nKakkanad',
      location: 'Bengaluru',
      category: 'Property',
    ),
    // 8. Groceries
    ExploreListingItem(
      imagePath: 'assets/images/h4.png',
      price: '₹ 499',
      title: 'Organic Vegetables\nCombo Pack',
      location: 'Kakkanad',
      category: 'Groceries',
    ),
    // 9. Services
    ExploreListingItem(
      imagePath: 'assets/images/h7.png',
      price: '₹ 2,500',
      title: 'Home Deep\nCleaning Service',
      location: 'Kakkanad',
      category: 'Services',
    ),
    // 10. Mobiles (Electronics/Devices)
    ExploreListingItem(
      imagePath: 'assets/images/h5.png',
      price: '₹ 98,000',
      title: 'MacBook Air M2 13"',
      location: 'Kochi',
      category: 'Mobiles',
    ),
    // 11. Furniture
    ExploreListingItem(
      imagePath: 'assets/images/h.png',
      price: '₹ 7,25,000',
      title: 'Solid Oak Dining\nTable',
      location: 'HSR Layout, Bengaluru',
      category: 'Furniture',
    ),

    // Additional category items for rich filtering
    // More Mobiles ads
    ExploreListingItem(
      imagePath: 'assets/images/h6.png',
      price: '₹ 1,34,900',
      title: 'iPhone 15 Pro\nMax 256GB',
      location: 'Indiranagar, Bengaluru',
      category: 'Mobiles',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h6.png',
      price: '₹ 1,09,999',
      title: 'Samsung Galaxy\nS24 Ultra 5G',
      location: 'HSR Layout, Bengaluru',
      category: 'Mobiles',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h6.png',
      price: '₹ 64,999',
      title: 'OnePlus 12 5G\n16GB / 512GB',
      location: 'Koramangala, Bengaluru',
      category: 'Mobiles',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h6.png',
      price: '₹ 74,999',
      title: 'Google Pixel 8\nPro 128GB Mint',
      location: 'Whitefield, Bengaluru',
      category: 'Mobiles',
    ),

    // More Vehicles ads
    ExploreListingItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 14,50,000',
      title: '2021 Kia Seltos\nGTX+ Diesel',
      location: 'HSR Layout, Bengaluru',
      category: 'Vehicles',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 18,20,000',
      title: '2023 Tata Harrier\nXZ+ Dark Edition',
      location: 'Indiranagar, Bengaluru',
      category: 'Vehicles',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 9,80,000',
      title: '2020 Honda City\nZX CVT Petrol',
      location: 'Kochi',
      category: 'Vehicles',
    ),

    // More Property ads
    ExploreListingItem(
      imagePath: 'assets/images/h2.png',
      price: '₹ 2.85 Crore',
      title: '4BHK Luxury Villa\nwith Garden',
      location: 'Whitefield, Bengaluru',
      category: 'Property',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h2.png',
      price: '₹ 1.80 Crore',
      title: '3BHK Penthouse\nTerrace View',
      location: 'Indiranagar, Bengaluru',
      category: 'Property',
    ),

    // More Jobs ads
    ExploreListingItem(
      imagePath: 'assets/images/h3.png',
      price: '₹ 14 - 20 LPA',
      title: 'UI/UX Product\nDesigner',
      location: 'Bengaluru',
      category: 'Jobs',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h3.png',
      price: '₹ 22 - 30 LPA',
      title: 'Mobile Flutter\nLead Engineer',
      location: 'Bengaluru',
      category: 'Jobs',
    ),

    // More Services ads
    ExploreListingItem(
      imagePath: 'assets/images/h7.png',
      price: '₹ 16,500',
      title: 'Full Apartment\nPainting Service',
      location: 'Bengaluru',
      category: 'Services',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h7.png',
      price: '₹ 799',
      title: 'Professional AC\nService & Repair',
      location: 'HSR Layout, Bengaluru',
      category: 'Services',
    ),

    // More Furniture ads
    ExploreListingItem(
      imagePath: 'assets/images/h8.png',
      price: '₹ 38,500',
      title: 'Modern Velvet\nL-Shaped Sofa',
      location: 'Indiranagar, Bengaluru',
      category: 'Furniture',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h.png',
      price: '₹ 14,200',
      title: 'Ergonomic Solid\nTeak Work Desk',
      location: 'Bengaluru',
      category: 'Furniture',
    ),

    // More Groceries ads
    ExploreListingItem(
      imagePath: 'assets/images/h4.png',
      price: '₹ 890',
      title: 'Farm Fresh Exotic\nFruit Hamper',
      location: 'Bengaluru',
      category: 'Groceries',
    ),
    ExploreListingItem(
      imagePath: 'assets/images/h4.png',
      price: '₹ 1,750',
      title: 'Organic Cold\nPressed Oils 5L',
      location: 'Bengaluru',
      category: 'Groceries',
    ),
  ];

  // Filtered listings based on selected category and search query
  List<ExploreListingItem> get _filteredListings {
    final combined = [..._liveListings, ..._allListings];
    final seen = <String>{};
    final uniqueListings = <ExploreListingItem>[];
    for (final item in combined) {
      final key = '${item.title.toLowerCase().trim()}_${item.price}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueListings.add(item);
      }
    }

    return uniqueListings.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.price.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filteredListings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Explore',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1E293B),
                    size: 19,
                  ),
                  Positioned(
                    top: 7,
                    right: 8,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Pill
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 19),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      key: const Key('explore_search_input'),
                      controller: _searchController,
                      autofocus: widget.autoFocus,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search in the marketplace',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 18),
                      ),
                    ),
                  const Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8), size: 19),
                ],
              ),
            ),

            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Trending:',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...['Hyundai Creta', 'iPhone 15', '3BHK Apartment', 'MacBook', 'Dining Table'].map((tag) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          key: Key('quick_search_tag_$tag'),
                          label: Text(tag),
                          labelStyle: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF475569)),
                          backgroundColor: const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide.none,
                          onPressed: () {
                            _searchController.text = tag;
                            setState(() {
                              _searchQuery = tag;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // 2-Row Category Filter Chips matching Figma
            Row(
              children: [
                _buildChip('All'),
                const SizedBox(width: 6),
                _buildChip('Vehicles'),
                const SizedBox(width: 6),
                _buildChip('Property'),
                const SizedBox(width: 6),
                _buildChip('Jobs'),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                _buildChip('Mobiles'),
                const SizedBox(width: 6),
                _buildChip('Services'),
                const SizedBox(width: 6),
                _buildChip('Furniture'),
                const SizedBox(width: 6),
                _buildChip('Groceries'),
              ],
            ),

            const SizedBox(height: 18),

            // Subtitle: ALL AROUND BENGALURU
            Row(
              children: [
                Text(
                  'ALL AROUND BENGALURU',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEDE9FE),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 9,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Results count + Dark Filter Icon button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 'All' && _searchQuery.isEmpty
                      ? '128 Results'
                      : '${listings.length} ${listings.length == 1 ? 'Result' : 'Results'}',
                  style: GoogleFonts.inter(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Sorters (Within 10 Km, Recommended ⌵)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Within 10 Km',
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                ),
                Row(
                  children: [
                    Text(
                      'Recommended',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: Color(0xFF64748B)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (_searchQuery.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing ${listings.length} ${listings.length == 1 ? "result" : "results"} for "$_searchQuery"',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4338CA),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Text(
                        'Clear',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 3-Column Results Grid or Empty State
            if (listings.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    Text(
                      'No listings found',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'No ads found matching "$_searchQuery" in "$_selectedCategory".'
                          : 'No ads found in "$_selectedCategory". Try selecting another category.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'All';
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Show All Listings'),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listings.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Exactly 3 columns matching Figma
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (ctx, index) {
                  final item = listings[index];
                  return GestureDetector(
                    onTap: () {
                      if (item.category == 'Vehicles' || item.title.contains('Creta')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CarDetailsScreen(
                              title: item.title.replaceAll('\n', ' '),
                              price: item.price,
                              imagePath: item.imagePath,
                              location: item.location,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${item.title.replaceAll('\n', ' ')}'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: const Color(0xFFF1F5F9),
                                  child: const Icon(Icons.image_outlined, size: 18, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),

                          // Details
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.price,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 8.8,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF334155),
                                    height: 1.15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 7.8,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = label == _selectedCategory;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        child: Container(
          height: 28,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
