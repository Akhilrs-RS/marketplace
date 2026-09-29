import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageConversation {
  final String imagePath;
  final String senderName;
  final String itemTag;
  final String lastMessage;
  final String time;
  final bool isUnread;

  const MessageConversation({
    required this.imagePath,
    required this.senderName,
    required this.itemTag,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedTab = 0; // 0: Buying, 1: Selling

  final List<MessageConversation> _conversations = const [
    MessageConversation(
      imagePath: 'assets/images/h1.png',
      senderName: 'Rohan Sharma',
      itemTag: 'Hyundai Creta 2022',
      lastMessage: 'Yes, You can inspect it tomorrow',
      time: '10:41',
      isUnread: true,
    ),
    MessageConversation(
      imagePath: 'assets/images/h2.png',
      senderName: 'Urban Nest Realty',
      itemTag: '3BHK Kakkanad Apartment',
      lastMessage: 'The viewing is confirmed for 4 PM',
      time: 'Yesterday',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Messages',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF1E293B),
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buying vs Selling Toggle
            Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _selectedTab == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Buying',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedTab == 0 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _selectedTab == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Selling',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedTab == 1 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Conversation Tiles List
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _conversations.length,
              separatorBuilder: (ctx, i) => const Divider(height: 24, color: Color(0xFFF1F5F9)),
              itemBuilder: (ctx, index) {
                final chat = _conversations[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening chat with ${chat.senderName}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      // Item/Dealership Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 58,
                          height: 58,
                          child: Image.asset(
                            chat.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Sender details & Message preview
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  chat.senderName,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  chat.time,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              chat.itemTag,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6366F1), // Indigo tag
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chat.lastMessage,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: chat.isUnread ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                                fontWeight: chat.isUnread ? FontWeight.w600 : FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
