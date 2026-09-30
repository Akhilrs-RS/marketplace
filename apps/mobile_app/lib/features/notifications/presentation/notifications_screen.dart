import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/presentation/car_details_screen.dart';

enum NotificationType { deal, message, property, security, order }

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = const ['All', 'Unread', 'Deals', 'Messages', 'Orders'];

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: 'notif_1',
        title: 'Price Drop Alert!',
        subtitle: '2024 Hyundai Creta SX price dropped by ₹ 25,000 in Kowdiar.',
        time: '10m ago',
        type: NotificationType.deal,
        icon: Icons.directions_car_rounded,
        iconColor: const Color(0xFF6366F1),
        iconBg: const Color(0xFFEDE9FE),
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_2',
        title: 'New Message from Rohan',
        subtitle: '“Yes, you can inspect the vehicle tomorrow at 11 AM.”',
        time: '1h ago',
        type: NotificationType.message,
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xFF0EA5E9),
        iconBg: const Color(0xFFE0F2FE),
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_3',
        title: 'Viewing Request Confirmed',
        subtitle: 'Urban Nest Realty confirmed your viewing for 3BHK Kakkanad Apartment.',
        time: '3h ago',
        type: NotificationType.property,
        icon: Icons.home_work_outlined,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFFDCFCE7),
        isRead: true,
      ),
      NotificationItem(
        id: 'notif_4',
        title: 'Security Alert',
        subtitle: 'New login detected on your Galletrix account from Chrome on macOS.',
        time: 'Yesterday',
        type: NotificationType.security,
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFFF59E0B),
        iconBg: const Color(0xFFFEF3C7),
        isRead: true,
      ),
      NotificationItem(
        id: 'notif_5',
        title: 'Weekend Electronics Deal',
        subtitle: 'Exclusive up to 20% discount on certified pre-owned MacBooks & iPhones.',
        time: '2d ago',
        type: NotificationType.deal,
        icon: Icons.local_offer_outlined,
        iconColor: const Color(0xFFEC4899),
        iconBg: const Color(0xFFFCE7F3),
        isRead: true,
      ),
      NotificationItem(
        id: 'notif_6',
        title: 'Enquiry Status Updated',
        subtitle: 'Heritage Woodcraft accepted your enquiry for Solid Oak Dining Table.',
        time: '3d ago',
        type: NotificationType.order,
        icon: Icons.inventory_2_outlined,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFF3E8FF),
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !n.isRead).toList();
    } else if (_selectedFilter == 'Deals') {
      return _notifications.where((n) => n.type == NotificationType.deal).toList();
    } else if (_selectedFilter == 'Messages') {
      return _notifications.where((n) => n.type == NotificationType.message).toList();
    } else if (_selectedFilter == 'Orders') {
      return _notifications.where((n) => n.type == NotificationType.order).toList();
    }
    return _notifications;
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleNotificationTap(NotificationItem item) {
    setState(() => item.isRead = true);

    if (item.type == NotificationType.deal && item.title.contains('Creta')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CarDetailsScreen(
            title: 'Hyundai Creta SX',
            price: '₹ 7,00,000',
            imagePath: 'assets/images/h1.png',
            location: 'Kowdiar, Thiruvananthapuram',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_unreadCount',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            IconButton(
              tooltip: 'Mark all as read',
              icon: const Icon(
                Icons.done_all_rounded,
                color: Color(0xFF6366F1),
                size: 22,
              ),
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final filter = _filters[i];
                final isSelected = filter == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Notifications List
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              size: 30,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications here',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'We will notify you when price alerts, updates or messages arrive.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                    itemCount: items.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final notif = items[i];
                      return Dismissible(
                        key: Key(notif.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            _notifications.removeWhere((n) => n.id == notif.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dismissed notification'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () => _handleNotificationTap(notif),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: notif.isRead
                                  ? Colors.white
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: notif.isRead
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFFE2E8F0),
                                width: notif.isRead ? 1 : 1.2,
                              ),
                              boxShadow: notif.isRead
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon Avatar
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: notif.iconBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    notif.icon,
                                    color: notif.iconColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Notification Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notif.title,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.5,
                                                fontWeight: notif.isRead
                                                    ? FontWeight.w600
                                                    : FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            notif.time,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                          if (!notif.isRead) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              width: 7,
                                              height: 7,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF6366F1),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notif.subtitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: notif.isRead
                                              ? const Color(0xFF64748B)
                                              : const Color(0xFF334155),
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
