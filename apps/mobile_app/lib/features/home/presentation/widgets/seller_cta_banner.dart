import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerCtaBanner extends StatelessWidget {
  final VoidCallback? onStartSelling;

  const SellerCtaBanner({
    super.key,
    this.onStartSelling,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5), // Vibrant Royal Blue / Indigo from Figma
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headline: "Turn What you have into your next opportunity."
          Text(
            'Turn What you have into\nyour next opportunity.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // White Action Button: "Start selling >"
          GestureDetector(
            key: const Key('start_selling_cta_button'),
            onTap: onStartSelling,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start selling',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4F46E5),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
