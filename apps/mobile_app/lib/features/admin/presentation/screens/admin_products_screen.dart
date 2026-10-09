import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/api_service.dart';
import '../../../products/cubit/products_cubit.dart';
import '../../data/admin_mock_data.dart';
import '../widgets/admin_product_card.dart';
import '../widgets/admin_top_header.dart';
import 'admin_ads_management_screen.dart';

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
  String _selectedFilterPrefix = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  List<AdminCatalogProduct> _liveProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final apiService = context.read<ApiService>();
      final listings = await apiService.getListings(status: 'all');
      if (!mounted) return;
      if (listings.isNotEmpty) {
        setState(() {
          _liveProducts = listings.map((l) => AdminCatalogProduct.fromMarketListing(l)).toList();
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _liveProducts = List.from(AdminMockData.catalogProducts);
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(AdminCatalogProduct item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Product',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
        content: Text(
          'Are you sure you want to delete "${item.title}" from the catalog and live database?',
          style: GoogleFonts.inter(fontSize: 13.5, color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Delete', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final apiService = context.read<ApiService>();
      final success = await apiService.deleteListing(item.id);
      if (!mounted) return;

      if (success) {
        setState(() {
          _liveProducts.removeWhere((p) => p.id == item.id);
        });

        // Trigger ProductsCubit reload so buyer view syncs immediately
        try {
          context.read<ProductsCubit>().loadInitialData();
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "${item.title}" from live database'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete product from database'),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filters {
    final allCount = _liveProducts.length;
    final activeCount = _liveProducts.where((p) => p.status == 'Active').length;
    final draftCount = _liveProducts.where((p) => p.status == 'Draft').length;
    final pendingCount = _liveProducts.where((p) => p.status == 'Pending').length;
    final outStockCount = _liveProducts.where((p) => !p.isInStock || p.status == 'Out Stock').length;

    return [
      'All ($allCount)',
      'Active ($activeCount)',
      'Draft ($draftCount)',
      'Pending ($pendingCount)',
      'Out Stock ($outStockCount)',
    ];
  }

  List<AdminCatalogProduct> get _filteredProducts {
    final source = _liveProducts.isNotEmpty ? _liveProducts : AdminMockData.catalogProducts;
    return source.where((prod) {
      // Filter by chip prefix
      if (_selectedFilterPrefix == 'Active' && prod.status != 'Active') return false;
      if (_selectedFilterPrefix == 'Draft' && prod.status != 'Draft') return false;
      if (_selectedFilterPrefix == 'Out Stock' && (prod.isInStock && prod.status != 'Out Stock')) return false;
      if (_selectedFilterPrefix == 'Pending' && prod.status != 'Pending') return false;

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

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: const Color(0xFF7C3AED),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
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
                              'Sharma Electronics • Live Database Connected',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B), size: 20),
                              tooltip: 'Refresh Database',
                              onPressed: _loadProducts,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AdminAdsManagementScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.campaign_outlined, color: Color(0xFF475569), size: 15),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ads',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: widget.onAddProduct,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
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
                          hintText: 'Search products, category or SKU...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
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
                        final isSelected = filter.startsWith(_selectedFilterPrefix);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (filter.startsWith('All')) {
                                _selectedFilterPrefix = 'All';
                              } else if (filter.startsWith('Active')) {
                                _selectedFilterPrefix = 'Active';
                              } else if (filter.startsWith('Draft')) {
                                _selectedFilterPrefix = 'Draft';
                              } else if (filter.startsWith('Pending')) {
                                _selectedFilterPrefix = 'Pending';
                              } else if (filter.startsWith('Out Stock')) {
                                _selectedFilterPrefix = 'Out Stock';
                              }
                            });
                          },
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filtered.length} products found',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7C3AED)),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Products List
                  if (_isLoading && _liveProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                      ),
                    )
                  else if (filtered.isEmpty)
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
                          onDelete: () => _deleteProduct(item),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
