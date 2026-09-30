import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../notifications/presentation/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 16,
          ),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings opened'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF0F172A),
              size: 21,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. User Avatar with Edit Badge ──
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/user_avatar.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: const Color(0xFFF1E9FD),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF4A4458),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile photo'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit_outlined,
                            size: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── 2. Contact Info Cards Group ──
            _buildContactCard(
              context,
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: '+7 904 599 xxx 11',
            ),
            const SizedBox(height: 10),
            _buildContactCard(
              context,
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              value: 'alexg@gamil.com',
            ),
            const SizedBox(height: 10),
            _buildContactCard(
              context,
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: 'St. Petersburg, Vos....',
            ),

            const SizedBox(height: 26),

            // ── 3. Section: Your Activity ──
            _buildSectionHeader('Your Activity'),
            const SizedBox(height: 12),
            _buildActionItem(
              context,
              icon: Icons.favorite_border_rounded,
              title: 'My favorites',
              subtitle: '1 Saved',
            ),
            _buildActionItem(
              context,
              icon: Icons.search_rounded,
              title: 'Saved Searches',
              subtitle: '1 Saved',
            ),
            _buildActionItem(
              context,
              icon: Icons.access_time_rounded,
              title: 'Recently viewed',
              subtitle: '1 Saved',
            ),
            _buildActionItem(
              context,
              icon: Icons.chat_bubble_outline_rounded,
              title: 'My enquiries',
              subtitle: '4 active',
            ),

            const SizedBox(height: 24),

            // ── 4. Section: Seller & Payments ──
            _buildSectionHeader('Seller & Payments'),
            const SizedBox(height: 12),
            _buildActionItem(
              context,
              icon: Icons.home_outlined,
              title: 'Seller Profile',
              subtitle: 'Verified',
            ),
            _buildActionItem(
              context,
              icon: Icons.language_rounded,
              title: 'My Listings',
              subtitle: 'Verified',
            ),
            _buildActionItem(
              context,
              icon: Icons.receipt_long_outlined,
              title: 'Payments & invoices',
              subtitle: '2 receipts',
            ),

            const SizedBox(height: 24),

            // ── 5. Section: Help & Settings ──
            _buildSectionHeader('Help & Settings'),
            const SizedBox(height: 12),
            _buildActionItem(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help center',
              subtitle: '2 open tickets',
            ),
            _buildActionItem(
              context,
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Push , email , SMS',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            _buildActionItem(
              context,
              icon: Icons.shield_outlined,
              title: 'Privacy & Security',
              subtitle: 'Protected',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Edit $label: $value'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6FE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1E9FD), width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEFE8FB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFF475569), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opened $title ($subtitle)'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1E9FD), // Soft pastel lavender box matching Figma
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4A4458), // Slate-purple stroke matching Figma
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}
