import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminShopBanner extends StatelessWidget {
  final VoidCallback onViewShop;

  const AdminShopBanner({
    super.key,
    required this.onViewShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 118,
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFDE8E8).withValues(alpha: 0.95), // Soft pastel peach/rose
            const Color(0xFFE0E7FF).withValues(alpha: 0.95), // Soft pastel periwinkle
            const Color(0xFFE2E8F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Right Car Image Cutout (Hyundai SUV)
            Positioned(
              right: -10,
              bottom: 4,
              child: Image.asset(
                'assets/images/h1.png',
                height: 86,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
              ),
            ),

            // Left Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 110, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store icon in rounded lavender square
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFDDD6FE),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: Color(0xFF7C3AED), // Vibrant Purple
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text & Link Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your shop is all set !',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'keep managing your products, orders and customers from here.',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4B5563),
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: onViewShop,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFC4B5FD),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View shop',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6D28D9),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 13,
                                  color: Color(0xFF6D28D9),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
