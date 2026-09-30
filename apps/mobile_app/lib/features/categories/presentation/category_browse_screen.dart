import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/presentation/car_details_screen.dart';

/// Data model representing a curated merchant / business / item card in a category screen.
class CategoryMerchantCardData {
  final String id;
  final String imagePath;
  final String name;
  final String location;
  final String subcategory;
  final String rating;
  final String badge;
  final String price;
  final String description;

  const CategoryMerchantCardData({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.subcategory,
    required this.rating,
    required this.badge,
    this.price = '',
    this.description = '',
  });
}

/// Configuration defining the metadata and curated cards for each category.
class CategoryBrowseConfig {
  final String categoryTitle;
  final String searchHint;
  final String defaultImage;
  final List<String> subcategories;
  final List<CategoryMerchantCardData> items;

  const CategoryBrowseConfig({
    required this.categoryTitle,
    required this.searchHint,
    required this.defaultImage,
    required this.subcategories,
    required this.items,
  });
}

/// Centralized registry providing rich curated data for all marketplace categories.
class CategoryBrowseRegistry {
  static final Map<String, CategoryBrowseConfig> _configs = {
    'Property': const CategoryBrowseConfig(
      categoryTitle: 'Property',
      searchHint: 'Search properties & flats',
      defaultImage: 'assets/images/h2.png',
      subcategories: ['All', 'Apartments', 'Villas', 'Plots & Land', 'Commercial', 'Rentals'],
      items: [
        CategoryMerchantCardData(
          id: 'prop_1',
          imagePath: 'assets/images/h2.png',
          name: 'Skyline Prime Realty',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Apartments',
          rating: '4.9',
          badge: 'Verified Realty',
          price: '₹ 95,00,000',
          description: 'Luxury 3BHK premium apartment with scenic balcony view, high-end fittings, and covered parking.',
        ),
        CategoryMerchantCardData(
          id: 'prop_2',
          imagePath: 'assets/images/h2.png',
          name: 'Urban Nest Luxury Villas',
          location: 'Kakkanad, Kochi',
          subcategory: 'Villas',
          rating: '4.8',
          badge: 'Premium Partner',
          price: '₹ 1.45 Crore',
          description: 'Contemporary 4BHK gated villa community with clubhouse, private garden, and 24/7 security.',
        ),
        CategoryMerchantCardData(
          id: 'prop_3',
          imagePath: 'assets/images/h2.png',
          name: 'Green Valley Estates',
          location: 'Pattom, Thiruvananthapuram',
          subcategory: 'Plots & Land',
          rating: '4.7',
          badge: 'Verified Seller',
          price: '₹ 18 Lakh / Cent',
          description: 'Clear deed residential dry land ideal for independent villa construction.',
        ),
        CategoryMerchantCardData(
          id: 'prop_4',
          imagePath: 'assets/images/h8.png',
          name: 'Metro Living Spaces',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Rentals',
          rating: '4.9',
          badge: 'Top Rated',
          price: '₹ 42,000 /mo',
          description: 'Spacious 2BHK fully furnished ready-to-move apartment located in prime HSR Sector 2.',
        ),
        CategoryMerchantCardData(
          id: 'prop_5',
          imagePath: 'assets/images/h2.png',
          name: 'Horizon Commercial Hub',
          location: 'Infopark, Kochi',
          subcategory: 'Commercial',
          rating: '4.6',
          badge: 'Verified Business',
          price: '₹ 85,000 /mo',
          description: 'Plug-and-play Grade A commercial office space with high-speed internet and power backup.',
        ),
        CategoryMerchantCardData(
          id: 'prop_6',
          imagePath: 'assets/images/h2.png',
          name: 'Heritage Coastal Homes',
          location: 'Aluva, Kochi',
          subcategory: 'Villas',
          rating: '4.8',
          badge: 'Trusted Partner',
          price: '₹ 89,00,000',
          description: 'Traditional Kerala-style modern river-facing home with courtyard and wooden interiors.',
        ),
      ],
    ),

    'Jobs': const CategoryBrowseConfig(
      categoryTitle: 'Jobs',
      searchHint: 'Search jobs & careers',
      defaultImage: 'assets/images/h3.png',
      subcategories: ['All', 'Full-time', 'Part-time', 'Remote', 'IT & Tech', 'Marketing'],
      items: [
        CategoryMerchantCardData(
          id: 'job_1',
          imagePath: 'assets/images/h3.png',
          name: 'Galletrix Talent Solutions',
          location: 'Bengaluru / Remote',
          subcategory: 'IT & Tech',
          rating: '4.9',
          badge: 'Top Employer',
          price: '₹ 18 - 24 LPA',
          description: 'Join a hyper-growth venture building cross-platform Flutter and Dart applications.',
        ),
        CategoryMerchantCardData(
          id: 'job_2',
          imagePath: 'assets/images/h3.png',
          name: 'Global Edge Careers',
          location: 'Kochi InfoPark',
          subcategory: 'Full-time',
          rating: '4.7',
          badge: 'Verified Recruiter',
          price: '₹ 12 - 16 LPA',
          description: 'Senior Full Stack Engineer for enterprise SaaS platforms utilizing React & Node.',
        ),
        CategoryMerchantCardData(
          id: 'job_3',
          imagePath: 'assets/images/h3.png',
          name: 'Innovate Tech Staffing',
          location: 'Thiruvananthapuram',
          subcategory: 'IT & Tech',
          rating: '4.8',
          badge: 'Direct Hire',
          price: '₹ 8 - 12 LPA',
          description: 'Cloud Infrastructure & DevOps Engineer with Docker, Kubernetes, and AWS expertise.',
        ),
        CategoryMerchantCardData(
          id: 'job_4',
          imagePath: 'assets/images/h3.png',
          name: 'Apex Creative Studio',
          location: 'Kochi',
          subcategory: 'Marketing',
          rating: '4.9',
          badge: 'Verified Agency',
          price: '₹ 7 - 10 LPA',
          description: 'Lead Product & UI/UX Designer to sculpt sleek, modern mobile application experiences.',
        ),
        CategoryMerchantCardData(
          id: 'job_5',
          imagePath: 'assets/images/h3.png',
          name: 'NextGen Solutions',
          location: 'Remote (India)',
          subcategory: 'Remote',
          rating: '4.8',
          badge: 'Actively Hiring',
          price: '₹ 14 - 20 LPA',
          description: 'Backend Systems Engineer specializing in high-throughput PostgreSQL and microservices.',
        ),
        CategoryMerchantCardData(
          id: 'job_6',
          imagePath: 'assets/images/h3.png',
          name: 'Horizon Operations',
          location: 'Technopark, TVM',
          subcategory: 'Part-time',
          rating: '4.6',
          badge: 'Fast Response',
          price: '₹ 25,000 /mo',
          description: 'Client Success & Marketplace Operations Specialist with flexible hours.',
        ),
      ],
    ),

    'Groceries': const CategoryBrowseConfig(
      categoryTitle: 'Groceries',
      searchHint: 'Search daily essentials & food',
      defaultImage: 'assets/images/h4.png',
      subcategories: ['All', 'Fresh Veggies', 'Fruits', 'Dairy & Eggs', 'Bakery', 'Organic'],
      items: [
        CategoryMerchantCardData(
          id: 'groc_1',
          imagePath: 'assets/images/h4.png',
          name: 'Green Harvest Organics',
          location: 'Kakkanad, Kochi',
          subcategory: 'Organic',
          rating: '4.9',
          badge: 'Farm Certified',
          price: 'From ₹ 49',
          description: 'Fresh organic farm-picked daily essential vegetables box (5kg farm assortment).',
        ),
        CategoryMerchantCardData(
          id: 'groc_2',
          imagePath: 'assets/images/h4.png',
          name: 'Daily Fresh Supermarket',
          location: 'Pattom, Thiruvananthapuram',
          subcategory: 'Fresh Veggies',
          rating: '4.8',
          badge: '10-Min Delivery',
          price: 'From ₹ 25',
          description: 'Crisp green vegetables, root vegetables, and fresh herbs harvested daily.',
        ),
        CategoryMerchantCardData(
          id: 'groc_3',
          imagePath: 'assets/images/h4.png',
          name: 'Golden Grains Organics',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Organic',
          rating: '4.9',
          badge: 'Premium Quality',
          price: 'From ₹ 120',
          description: 'Unpolished traditional grains, cold-pressed oils, and artisanal spices.',
        ),
        CategoryMerchantCardData(
          id: 'groc_4',
          imagePath: 'assets/images/h4.png',
          name: 'Nilgiris Dairy & Bakes',
          location: 'Vazhuthacaud, TVM',
          subcategory: 'Dairy & Eggs',
          rating: '4.7',
          badge: 'Trusted Partner',
          price: 'From ₹ 35',
          description: 'Pure A2 farm fresh milk, curd, cultured butter, and free-range farm eggs.',
        ),
        CategoryMerchantCardData(
          id: 'groc_5',
          imagePath: 'assets/images/h4.png',
          name: 'Farm2Home Tropical Fruits',
          location: 'Kochi Central',
          subcategory: 'Fruits',
          rating: '4.8',
          badge: 'Fresh Today',
          price: 'From ₹ 85',
          description: 'Sweet Alphonso mangoes, dragon fruit, avocados, and fresh seasonal harvests.',
        ),
        CategoryMerchantCardData(
          id: 'groc_6',
          imagePath: 'assets/images/h4.png',
          name: 'Nature’s Basket Express',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Bakery',
          rating: '4.9',
          badge: 'Artisanal Bakes',
          price: 'From ₹ 60',
          description: 'Handcrafted sourdough breads, whole wheat croissants, and freshly baked muffins.',
        ),
      ],
    ),

    'Electronics': const CategoryBrowseConfig(
      categoryTitle: 'Electronics',
      searchHint: 'Search laptops, audio & TV',
      defaultImage: 'assets/images/h5.png',
      subcategories: ['All', 'Laptops', 'Audio & Sound', 'Smart TVs', 'Cameras', 'Appliances'],
      items: [
        CategoryMerchantCardData(
          id: 'elec_1',
          imagePath: 'assets/images/h5.png',
          name: 'TechZone Digital World',
          location: 'MG Road, Kochi',
          subcategory: 'Laptops',
          rating: '4.8',
          badge: 'Authorized Dealer',
          price: '₹ 98,000',
          description: 'MacBook Air M2 13", Apple M2 chip, 8GB memory, 256GB SSD, Midnight finish.',
        ),
        CategoryMerchantCardData(
          id: 'elec_2',
          imagePath: 'assets/images/h5.png',
          name: 'Apex Sound & Vision',
          location: 'Panampilly Nagar, Kochi',
          subcategory: 'Audio & Sound',
          rating: '4.9',
          badge: 'Official Warranty',
          price: '₹ 24,990',
          description: 'Sony WH-1000XM5 premium wireless noise cancelling headphones with LDAC high-res audio.',
        ),
        CategoryMerchantCardData(
          id: 'elec_3',
          imagePath: 'assets/images/h5.png',
          name: 'Silicon Valley Gadgets',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Laptops',
          rating: '4.7',
          badge: 'Certified Pre-Owned',
          price: '₹ 64,500',
          description: 'Dell XPS 13 InfinityEdge, Intel Core i7, 16GB RAM, 512GB NVMe SSD, ultra-portable.',
        ),
        CategoryMerchantCardData(
          id: 'elec_4',
          imagePath: 'assets/images/h5.png',
          name: 'CineHome Displays',
          location: 'Indiranagar, Bengaluru',
          subcategory: 'Smart TVs',
          rating: '4.9',
          badge: 'Top Rated',
          price: '₹ 1,14,990',
          description: 'LG 55" 4K OLED evo Smart TV with Dolby Vision, Dolby Atmos, and 120Hz gaming support.',
        ),
        CategoryMerchantCardData(
          id: 'elec_5',
          imagePath: 'assets/images/h5.png',
          name: 'Soundwave Pro Studio',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Audio & Sound',
          rating: '4.8',
          badge: 'Verified Dealer',
          price: '₹ 18,500',
          description: 'JBL PartyBox Bluetooth high-power portable speaker with dynamic light show.',
        ),
        CategoryMerchantCardData(
          id: 'elec_6',
          imagePath: 'assets/images/h5.png',
          name: 'Vision Tech Electronics',
          location: 'Kaloor, Kochi',
          subcategory: 'Cameras',
          rating: '4.6',
          badge: 'Brand Warranty',
          price: '₹ 1,32,000',
          description: 'Sony Alpha 7 IV full-frame mirrorless camera body with 33MP Exmor R sensor.',
        ),
      ],
    ),

    'Mobiles': const CategoryBrowseConfig(
      categoryTitle: 'Mobiles',
      searchHint: 'Search mobiles & accessories',
      defaultImage: 'assets/images/h6.png',
      subcategories: ['All', 'Smartphones', 'iPhones', 'Tablets', 'Smartwatches', 'Accessories'],
      items: [
        CategoryMerchantCardData(
          id: 'mob_1',
          imagePath: 'assets/images/h6.png',
          name: 'Premium Tech Hub',
          location: 'Indiranagar, Bengaluru',
          subcategory: 'iPhones',
          rating: '4.9',
          badge: 'Apple Certified',
          price: '₹ 1,34,900',
          description: 'iPhone 15 Pro Max 256GB Natural Titanium, immaculate condition with Apple warranty.',
        ),
        CategoryMerchantCardData(
          id: 'mob_2',
          imagePath: 'assets/images/h6.png',
          name: 'Galaxy Official Reseller',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Smartphones',
          rating: '4.8',
          badge: 'Brand Warranty',
          price: '₹ 1,09,999',
          description: 'Samsung Galaxy S24 Ultra 5G, Titanium Gray 12GB/512GB, Galaxy AI unlocked with S-Pen.',
        ),
        CategoryMerchantCardData(
          id: 'mob_3',
          imagePath: 'assets/images/h6.png',
          name: 'Mobile Point Studio',
          location: 'MG Road, Kochi',
          subcategory: 'Smartphones',
          rating: '4.7',
          badge: 'Verified Seller',
          price: '₹ 62,900',
          description: 'OnePlus 12 5G 256GB, Snapdragon 8 Gen 3, 100W SuperVOOC fast charging.',
        ),
        CategoryMerchantCardData(
          id: 'mob_4',
          imagePath: 'assets/images/h6.png',
          name: 'iStore Hub Express',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Tablets',
          rating: '4.9',
          badge: 'Official Dealer',
          price: '₹ 84,900',
          description: 'Apple iPad Pro 11" M4 chip, Ultra Retina XDR display, 256GB Space Black.',
        ),
        CategoryMerchantCardData(
          id: 'mob_5',
          imagePath: 'assets/images/h6.png',
          name: 'Smart Gadget World',
          location: 'Edappally, Kochi',
          subcategory: 'Smartwatches',
          rating: '4.8',
          badge: 'Fast Dispatch',
          price: '₹ 29,900',
          description: 'Apple Watch Series 9 GPS 45mm Midnight Aluminum with Sport Band.',
        ),
        CategoryMerchantCardData(
          id: 'mob_6',
          imagePath: 'assets/images/h6.png',
          name: 'Cellular Care Hub',
          location: 'Palayam, Thiruvananthapuram',
          subcategory: 'Accessories',
          rating: '4.6',
          badge: 'Genuine Parts',
          price: '₹ 2,499',
          description: 'MagSafe high-speed 15W wireless charging stand with braided USB-C cable.',
        ),
      ],
    ),

    'Services': const CategoryBrowseConfig(
      categoryTitle: 'Services',
      searchHint: 'Search professional services',
      defaultImage: 'assets/images/h7.png',
      subcategories: ['All', 'Home Cleaning', 'Electrician', 'Plumbing', 'Carpentry', 'Painting'],
      items: [
        CategoryMerchantCardData(
          id: 'serv_1',
          imagePath: 'assets/images/h7.png',
          name: 'Urban Clean Pros',
          location: 'Kakkanad, Kochi',
          subcategory: 'Home Cleaning',
          rating: '4.9',
          badge: 'Background Verified',
          price: '₹ 2,500',
          description: 'Comprehensive 4-hour home sanitization and deep cleaning by verified professionals.',
        ),
        CategoryMerchantCardData(
          id: 'serv_2',
          imagePath: 'assets/images/h7.png',
          name: 'Master Spark Electricals',
          location: 'Pattom, Thiruvananthapuram',
          subcategory: 'Electrician',
          rating: '4.8',
          badge: 'Same Day Service',
          price: '₹ 450 /hr',
          description: 'Certified electricians for rewiring, panel upgrades, appliance setup, and repairs.',
        ),
        CategoryMerchantCardData(
          id: 'serv_3',
          imagePath: 'assets/images/h7.png',
          name: 'QuickFix Plumbing Care',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Plumbing',
          rating: '4.7',
          badge: '24/7 Available',
          price: '₹ 399',
          description: 'Emergency pipe leak fix, bathroom sanitary fittings, and water heater servicing.',
        ),
        CategoryMerchantCardData(
          id: 'serv_4',
          imagePath: 'assets/images/h7.png',
          name: 'Heritage Wood Masters',
          location: 'Kochi Central',
          subcategory: 'Carpentry',
          rating: '4.9',
          badge: '5-Star Rated',
          price: '₹ 650 /hr',
          description: 'Custom furniture repair, door lock installation, and architectural woodwork.',
        ),
        CategoryMerchantCardData(
          id: 'serv_5',
          imagePath: 'assets/images/h7.png',
          name: 'PaintCraft Professionals',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Painting',
          rating: '4.8',
          badge: 'Verified Crew',
          price: '₹ 14 / sqft',
          description: 'Interior and exterior premium dustless painting with Asian Paints Royal finish.',
        ),
        CategoryMerchantCardData(
          id: 'serv_6',
          imagePath: 'assets/images/h7.png',
          name: 'CoolBreeze AC & Appliance',
          location: 'Palayam, Thiruvananthapuram',
          subcategory: 'Home Cleaning',
          rating: '4.7',
          badge: 'Warranty on Service',
          price: '₹ 799',
          description: 'Jet pump foam wash, gas leak inspection, and cooling performance tune-up.',
        ),
      ],
    ),

    'Furniture': const CategoryBrowseConfig(
      categoryTitle: 'Furniture',
      searchHint: 'Search furniture & home decor',
      defaultImage: 'assets/images/h8.png',
      subcategories: ['All', 'Living Room', 'Bedroom', 'Office', 'Dining', 'Decor'],
      items: [
        CategoryMerchantCardData(
          id: 'furn_1',
          imagePath: 'assets/images/h8.png',
          name: 'Heritage Woodcraft Studio',
          location: 'HSR Layout, Bengaluru',
          subcategory: 'Dining',
          rating: '4.9',
          badge: 'Handcrafted Wood',
          price: '₹ 7,25,000',
          description: 'Handcrafted solid European oak dining table with seating for up to 8 guests.',
        ),
        CategoryMerchantCardData(
          id: 'furn_2',
          imagePath: 'assets/images/h8.png',
          name: 'Royal Living Furniture',
          location: 'Panampilly Nagar, Kochi',
          subcategory: 'Living Room',
          rating: '4.8',
          badge: 'Custom Fabric',
          price: '₹ 48,000',
          description: 'L-shaped modern sectional sofa in stain-resistant velvet fabric with oak legs.',
        ),
        CategoryMerchantCardData(
          id: 'furn_3',
          imagePath: 'assets/images/h8.png',
          name: 'Urban Space Ergonomics',
          location: 'Indiranagar, Bengaluru',
          subcategory: 'Office',
          rating: '4.8',
          badge: 'Ergo Certified',
          price: '₹ 22,500',
          description: 'Dual-motor motorized height adjustable standing desk with solid walnut tabletop.',
        ),
        CategoryMerchantCardData(
          id: 'furn_4',
          imagePath: 'assets/images/h8.png',
          name: 'Comfort Zone Sleep Studio',
          location: 'Kowdiar, Thiruvananthapuram',
          subcategory: 'Bedroom',
          rating: '4.7',
          badge: '10-Yr Warranty',
          price: '₹ 38,900',
          description: 'King size hydraulic storage bed upholstered in premium linen fabric.',
        ),
        CategoryMerchantCardData(
          id: 'furn_5',
          imagePath: 'assets/images/h8.png',
          name: 'Woodpecker Home Decor',
          location: 'Kochi Central',
          subcategory: 'Decor',
          rating: '4.9',
          badge: 'Top Showroom',
          price: '₹ 14,200',
          description: 'Mid-century modern accent console table with brass hardware and cane accents.',
        ),
        CategoryMerchantCardData(
          id: 'furn_6',
          imagePath: 'assets/images/h8.png',
          name: 'Minimalist Living Hub',
          location: 'Pattom, Thiruvananthapuram',
          subcategory: 'Living Room',
          rating: '4.6',
          badge: 'Flat-Pack Easy',
          price: '₹ 18,900',
          description: 'Minimalist wooden TV entertainment unit with cable management channels.',
        ),
      ],
    ),
  };

  static CategoryBrowseConfig getConfig(String category) {
    if (_configs.containsKey(category)) {
      return _configs[category]!;
    }
    // Fallback default config
    return CategoryBrowseConfig(
      categoryTitle: category,
      searchHint: 'Search in $category',
      defaultImage: 'assets/images/h1.png',
      subcategories: ['All', 'Popular', 'Recent', 'Top Rated', 'Verified'],
      items: [
        CategoryMerchantCardData(
          id: 'item_1',
          imagePath: 'assets/images/h1.png',
          name: '$category Hub',
          location: 'Thiruvananthapuram',
          subcategory: 'Popular',
          rating: '4.8',
          badge: 'Verified Seller',
          price: '₹ 15,000',
          description: 'Top rated selections in $category curated by verified marketplace merchants.',
        ),
      ],
    );
  }
}

/// Generic, responsive category browse screen matching the VehiclesScreen architecture.
class CategoryBrowseScreen extends StatefulWidget {
  final String categoryTitle;

  const CategoryBrowseScreen({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<CategoryBrowseScreen> createState() => _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends State<CategoryBrowseScreen> {
  late CategoryBrowseConfig _config;
  late String _selectedSubcategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _config = CategoryBrowseRegistry.getConfig(widget.categoryTitle);
    _selectedSubcategory = _config.subcategories.isNotEmpty
        ? _config.subcategories.first
        : 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryMerchantCardData> get _filteredItems {
    return _config.items.where((item) {
      final matchesSub = _selectedSubcategory == 'All' ||
          item.subcategory.toLowerCase() == _selectedSubcategory.toLowerCase();
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.location.toLowerCase().contains(q) ||
          item.subcategory.toLowerCase().contains(q) ||
          item.badge.toLowerCase().contains(q);
      return matchesSub && matchesQuery;
    }).toList();
  }

  void _openItemDetails(CategoryMerchantCardData item) {
    if (widget.categoryTitle == 'Vehicles') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CarDetailsScreen(
            title: '${item.name} - Creta SX',
            price: item.price.isNotEmpty ? item.price : '₹ 7,25,000',
            imagePath: item.imagePath,
            location: item.location,
          ),
        ),
      );
      return;
    }

    // Modal Sheet matching the sleek detail presentation
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Image and Badges
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(Icons.storefront_rounded, size: 40, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Rating Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 3),
                            Text(
                              item.location,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          item.rating,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Subcategory & Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.subcategory,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.badge,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              if (item.description.isNotEmpty) ...[
                Text(
                  'About this partner',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Price & Action CTA
              Row(
                children: [
                  if (item.price.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting Price',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          item.price,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                  Expanded(
                    flex: item.price.isNotEmpty ? 0 : 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Contacting ${item.name}...'),
                            backgroundColor: const Color(0xFF6366F1),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'View & Contact',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _config.categoryTitle,
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
            // ── 1. Search Input Pill ──
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
                        hintText: _config.searchHint,
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

            // ── 2. Subcategory Filter Chips ──
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _config.subcategories.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _config.subcategories[i];
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

            // ── 3. 2-Column Responsive Card Grid ──
            if (items.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                      const SizedBox(height: 12),
                      Text(
                        'No results found in ${_config.categoryTitle}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try switching chips or searching with another term',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
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
                    onTap: () => _openItemDetails(item),
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
                          // Card Image Preview
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

                          // Card Details & Metrics
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
                                  item.subcategory,
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Star Rating and Green Verified Badge
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
