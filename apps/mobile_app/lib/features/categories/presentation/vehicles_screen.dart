import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/presentation/car_details_screen.dart';

class VehicleDealership {
  final String imagePath;
  final String name;
  final String location;
  final String category;
  final String rating;
  final String badge;

  const VehicleDealership({
    required this.imagePath,
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    this.badge = 'Trusted Dealer',
  });
}

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  String _selectedSubcategory = 'Car';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> _subcategories = [
    'Car',
    'Bikes',
    'Scooters',
    'Spare Parts',
    'Commercial Vehicle',
  ];

  final List<VehicleDealership> _dealerships = const [
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Hyundai Auto Hub',
      location: 'Nedumbassery',
      category: 'Cars & SUVs',
      rating: '4.8',
    ),
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Moto World',
      location: 'Thiruvananthapuram',
      category: 'Bikes & Scooters',
      rating: '4.7',
    ),
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Maruti Car Point',
      location: 'Kondotty',
      category: 'Cars',
      rating: '4.6',
    ),
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Honda 2 Wheelers',
      location: 'Pattom',
      category: 'Bikes & Scooters',
      rating: '4.8',
    ),
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Kerala commercial Motors',
      location: 'Kondotty',
      category: 'Commercial Vehicles',
      rating: '4.6',
    ),
    VehicleDealership(
      imagePath: 'assets/images/h1.png',
      name: 'Honda 2 wheelers',
      location: 'Pattom',
      category: 'Bikes & Scooters',
      rating: '4.8',
    ),
  ];

  List<VehicleDealership> get _filteredDealerships {
    final list = _dealerships.where((d) {
      bool matchesSub = true;
      if (_selectedSubcategory == 'Car') {
        matchesSub = d.category.toLowerCase().contains('car');
      } else if (_selectedSubcategory == 'Bikes' || _selectedSubcategory == 'Scooters') {
        matchesSub = d.category.toLowerCase().contains('bike') ||
            d.category.toLowerCase().contains('scooter') ||
            d.category.toLowerCase().contains('wheeler');
      } else if (_selectedSubcategory == 'Commercial Vehicle') {
        matchesSub = d.category.toLowerCase().contains('commercial');
      }
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.location.toLowerCase().contains(q) ||
          d.category.toLowerCase().contains(q);
      return matchesSub && matchesQuery;
    }).toList();
    return list.isNotEmpty ? list : _dealerships;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredDealerships;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Vehicle',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Pill
            Container(
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
                        hintText: 'Search the vehicle',
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

            const SizedBox(height: 14),

            // Vehicle Subcategory Chips
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _subcategories.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _subcategories[i];
                  final isSelected = cat == _selectedSubcategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSubcategory = cat),
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
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 2-Column Dealerships Grid
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.69,
              ),
              itemBuilder: (ctx, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarDetailsScreen(
                          title: '${item.name} - Creta SX',
                          price: '₹ 7,25,000',
                          imagePath: item.imagePath,
                          location: item.location,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dealership / Vehicle Image
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: const Color(0xFFF1F5F9),
                                  child: const Icon(Icons.car_rental, color: Colors.grey),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_border_rounded,
                                  size: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dealership info
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.location,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.category,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                color: const Color(0xFF94A3B8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Rating and Badge
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 2),
                                Text(
                                  item.rating,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.badge,
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF10B981),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
}
