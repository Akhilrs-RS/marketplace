import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/admin_mock_data.dart';
import 'admin_order_stepper.dart';

class AdminOrderItemCard extends StatefulWidget {
  final AdminDetailedOrder order;
  final VoidCallback? onTap;

  const AdminOrderItemCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  State<AdminOrderItemCard> createState() => _AdminOrderItemCardState();
}

class _AdminOrderItemCardState extends State<AdminOrderItemCard> {
  late bool _showStepper;

  @override
  void initState() {
    super.initState();
    _showStepper = widget.order.hasStepper;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Image & Details ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Thumbnail + (optional pricing below image)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      order.icon,
                      size: 32,
                      color: const Color(0xFF334155),
                    ),
                  ),

                  // If order has stepper, pricing is positioned under image as in screenshot Card 1
                  if (_showStepper) ...[
                    const SizedBox(height: 6),
                    Text(
                      order.originalPrice,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      order.salePrice,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(width: 14),

              // Right Column: Title, Customer, Delivery & Status Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Status Badge Pill on Right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            order.productTitle,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              height: 1.25,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: order.statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.statusLabel,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: order.statusTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Customer Name Row
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.customerName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Delivery Info Row
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            order.deliveryMethod,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // If NOT showing stepper, show right-aligned price as in Cards 2, 3, 4
                    if (!_showStepper) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order.originalPrice,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.salePrice,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // ── Stepper Timeline (if active) ──
          if (_showStepper) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            AdminOrderStepper(currentStep: order.currentStep),
          ],
        ],
      ),
    );
  }
}
