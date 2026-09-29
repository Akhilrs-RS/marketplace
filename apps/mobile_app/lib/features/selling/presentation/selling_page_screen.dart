import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellingPageScreen extends StatefulWidget {
  const SellingPageScreen({super.key});

  @override
  State<SellingPageScreen> createState() => _SellingPageScreenState();
}

class _SellingPageScreenState extends State<SellingPageScreen> {
  int _selectedType = 0; // 0: Individual, 1: Business Shop
  String _selectedFilter = 'All';

  final List<String> _statusFilters = [
    'All',
    'Active',
    'Draft',
    'Pending',
    'Paused',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Your Marketplace',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(
              Icons.sync_rounded,
              color: Color(0xFF1E293B),
              size: 20,
            ),
          ),
          Container(
            width: 38,
            height: 38,
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Segmented Profile Switcher: Individual vs Business Shop
            Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedType == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _selectedType == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Individual',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: _selectedType == 0 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedType == 0 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedType == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _selectedType == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Business Shop',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: _selectedType == 1 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedType == 1 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Performance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Month',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Performance',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.north_east_rounded, size: 12, color: Color(0xFF10B981)),
                            const SizedBox(width: 3),
                            Text(
                              '16 %',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4 Stats in row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('12', 'Active'),
                      _buildStatDivider(),
                      _buildStatItem('2.4k', 'Views'),
                      _buildStatDivider(),
                      _buildStatItem('38', 'Enquiries'),
                      _buildStatDivider(),
                      _buildStatItem('7', 'Messages'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Prominent "+ Add a listing" Purple Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCreateListingSheet(context);
                },
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                label: Text(
                  'Add a listing',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1), // Royal Purple/Indigo from Figma
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Your Catalogue / My Listings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Catalogue',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'My Listings',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Manage all',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Status Filter Chips
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _statusFilters.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final filter = _statusFilters[i];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter,
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

            const SizedBox(height: 16),

            // Listing Items
            _buildMyListingTile(
              imagePath: 'assets/images/h1.png',
              title: '2024 Hyundai Creta SX',
              status: 'Active',
              location: 'Kochi',
              sellerRole: 'Dealer',
            ),
            const SizedBox(height: 10),
            _buildMyListingTile(
              imagePath: 'assets/images/h2.png',
              title: '3BHK Apartment in Kakkanad',
              status: 'Active',
              location: 'Kochi',
              sellerRole: 'Business',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 24,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildMyListingTile({
    required String imagePath,
    required String title,
    required String status,
    required String location,
    required String sellerRole,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 76,
              height: 72,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.more_vert_rounded, size: 16, color: Color(0xFF94A3B8)),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$location • $sellerRole',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateListingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a New Listing',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose what you want to sell on the marketplace',
              style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEFF6FF),
                child: Icon(Icons.directions_car_outlined, color: Color(0xFF2563EB)),
              ),
              title: const Text('Post Vehicle', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Cars, motorcycles, trucks, spare parts'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF0FDF4),
                child: Icon(Icons.apartment_outlined, color: Color(0xFF16A34A)),
              ),
              title: const Text('Post Property', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Apartments, plots, commercial rentals'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFAF5FF),
                child: Icon(Icons.devices_outlined, color: Color(0xFF9333EA)),
              ),
              title: const Text('Sell Electronics / Other', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Phones, laptops, furniture, appliances'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
