import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English (US)';
  String _selectedCurrency = '₹ INR (Indian Rupee)';
  String _selectedTheme = 'System Default';

  void _selectLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English (US)', 'Malayalam (മലയാളം)', 'Hindi (हिन्दी)'].map((lang) {
            return ListTile(
              title: Text(lang, style: GoogleFonts.inter(fontSize: 14)),
              trailing: _selectedLanguage == lang ? const Icon(Icons.check, color: Color(0xFF6366F1)) : null,
              onTap: () {
                setState(() => _selectedLanguage = lang);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _selectCurrency() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['₹ INR (Indian Rupee)', r'$ USD (US Dollar)', '€ EUR (Euro)'].map((curr) {
            return ListTile(
              title: Text(curr, style: GoogleFonts.inter(fontSize: 14)),
              trailing: _selectedCurrency == curr ? const Icon(Icons.check, color: Color(0xFF6366F1)) : null,
              onTap: () {
                setState(() => _selectedCurrency = curr);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out?', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to log out of your Galletrix account?',
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully'), behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Preferences', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _buildOptionTile('Language', _selectedLanguage, Icons.translate_rounded, _selectLanguage),
          const SizedBox(height: 8),
          _buildOptionTile('Currency', _selectedCurrency, Icons.currency_rupee_rounded, _selectCurrency),
          const SizedBox(height: 8),
          _buildOptionTile('Theme Mode', _selectedTheme, Icons.palette_outlined, () {
            setState(() {
              _selectedTheme = _selectedTheme == 'Light' ? 'Dark' : 'Light';
            });
          }),

          const SizedBox(height: 24),

          Text('Storage & App Info', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _buildOptionTile('Clear Cached Media', '124 MB used', Icons.cleaning_services_outlined, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cache cleared: 124 MB freed!'), behavior: SnackBarBehavior.floating),
            );
          }),
          const SizedBox(height: 8),
          _buildOptionTile('App Version', 'v2.4.0 (Build 2026.09)', Icons.info_outline_rounded, () {}),

          const SizedBox(height: 32),

          OutlinedButton.icon(
            key: const Key('logout_button'),
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            label: Text('Log Out', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFDC2626))),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFCA5A5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1E9FD)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6366F1), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(value, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
          ],
        ),
      ),
    );
  }
}
