import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FigmaHeroSection extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmit;

  const FigmaHeroSection({
    super.key,
    this.onSearchChanged,
    this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 360 + statusBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Hero Image (h.png)
          Positioned.fill(
            child: Image.asset(
              'assets/images/h.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (ctx, err, stack) => Container(
                color: const Color(0xFF2E241E),
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.white30, size: 50),
                ),
              ),
            ),
          ),

          // Dark Multi-Stop Gradient Overlays for optimal contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.60),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Content Layer
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Top Bar: "MarketPlace" + Notification & Avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'MarketPlace',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Row(
                          children: [
                            // Notification bell with translucent backdrop
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.35),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // User Profile Avatar
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: const Color(0xFF6366F1),
                                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(flex: 3),

                    // Serif Headline: "Everything\nYou need ,"
                    Text(
                      'Everything\nYou need ,',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        height: 1.18,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle: "All in one marketplace."
                    Text(
                      'All in one marketplace.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Search Pill Box (floating above sheet boundary)
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9CA3AF),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: onSearchChanged,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: const Color(0xFF1F2937),
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search product ,cars, jobs, property & more',
                                hintStyle: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          // Green circle with white arrow
                          GestureDetector(
                            onTap: onSearchSubmit,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF16A34A), // Emerald/Green from Figma
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
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
