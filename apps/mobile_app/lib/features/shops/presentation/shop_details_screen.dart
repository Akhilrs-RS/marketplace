import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/presentation/widgets/trusted_business_card.dart';
import '../../products/presentation/car_details_screen.dart';

class ShopListingItem {
  final String id;
  final String title;
  final String price;
  final String imagePath;
  final String location;
  final String category;
  final String badge;

  const ShopListingItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.location,
    required this.category,
    this.badge = 'Verified',
  });
}

class ShopDetailsData {
  final String id;
  final String name;
  final String rating;
  final String reviewCount;
  final String category;
  final String location;
  final String imagePath;
  final String coverPath;
  final String verifiedBadge;
  final String description;
  final String phone;
  final String email;
  final String memberSince;
  final String responseRate;
  final List<ShopListingItem> listings;

  const ShopDetailsData({
    required this.id,
    required this.name,
    required this.rating,
    this.reviewCount = '120+ reviews',
    required this.category,
    required this.location,
    required this.imagePath,
    this.coverPath = 'assets/images/h.png',
    this.verifiedBadge = 'Verified Business',
    required this.description,
    this.phone = '+91 98470 12345',
    this.email = 'contact@marketplace.com',
    this.memberSince = 'Member since 2022',
    this.responseRate = '98% Response Rate',
    this.listings = const [],
  });
}

class ShopRegistry {
  static final Map<String, ShopDetailsData> _registry = {
    'Greenfield Realtors': const ShopDetailsData(
      id: 'shop_greenfield',
      name: 'Greenfield Realtors',
      rating: '4.8',
      reviewCount: '142 reviews',
      category: 'Property',
      location: 'Kowdiar, Thiruvananthapuram',
      imagePath: 'assets/images/h2.png',
      coverPath: 'assets/images/h2.png',
      verifiedBadge: 'RERA Certified Agency',
      description:
          'Premier real estate consultancy specializing in luxury residential apartments, independent sea-facing villas, and clear-deed commercial plots across South Kerala.',
      phone: '+91 94471 88920',
      email: 'sales@greenfieldrealtors.in',
      memberSince: 'Member since 2021',
      responseRate: '99% Response Rate',
      listings: [
        ShopListingItem(
          id: 'gf_1',
          title: '3BHK Apartment - Kowdiar',
          price: '₹ 95,00,000',
          imagePath: 'assets/images/h2.png',
          location: 'Kowdiar, TVM',
          category: 'Apartments',
          badge: 'Ready to Move',
        ),
        ShopListingItem(
          id: 'gf_2',
          title: '2BHK Seaside Flat',
          price: '₹ 80,00,000',
          imagePath: 'assets/images/h2.png',
          location: 'Thiruvananthapuram',
          category: 'Apartments',
          badge: 'Sea Facing',
        ),
        ShopListingItem(
          id: 'gf_3',
          title: 'Residential Villa Plot',
          price: '₹ 18 Lakh / Cent',
          imagePath: 'assets/images/h8.png',
          location: 'Pattom, TVM',
          category: 'Plots',
          badge: 'Clear Deed',
        ),
        ShopListingItem(
          id: 'gf_4',
          title: 'Luxury 4BHK Gated Villa',
          price: '₹ 1.45 Crore',
          imagePath: 'assets/images/h2.png',
          location: 'Kakkanad, Kochi',
          category: 'Villas',
          badge: 'Clubhouse',
        ),
      ],
    ),
    'TechZone Electronics': const ShopDetailsData(
      id: 'shop_techzone',
      name: 'TechZone Electronics',
      rating: '4.8',
      reviewCount: '210 reviews',
      category: 'Electronics',
      location: 'MG Road, Kochi',
      imagePath: 'assets/images/h5.png',
      coverPath: 'assets/images/h5.png',
      verifiedBadge: 'Authorized Apple & Sony Partner',
      description:
          'Official dealer and premium distributor for latest generation laptops, hi-res audiophile gear, mirrorless cameras, and 4K displays with comprehensive brand warranty.',
      phone: '+91 98950 55410',
      email: 'support@techzonekochi.com',
      memberSince: 'Member since 2020',
      responseRate: '97% Response Rate',
      listings: [
        ShopListingItem(
          id: 'tz_1',
          title: 'MacBook Air M2 13"',
          price: '₹ 98,000',
          imagePath: 'assets/images/h5.png',
          location: 'MG Road, Kochi',
          category: 'Laptops',
          badge: 'AppleCare+',
        ),
        ShopListingItem(
          id: 'tz_2',
          title: 'Sony WH-1000XM5 ANC',
          price: '₹ 24,990',
          imagePath: 'assets/images/h5.png',
          location: 'Panampilly Nagar',
          category: 'Audio',
          badge: 'Brand Warranty',
        ),
        ShopListingItem(
          id: 'tz_3',
          title: 'Dell XPS 13 InfinityEdge',
          price: '₹ 64,500',
          imagePath: 'assets/images/h5.png',
          location: 'Kochi',
          category: 'Laptops',
          badge: 'Certified Pre-Owned',
        ),
        ShopListingItem(
          id: 'tz_4',
          title: 'LG 55" 4K OLED evo Smart TV',
          price: '₹ 1,14,990',
          imagePath: 'assets/images/h5.png',
          location: 'MG Road, Kochi',
          category: 'Displays',
          badge: 'Dolby Vision',
        ),
      ],
    ),
    'Lumen Labs': const ShopDetailsData(
      id: 'shop_lumen',
      name: 'Lumen Labs',
      rating: '4.6',
      reviewCount: '85 reviews',
      category: 'Jobs',
      location: 'Remote / InfoPark, Kochi',
      imagePath: 'assets/images/h3.png',
      coverPath: 'assets/images/h3.png',
      verifiedBadge: 'Verified Tech Employer',
      description:
          'Engineering and design venture shaping high-throughput cross-platform applications and AI agents. We are actively hiring senior developers, designers, and cloud architects.',
      phone: '+91 80 4455 6677',
      email: 'careers@lumenlabs.ai',
      memberSince: 'Member since 2023',
      responseRate: '95% Response Rate',
      listings: [
        ShopListingItem(
          id: 'lm_1',
          title: 'Senior Frontend Engineer',
          price: '₹ 18 - 24 LPA',
          imagePath: 'assets/images/h3.png',
          location: 'Bengaluru / Remote',
          category: 'Engineering',
          badge: 'Full-time',
        ),
        ShopListingItem(
          id: 'lm_2',
          title: 'Lead UI/UX Designer',
          price: '₹ 12 - 16 LPA',
          imagePath: 'assets/images/h3.png',
          location: 'InfoPark, Kochi',
          category: 'Design',
          badge: 'Remote Friendly',
        ),
        ShopListingItem(
          id: 'lm_3',
          title: 'Cloud DevOps Architect',
          price: '₹ 20 - 28 LPA',
          imagePath: 'assets/images/h3.png',
          location: 'Bengaluru',
          category: 'DevOps',
          badge: 'Immediate Joiner',
        ),
      ],
    ),
  };

  static ShopDetailsData getShop(dynamic input) {
    if (input is ShopDetailsData) return input;
    if (input is TrustedBusinessItem) {
      if (_registry.containsKey(input.name)) {
        return _registry[input.name]!;
      }
      return ShopDetailsData(
        id: 'shop_${input.name.toLowerCase().replaceAll(' ', '_')}',
        name: input.name,
        rating: input.rating,
        category: input.categoryLocation.split('•').first.trim(),
        location: input.categoryLocation.contains('•')
            ? input.categoryLocation.split('•').last.trim()
            : 'Kerala, India',
        imagePath: input.imagePath,
        description: 'Verified professional business on the Galletrix Marketplace offering quality services and customer satisfaction.',
      );
    }
    return _registry['Greenfield Realtors']!;
  }
}

class ShopDetailsScreen extends StatefulWidget {
  final dynamic business;

  const ShopDetailsScreen({
    super.key,
    required this.business,
  });

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  late ShopDetailsData _shop;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _shop = ShopRegistry.getShop(widget.business);
  }

  void _onListingTap(ShopListingItem item) {
    if (item.category.toLowerCase().contains('car') ||
        item.title.toLowerCase().contains('creta') ||
        item.title.toLowerCase().contains('sedan')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CarDetailsScreen(
            title: item.title,
            price: item.price,
            imagePath: item.imagePath,
            location: item.location,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected ${item.title} (${item.price})'),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── 1. Hero Cover Banner with Overlapping Avatar ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1E293B),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: _isFavorite ? const Color(0xFFEF4444) : Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isFavorite ? 'Saved ${_shop.name} to favorites' : 'Removed from favorites'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shop link copied to clipboard'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _shop.coverPath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFF334155)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Business Profile Header ──
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar & Badges Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            _shop.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: const Color(0xFF6366F1),
                              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF16A34A)),
                                    const SizedBox(width: 4),
                                    Text(
                                      _shop.verifiedBadge,
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 3),
                                  Text(
                                    _shop.rating,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${_shop.reviewCount})',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Shop Name & Category Location
                    Text(
                      _shop.name,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          '${_shop.category} • ${_shop.location}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description Bio
                    Text(
                      _shop.description,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── 3. Contact Action Buttons Row ──
                    Row(
                      children: [
                        // Call Business Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Dialing ${_shop.phone}...'),
                                  backgroundColor: const Color(0xFF6366F1),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone_rounded, size: 18),
                            label: Text(
                              'Call Business',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Chat / Message Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening chat with ${_shop.name}...'),
                                  backgroundColor: const Color(0xFF1E293B),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF6366F1)),
                            label: Text(
                              'Chat / Enquire',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6366F1), width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Title: Active Catalogue / Listings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Catalogue',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${_shop.listings.length} Available',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 2-Column Catalogue Grid
                    if (_shop.listings.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No active listings at the moment.',
                            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _shop.listings.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (ctx, index) {
                          final item = _shop.listings[index];
                          return GestureDetector(
                            onTap: () => _onListingTap(item),
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
                                  // Product Image
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.asset(
                                            item.imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) => Container(
                                              color: const Color(0xFFF1F5F9),
                                              child: const Icon(Icons.image_outlined, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          left: 6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.65),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.badge,
                                              style: GoogleFonts.inter(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Product Info
                                  Padding(
                                    padding: const EdgeInsets.all(9),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
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
                                            fontSize: 9.5,
                                            color: const Color(0xFF64748B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.price,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF4F46E5),
                                          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
