import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTopHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;

  const AdminTopHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.onNotificationsTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0E14),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Brand Title & Right Icons ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MarketPlace Hub',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              Row(
                children: [
                  // Bell with yellow unread badge dot
                  GestureDetector(
                    onTap: onNotificationsTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          Positioned(
                            top: 1,
                            right: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFBBF24), // Vibrant Amber Dot
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Avatar with thin golden / amber ring border
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(
                            Icons.person_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── Row 2: Greeting & Name ──
          Text(
            'Welcome back ,',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8), // Soft silver/gray
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
