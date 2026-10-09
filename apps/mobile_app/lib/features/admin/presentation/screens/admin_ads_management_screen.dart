import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_models/shared_models.dart';
import '../../../../core/services/api_service.dart';

class AdminAdsManagementScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AdminAdsManagementScreen({
    super.key,
    this.onBack,
  });

  @override
  State<AdminAdsManagementScreen> createState() => _AdminAdsManagementScreenState();
}

class _AdminAdsManagementScreenState extends State<AdminAdsManagementScreen> {
  late ApiService _apiService;
  List<MarketListing> _listings = [];
  bool _loading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Vehicles',
    'Mobiles',
    'Property',
    'Electronics',
    'Furniture',
    'Jobs',
    'Services',
  ];

  final List<String> _presetImages = [
    'assets/images/h1.png',
    'assets/images/h2.png',
    'assets/images/h3.png',
    'assets/images/h4.png',
    'assets/images/h5.png',
    'assets/images/h6.png',
    'assets/images/h7.png',
    'assets/images/h8.png',
  ];

  @override
  void initState() {
    super.initState();
    _apiService = context.read<ApiService>();
    _loadListings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadListings() async {
    setState(() => _loading = true);
    final items = await _apiService.getListings();
    if (mounted) {
      setState(() {
        _listings = items;
        _loading = false;
      });
    }
  }

  List<MarketListing> get _filteredListings {
    return _listings.where((item) {
      if (_selectedCategory != 'All' &&
          item.category.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchSeller = item.sellerName.toLowerCase().contains(q);
        final matchLoc = item.location.toLowerCase().contains(q);
        final matchCat = item.category.toLowerCase().contains(q);
        return matchTitle || matchSeller || matchLoc || matchCat;
      }
      return true;
    }).toList();
  }

  // ── 1. Edit Product Image ──
  void _openEditImageSheet(MarketListing item) {
    String currentImg = item.imagePath;
    final textController = TextEditingController(text: currentImg);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Product Image',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),

                  // Image Preview Box
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        currentImg,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Image Path Text Field
                  Text(
                    'Image Asset / URL',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'e.g. assets/images/h5.png',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    onChanged: (val) {
                      setSheetState(() => currentImg = val);
                    },
                  ),

                  const SizedBox(height: 14),

                  // Preset Gallery Selector
                  Text(
                    'Quick Catalog Presets',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presetImages.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final path = _presetImages[idx];
                        final isSelected = currentImg == path;
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              currentImg = path;
                              textController.text = path;
                            });
                          },
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(path, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        final newImg = textController.text.trim();
                        if (newImg.isEmpty) return;
                        Navigator.pop(ctx);

                        final updated = await _apiService.updateListing(
                          item.id,
                          {'image_path': newImg},
                        );

                        if (updated != null && mounted) {
                          setState(() {
                            final idx = _listings.indexWhere((l) => l.id == item.id);
                            if (idx != -1) _listings[idx] = updated;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Updated image for "${item.title}"')),
                          );
                        }
                      },
                      child: Text(
                        'Save Image',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── 2. Remove User Ad ──
  void _confirmDeleteAd(MarketListing item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Remove User Ad?',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFFDC2626)),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${item.title}" posted by ${item.sellerName}?\n\nThis will remove it from MySQL and marketplace listings.',
            style: GoogleFonts.inter(fontSize: 13.5, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                final success = await _apiService.deleteListing(item.id);
                if (success && mounted) {
                  setState(() {
                    _listings.removeWhere((l) => l.id == item.id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed ad "${item.title}"')),
                  );
                }
              },
              child: const Text('Delete Ad', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ── 3. Add User Ad Modal ──
  void _openAddAdDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final locationController = TextEditingController(text: 'Bengaluru');
    final sellerController = TextEditingController(text: 'Admin Sponsored');
    String selectedCat = 'Vehicles';
    String selectedImg = 'assets/images/h1.png';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Publish User / Sponsored Ad',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title *'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (₹) *'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCat,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ['Vehicles', 'Mobiles', 'Property', 'Electronics', 'Furniture', 'Jobs', 'Services']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDlgState(() => selectedCat = val);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: sellerController,
                      decoration: const InputDecoration(labelText: 'Seller / User Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 12),
                    // Image picker
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(selectedImg, width: 44, height: 44, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedImg,
                            isExpanded: true,
                            items: _presetImages
                                .map((img) => DropdownMenuItem(value: img, child: Text(img)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setDlgState(() => selectedImg = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(ctx);

                    final price = double.tryParse(priceController.text) ?? 50000;
                    final newListing = MarketListing(
                      id: 'list_admin_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      price: price,
                      formattedPrice: '₹ ${price.toStringAsFixed(0)}',
                      location: locationController.text.trim(),
                      category: selectedCat,
                      subcategory: '',
                      imagePath: selectedImg,
                      description: 'Admin posted listing',
                      sellerId: 'user_admin',
                      sellerName: sellerController.text.trim(),
                      status: 'Active',
                      isFeatured: false,
                      createdAt: DateTime.now(),
                      specifications: {},
                    );

                    final created = await _apiService.createListing(newListing);
                    if (created != null && mounted) {
                      setState(() {
                        _listings.insert(0, created);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Created ad "${created.title}"')),
                      );
                    }
                  },
                  child: const Text('Publish Ad', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredListings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ads Management',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Edit images, add & remove user ads',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF475569)),
            onPressed: _loadListings,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF7C3AED)),
            onPressed: _openAddAdDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add User Ad',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        onPressed: _openAddAdDialog,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search ads by title, seller, or category...',
                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Category Filter Chips ──
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ── Count Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length} Ads Found',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Tap image to edit',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF7C3AED),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ── Listings List ──
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No ads found',
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, idx) {
                            final item = filtered[idx];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Thumbnail with Edit Badge
                                  GestureDetector(
                                    onTap: () => _openEditImageSheet(item),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFE2E8F0)),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.asset(
                                            item.imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.image_outlined,
                                              size: 28,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 2,
                                          bottom: 2,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF7C3AED),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit_rounded,
                                              size: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${item.category} • ${item.sellerName}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              item.formattedPrice,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF10B981),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 7,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCFCE7),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                item.status,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF16A34A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action Buttons
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.image_outlined,
                                          size: 20,
                                          color: Color(0xFF7C3AED),
                                        ),
                                        tooltip: 'Edit Image',
                                        onPressed: () => _openEditImageSheet(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: Color(0xFFEF4444),
                                        ),
                                        tooltip: 'Remove Ad',
                                        onPressed: () => _confirmDeleteAd(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
