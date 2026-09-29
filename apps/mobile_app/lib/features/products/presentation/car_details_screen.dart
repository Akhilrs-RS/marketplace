import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarDetailsScreen extends StatefulWidget {
  final String title;
  final String price;
  final String imagePath;
  final String location;

  const CarDetailsScreen({
    super.key,
    this.title = 'Hyundai Creta SX',
    this.price = '₹ 7,25,000',
    this.imagePath = 'assets/images/h1.png',
    this.location = 'Thiruvananthapuram',
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool _isFavorite = true;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262C34), // Dark slate hero background matching Figma
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Arrow
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  // Center Title: "Cars" in Serif
                  Text(
                    'Cars',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  // Circular Heart Action Button
                  GestureDetector(
                    onTap: () {
                      setState(() => _isFavorite = !_isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite ? 'Saved to Favorites' : 'Removed from Favorites',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: const Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Hero Car Showcase
            Container(
              height: 230,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              alignment: Alignment.center,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(Icons.directions_car_rounded, size: 80, color: Colors.white70),
                ),
              ),
            ),

            // 3. Curved White Sliding Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Description with "...More"
                            GestureDetector(
                              onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                              child: Text.rich(
                                TextSpan(
                                  text: 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    height: 1.45,
                                    color: const Color(0xFF64748B),
                                  ),
                                  children: [
                                    if (_isDescriptionExpanded)
                                      const TextSpan(
                                        text: 'featuring a panoramic sunroof, premium upholstery, wireless Apple CarPlay/Android Auto, and an ultra-refined powertrain tailored for city and highway cruising.',
                                      ),
                                    TextSpan(
                                      text: _isDescriptionExpanded ? ' Less' : '....More',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Features Heading
                            Text(
                              'Features',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 3 Feature Metric Cards
                            Row(
                              children: [
                                // Total Capacity
                                Expanded(
                                  child: _buildFeatureCard(
                                    icon: Icons.chair_rounded,
                                    label: 'Total Capacity',
                                    value: '6 Seats',
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Highest Speed
                                Expanded(
                                  child: _buildFeatureCard(
                                    icon: Icons.speed_rounded,
                                    label: 'Highest Speed',
                                    value: '200 KM/H',
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Engine Output
                                Expanded(
                                  child: _buildFeatureCard(
                                    icon: Icons.car_repair_rounded,
                                    label: 'Engine Output',
                                    value: '500 HP',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Details Section Heading
                            Text(
                              'Details',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildDetailRow('Location', widget.location),
                            _buildDetailRow('Fuel Type', 'Petrol'),
                            _buildDetailRow('Transmission', 'Automatic'),
                            _buildDetailRow('Owner', '1st Owner • Verified'),
                          ],
                        ),
                      ),
                    ),

                    // 4. Fixed Bottom Pricing and Buy Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.shade100)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Text(
                                widget.price,
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),

                              // Buy now Button
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Order initiated for ${widget.title} (${widget.price})'),
                                      backgroundColor: const Color(0xFF6366F1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Buy now',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // iOS Home indicator line
                          Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0F172A), size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
          ),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
