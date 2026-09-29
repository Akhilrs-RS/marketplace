import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItemData {
  final String imagePath;
  final String title;
  final String subtitle;

  const CategoryItemData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class CategoryCard extends StatelessWidget {
  final CategoryItemData data;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF18181B), // Dark surface for bottom info
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top Image Area
            Expanded(
              flex: 58,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    data.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 24, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Dark Info Container
            Expanded(
              flex: 42,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF18181B),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and micro arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            data.title,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            size: 9,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Subtitle
                    Text(
                      data.subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9CA3AF), // Muted grey
                        fontSize: 7.5,
                        fontWeight: FontWeight.w400,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}
