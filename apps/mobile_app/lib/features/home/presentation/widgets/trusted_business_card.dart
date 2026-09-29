import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrustedBusinessItem {
  final String imagePath;
  final String name;
  final String rating;
  final String categoryLocation;

  const TrustedBusinessItem({
    required this.imagePath,
    required this.name,
    required this.rating,
    required this.categoryLocation,
  });
}

class TrustedBusinessCard extends StatelessWidget {
  final TrustedBusinessItem item;
  final VoidCallback? onViewShop;

  const TrustedBusinessCard({
    super.key,
    required this.item,
    this.onViewShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        children: [
          // Top Row: Logo, Name & Category, Rating Badge
          Row(
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  color: const Color(0xFFF1F5F9),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Center(
                      child: Icon(Icons.storefront_outlined, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Category/Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.categoryLocation,
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

              // Rating Badge
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 3),
                  Text(
                    item.rating,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // "View Shop" Outlined Button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: onViewShop,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'View Shop',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
