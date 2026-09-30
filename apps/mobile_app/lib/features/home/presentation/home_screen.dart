import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/cubit/products_cubit.dart';
import 'widgets/category_card.dart';
import 'widgets/featured_near_you_card.dart';
import 'widgets/figma_hero_section.dart';
import 'widgets/fresh_listing_tile.dart';
import 'widgets/seller_cta_banner.dart';
import 'widgets/trusted_business_card.dart';
import '../../categories/presentation/vehicles_screen.dart';
import '../../categories/presentation/category_browse_screen.dart';
import '../../products/presentation/car_details_screen.dart';
import '../../selling/presentation/selling_page_screen.dart';
import '../../shops/presentation/shop_details_screen.dart';
import '../../shops/presentation/trusted_businesses_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenCart;
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenProfile;
  final VoidCallback? onStartSelling;

  const HomeScreen({
    super.key,
    required this.onOpenCart,
    this.onOpenSearch,
    this.onOpenNotifications,
    this.onOpenProfile,
    this.onStartSelling,
  });

  // The 8 categories mapped to images h1.png through h8.png in exact order
  static const List<CategoryItemData> figmaCategories = [
    CategoryItemData(
      imagePath: 'assets/images/h1.png',
      title: 'Vehicles',
      subtitle: 'Car, truck, commercial',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h2.png',
      title: 'Property',
      subtitle: 'Buy, sell & rent',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h3.png',
      title: 'Jobs',
      subtitle: 'Full-time, part - time',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h4.png',
      title: 'Groceries',
      subtitle: 'Daily essentials',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h5.png',
      title: 'Electronics',
      subtitle: 'Laptops, audio & appliances',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h6.png',
      title: 'Mobiles',
      subtitle: 'Phones, tablets, Accessories',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h7.png',
      title: 'Services',
      subtitle: 'Professional & home services',
    ),
    CategoryItemData(
      imagePath: 'assets/images/h8.png',
      title: 'Furniture',
      subtitle: 'Home, office & decor',
    ),
  ];

  // Fresh listings from the Figma screenshot
  static const List<FreshListingItem> freshListings = [
    FreshListingItem(
      imagePath: 'assets/images/h1.png',
      title: '2024 Hyundai Creta SX',
      price: '₹ 16.5 Lakh',
      location: 'Kochi',
      sellerType: 'Owner',
      isNew: true,
    ),
    FreshListingItem(
      imagePath: 'assets/images/h2.png',
      title: '3BHK Apartment in Kakkanad',
      price: '₹ 1.25 Crore',
      location: 'Kochi',
      sellerType: 'Business',
      isNew: true,
    ),
    FreshListingItem(
      imagePath: 'assets/images/h3.png',
      title: 'Senior Frontend Engineer',
      price: '₹ 18-24 LPA',
      location: 'Bengaluru',
      sellerType: 'Employer',
      isNew: true,
    ),
    FreshListingItem(
      imagePath: 'assets/images/h8.png',
      title: '2BHK Apartment in Kakkanad',
      price: '₹ 95,000',
      location: 'Kochi',
      sellerType: 'Business',
      isNew: false,
    ),
  ];

  // Featured Near You items from the Figma screenshot
  static const List<FeaturedNearYouItem> featuredNearYouItems = [
    FeaturedNearYouItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 7,25,000',
      title: '2021 Hyundai Creta SX',
      location: 'Thiruvananthapuram',
    ),
    FeaturedNearYouItem(
      imagePath: 'assets/images/h2.png',
      price: '₹ 80,00,000',
      title: '2BHK Apartment - Seaside',
      location: 'Thiruvananthapuram',
    ),
    FeaturedNearYouItem(
      imagePath: 'assets/images/h1.png',
      price: '₹ 8,50,000',
      title: 'Sedan 2022 Edition',
      location: 'Kollam',
    ),
  ];

  // Discover Trusted Business items from the Figma screenshot
  static const List<TrustedBusinessItem> trustedBusinesses = [
    TrustedBusinessItem(
      imagePath: 'assets/images/h2.png',
      name: 'Greenfield Realtors',
      rating: '4.8',
      categoryLocation: 'Property • Thiruvananthapuram',
    ),
    TrustedBusinessItem(
      imagePath: 'assets/images/h3.png',
      name: 'Lumen Labs',
      rating: '4.6',
      categoryLocation: 'Jobs • Remote',
    ),
    TrustedBusinessItem(
      imagePath: 'assets/images/h5.png',
      name: 'TechZone Electronics',
      rating: '4.7',
      categoryLocation: 'Electronics • Remote',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductsCubit>().loadInitialData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Section (h.png + Branding + Headline + Search Capsule)
              FigmaHeroSection(
                onSearchChanged: (val) {
                  context.read<ProductsCubit>().search(val);
                },
                onSearchSubmit: onOpenSearch ?? () {},
                onNotificationTap: onOpenNotifications,
                onProfileTap: onOpenProfile,
              ),

              // 2. White Curved Main Content Sheet
              Transform.translate(
                offset: const Offset(0, -22),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── SECTION 1: Browse by category ──
                      Text(
                        'Browse by category',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Curated collections across every need',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2x4 Categories Grid (h1 to h8 in order)
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: figmaCategories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10,
                          childAspectRatio: 86 / 136, // Exact proportions from Figma
                        ),
                        itemBuilder: (ctx, index) {
                          final item = figmaCategories[index];
                          return CategoryCard(
                            data: item,
                            onTap: () {
                              context.read<ProductsCubit>().selectCategory(item.title.toLowerCase());
                              if (item.title == 'Vehicles') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const VehiclesScreen()),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryBrowseScreen(categoryTitle: item.title),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // ── SECTION 2: Fresh Listings ──
                      Text(
                        'Fresh listings',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Fresh listings catching attention right now',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Vertical list of 4 Fresh Listing tiles
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: freshListings.length,
                        itemBuilder: (ctx, i) {
                          final item = freshListings[i];
                          return FreshListingTile(
                            item: item,
                            onTap: () {
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
                            },
                          );
                        },
                      ),

                      // ── SECTION 3: Turn What you have into your next opportunity (CTA) ──
                      SellerCtaBanner(
                        onStartSelling: onStartSelling ?? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SellingPageScreen(),
                            ),
                          );
                        },
                      ),

                      // ── SECTION 4: Featured Near You ──
                      Text(
                        'Featured Near You',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Premium listings from trusted sellers and businesses.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal carousel of featured items
                      SizedBox(
                        height: 186,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredNearYouItems.length,
                          itemBuilder: (ctx, i) {
                            final item = featuredNearYouItems[i];
                            return FeaturedNearYouCard(
                              item: item,
                              onTap: () {
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
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── SECTION 5: Discover Trusted Business ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discover Trusted Business',
                                  style: GoogleFonts.inter(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Verified shops and business on the marketplace.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: GestureDetector(
                              key: const Key('home_view_all_trusted_btn'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TrustedBusinessesScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 13,
                                    color: Color(0xFF1E293B),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // List of Trusted Business cards
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: trustedBusinesses.length,
                        itemBuilder: (ctx, i) {
                          return TrustedBusinessCard(
                            key: Key('trusted_biz_card_$i'),
                            item: trustedBusinesses[i],
                            onViewShop: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShopDetailsScreen(
                                    business: trustedBusinesses[i],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
