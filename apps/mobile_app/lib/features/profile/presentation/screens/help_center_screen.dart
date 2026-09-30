import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportTicket {
  final String ticketId;
  final String issue;
  final String status;
  final String date;
  final Color statusColor;

  const SupportTicket({
    required this.ticketId,
    required this.issue,
    required this.status,
    required this.date,
    required this.statusColor,
  });
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<SupportTicket> _tickets = const [
    SupportTicket(
      ticketId: 'TCK-8841',
      issue: 'Ad Boost payment confirmation pending verification',
      status: 'In Progress',
      date: 'Opened 2 hours ago',
      statusColor: Color(0xFFF59E0B),
    ),
    SupportTicket(
      ticketId: 'TCK-8812',
      issue: 'Verification badge document review request',
      status: 'Open',
      date: 'Opened yesterday',
      statusColor: Color(0xFF6366F1),
    ),
  ];

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'How do I mark an item as sold?',
      'a': 'Go to Profile > My Listings, find your listing under the Active tab, and tap "Mark as Sold".',
    },
    {
      'q': 'Is my payment protected when buying from verified shops?',
      'a': 'Yes, all verified business listings carry Galletrix Buyer Protection against fraud and counterfeit items.',
    },
    {
      'q': 'How does listing boosting work?',
      'a': 'Boosting places your ad at the top of category feeds and search results for 7 days, giving up to 5x more views.',
    },
    {
      'q': 'How do I update my registered phone or email?',
      'a': 'Simply tap on your Phone or Email card in the Profile tab to edit your contact details instantly.',
    },
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
          'Help Center',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            key: const Key('contact_support_btn'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Starting live chat with Galletrix Support...'),
                  backgroundColor: Color(0xFF6366F1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.headset_mic_rounded, size: 18),
            label: Text('Contact Support / Live Chat', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search FAQ bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search help guides, topics...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Active Support Tickets Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Open Tickets (${_tickets.length})',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text('2 open tickets', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6366F1), fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            // Tickets List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _tickets.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final t = _tickets[i];
                return Container(
                  padding: const EdgeInsets.all(14),
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
                          Text(t.ticketId, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: t.statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              t.status,
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: t.statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(t.issue, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text(t.date, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // FAQs
            Text('Frequently Asked Questions', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._faqs.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFFF1F5F9)),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFFF1F5F9)),
                  ),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  title: Text(f['q']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Text(
                        f['a']!,
                        style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B), height: 1.4),
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
}
