import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_listing_screen.dart';

class ListingCategoryItem {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color accentColor;
  final List<String> subcategories;

  const ListingCategoryItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.accentColor,
    required this.subcategories,
  });
}

class SelectListingCategoryScreen extends StatefulWidget {
  const SelectListingCategoryScreen({super.key});

  @override
  State<SelectListingCategoryScreen> createState() => _SelectListingCategoryScreenState();
}

class _SelectListingCategoryScreenState extends State<SelectListingCategoryScreen> {
  String _searchQuery = '';

  final List<ListingCategoryItem> _categories = const [
    ListingCategoryItem(
      title: 'Vehicles',
      description: 'Cars, Motorcycles, Scooters, Commercial Vehicles & Spare Parts',
      imagePath: 'assets/images/h1.png',
      icon: Icons.directions_car_rounded,
      accentColor: Color(0xFF6366F1),
      subcategories: ['Cars', 'Motorcycles & Scooters', 'Commercial Vehicles', 'Spare Parts & Accessories'],
    ),
    ListingCategoryItem(
      title: 'Property',
      description: 'Apartments, Houses & Villas, Builder Floors, Commercial Plots',
      imagePath: 'assets/images/h2.png',
      icon: Icons.home_work_rounded,
      accentColor: Color(0xFF0EA5E9),
      subcategories: ['For Sale: Houses & Apartments', 'For Rent: Houses & Apartments', 'Lands & Plots', 'Commercial Property'],
    ),
    ListingCategoryItem(
      title: 'Electronics',
      description: 'Laptops, Computers, TVs, Audio, Cameras & Gaming Consoles',
      imagePath: 'assets/images/h5.png',
      icon: Icons.laptop_mac_rounded,
      accentColor: Color(0xFF8B5CF6),
      subcategories: ['Laptops & Computers', 'TVs & Home Entertainment', 'Cameras & Optics', 'Audio & Speakers', 'Gaming & Consoles'],
    ),
    ListingCategoryItem(
      title: 'Mobiles & Tablets',
      description: 'Smartphones, Tablets, Smartwatches & Mobile Accessories',
      imagePath: 'assets/images/h6.png',
      icon: Icons.smartphone_rounded,
      accentColor: Color(0xFF10B981),
      subcategories: ['Smartphones', 'Tablets & iPads', 'Smart Watches', 'Mobile Accessories'],
    ),
    ListingCategoryItem(
      title: 'Furniture & Decor',
      description: 'Sofa sets, Beds & Wardrobes, Dining Tables, Office Decor',
      imagePath: 'assets/images/h7.png',
      icon: Icons.chair_rounded,
      accentColor: Color(0xFFF59E0B),
      subcategories: ['Sofa & Dining', 'Beds & Wardrobes', 'Home Decor & Garden', 'Kids Furniture'],
    ),
    ListingCategoryItem(
      title: 'Jobs & Careers',
      description: 'Full-time, Part-time, Remote, IT, Marketing, Sales, Operations',
      imagePath: 'assets/images/h3.png',
      icon: Icons.work_rounded,
      accentColor: Color(0xFF3B82F6),
      subcategories: ['Software & IT', 'Marketing & Sales', 'Customer Support', 'Design & Creative', 'Office Assistant'],
    ),
    ListingCategoryItem(
      title: 'Services',
      description: 'Home Repairs, Moving & Packers, Education, Financial, Web IT',
      imagePath: 'assets/images/h4.png',
      icon: Icons.build_rounded,
      accentColor: Color(0xFFEC4899),
      subcategories: ['Electronics Repair', 'Home Renovations', 'Tutors & Classes', 'Health & Beauty', 'Travel & Visa'],
    ),
    ListingCategoryItem(
      title: 'Fashion & Essentials',
      description: 'Clothing, Footwear, Watches, Jewelry, Books, Sports & Hobbies',
      imagePath: 'assets/images/h8.png',
      icon: Icons.checkroom_rounded,
      accentColor: Color(0xFF14B8A6),
      subcategories: ['Men Fashion', 'Women Fashion', 'Watches & Jewelry', 'Sports & Fitness', 'Books & Music'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories.where((cat) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return cat.title.toLowerCase().contains(q) ||
          cat.description.toLowerCase().contains(q) ||
          cat.subcategories.any((sub) => sub.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          key: const Key('select_category_back_button'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Select Category',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Step 1 of 4 • Choose Category',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Helper Banner
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search categories or items...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Tip',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selecting the exact category guarantees high reach to prospective buyers.',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Category List
          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'No categories found matching "$_searchQuery"',
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
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCategories.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredCategories[index];
                      return _buildCategoryCard(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, ListingCategoryItem item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        key: Key('category_card_${item.title}'),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateListingScreen(categoryItem: item),
            ),
          );
          if (result == true && context.mounted) {
            Navigator.pop(context, true);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              // Category Image / Thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: item.accentColor.withValues(alpha: 0.1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Icon(item.icon, color: item.accentColor, size: 30),
                ),
              ),
              const SizedBox(width: 14),
              // Category Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.subcategories.length} subcategories',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: item.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
