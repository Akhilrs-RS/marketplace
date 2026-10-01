import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InquirySuccessScreen extends StatelessWidget {
  final String partnerName;
  final String inquiryType;
  final String scheduledSlot;
  final String referenceId;
  final VoidCallback? onGoToMessages;

  const InquirySuccessScreen({
    super.key,
    required this.partnerName,
    required this.inquiryType,
    required this.scheduledSlot,
    required this.referenceId,
    this.onGoToMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated-style Success Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 52,
                ),
              ),

              const SizedBox(height: 24),

              // Title & Subtitle
              Text(
                'Inquiry Sent Successfully!',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your request has been forwarded to $partnerName. Verified partners typically reply within 15 minutes.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Summary Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildReceiptRow('Reference ID', referenceId, isHighlight: true),
                    const Divider(height: 20, color: Color(0xFFE2E8F0)),
                    _buildReceiptRow('Partner', partnerName),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Request Type', inquiryType),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Preferred Slot', scheduledSlot.isNotEmpty ? scheduledSlot : 'Immediate Inquiry'),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Status', 'Delivered • Awaiting Response', statusColor: const Color(0xFF059669)),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  key: const Key('inquiry_success_messages_btn'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    onGoToMessages?.call();
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: Text(
                    'Track in Messages',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  key: const Key('inquiry_success_browse_btn'),
                  onPressed: () {
                    // Pop back to the category browse screen (pops Success + Details)
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Back to Category',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
              color: statusColor ?? (isHighlight ? const Color(0xFF4338CA) : const Color(0xFF0F172A)),
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
