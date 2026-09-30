import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedSearchEntry {
  final String id;
  final String query;
  final String category;
  final String filterSummary;
  bool alertsEnabled;

  SavedSearchEntry({
    required this.id,
    required this.query,
    required this.category,
    required this.filterSummary,
    this.alertsEnabled = true,
  });
}

class SavedSearchesScreen extends StatefulWidget {
  const SavedSearchesScreen({super.key});

  @override
  State<SavedSearchesScreen> createState() => _SavedSearchesScreenState();
}

class _SavedSearchesScreenState extends State<SavedSearchesScreen> {
  final List<SavedSearchEntry> _searches = [
    SavedSearchEntry(
      id: 'srch_1',
      query: 'Automatic SUVs under ₹15 Lakhs',
      category: 'Vehicles',
      filterSummary: 'Kerala • Verified Dealers Only • 2021+',
      alertsEnabled: true,
    ),
    SavedSearchEntry(
      id: 'srch_2',
      query: 'Sea-Facing Villas & 3BHK',
      category: 'Property',
      filterSummary: 'Thiruvananthapuram • Ready to Move',
      alertsEnabled: true,
    ),
    SavedSearchEntry(
      id: 'srch_3',
      query: 'MacBook Pro M3 Max 32GB',
      category: 'Electronics',
      filterSummary: 'Kochi • Warranty Available',
      alertsEnabled: false,
    ),
  ];

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
          'Saved Searches (${_searches.length})',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: _searches.isEmpty
          ? Center(
              child: Text(
                'No saved searches yet.',
                style: GoogleFonts.inter(color: const Color(0xFF64748B)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _searches.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = _searches[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6FE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1E9FD)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              setState(() => _searches.remove(item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleted search: "${item.query}"'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.query,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.filterSummary,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch.adaptive(
                                value: item.alertsEnabled,
                                activeThumbColor: const Color(0xFF6366F1),
                                activeTrackColor: const Color(0xFFC7D2FE),
                                onChanged: (val) {
                                  setState(() => item.alertsEnabled = val);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(val
                                          ? 'Alerts enabled for "${item.query}"'
                                          : 'Alerts disabled for "${item.query}"'),
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'Instant alerts',
                                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Executing search: "${item.query}"'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.search_rounded, size: 14),
                            label: Text(
                              'Search Now',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
