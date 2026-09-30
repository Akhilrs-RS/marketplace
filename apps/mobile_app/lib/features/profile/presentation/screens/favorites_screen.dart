import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../products/presentation/car_details_screen.dart';

class FavoriteListing {
  final String id;
  final String title;
  final String price;
  final String location;
  final String category;
  final String imagePath;

  const FavoriteListing({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.category,
    required this.imagePath,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<FavoriteListing> _favorites = [
    const FavoriteListing(
      id: 'fav_1',
      title: 'Hyundai Creta SX(O) 1.5 Turbo',
      price: '₹ 14,80,000',
      location: 'Kowdiar, Thiruvananthapuram',
      category: 'Vehicles',
      imagePath: 'assets/images/h1.png',
    ),
    const FavoriteListing(
      id: 'fav_2',
      title: '3BHK Sea-Facing Luxury Villa',
      price: '₹ 95,00,000',
      location: 'Kowdiar, Thiruvananthapuram',
      category: 'Property',
      imagePath: 'assets/images/h2.png',
    ),
    const FavoriteListing(
      id: 'fav_3',
      title: 'Sony WH-1000XM5 Wireless ANC',
      price: '₹ 24,990',
      location: 'MG Road, Kochi',
      category: 'Electronics',
      imagePath: 'assets/images/h5.png',
    ),
  ];

  void _removeFavorite(FavoriteListing item) {
    final index = _favorites.indexOf(item);
    setState(() {
      _favorites.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${item.title}" from favorites'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _favorites.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'My Favorites (${_favorites.length})',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 36, color: Color(0xFFEF4444)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites saved yet',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Browse marketplace items and tap the heart icon.',
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = _favorites[i];
                return InkWell(
                  onTap: () {
                    if (item.category == 'Vehicles') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarDetailsScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing ${item.title}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 76,
                            height: 76,
                            color: const Color(0xFFF1F5F9),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.category.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6366F1),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.price,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.location,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          key: Key('remove_fav_${item.id}'),
                          icon: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444)),
                          onPressed: () => _removeFavorite(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
