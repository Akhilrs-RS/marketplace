import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/admin_mock_data.dart';
import '../widgets/admin_product_card.dart';
import '../widgets/admin_top_header.dart';

class AdminProductsScreen extends StatefulWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onAddProduct;

  const AdminProductsScreen({
    super.key,
    required this.onNotificationsTap,
    required this.onAvatarTap,
    required this.onAddProduct,
  });

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _selectedFilter = 'Active 4';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All (6)',
    'Active 4',
    'Draft 1',
    'Pending',
    'Out Stock 1',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminCatalogProduct> get _filteredProducts {
    return AdminMockData.catalogProducts.where((prod) {
      // Filter by chip
      if (_selectedFilter == 'Active 4' && prod.status != 'Active') return false;
      if (_selectedFilter == 'Draft 1' && prod.status != 'Draft') return false;
      if (_selectedFilter == 'Out Stock 1' && prod.status != 'Out Stock') return false;
      if (_selectedFilter == 'Pending' && prod.status != 'Pending') return false;

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return prod.title.toLowerCase().contains(q) ||
            prod.categoryAndSku.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Dark Header ──
          AdminTopHeader(
            userName: 'Zara Philip',
            avatarUrl: 'assets/images/user_avatar.jpg',
            onNotificationsTap: widget.onNotificationsTap,
            onAvatarTap: widget.onAvatarTap,
          ),

          const SizedBox(height: 8),

          // ── White Curved Sheet ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title & Subtitle ("Products" & "Sharma Electronics")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Products',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sharma Electronics',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: widget.onAddProduct,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Add',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search products, category or brand...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening filter options...')),
                            );
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Horizontal Status Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final filter = _filters[idx];
                      final isSelected = _selectedFilter == filter;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filter,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Products Count / Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${filtered.length} products found',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Products List
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'No products match this filter',
                            style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, index) {
                      final item = filtered[index];
                      return AdminProductCard(
                        product: item,
                        onEdit: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Editing "${item.title}"...')),
                          );
                        },
                        onDelete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Removed "${item.title}"')),
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
