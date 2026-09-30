import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentReceipt {
  final String invoiceNo;
  final String date;
  final String description;
  final String amount;
  final String method;
  final String status;

  const PaymentReceipt({
    required this.invoiceNo,
    required this.date,
    required this.description,
    required this.amount,
    required this.method,
    this.status = 'Paid',
  });
}

class PaymentsInvoicesScreen extends StatefulWidget {
  const PaymentsInvoicesScreen({super.key});

  @override
  State<PaymentsInvoicesScreen> createState() => _PaymentsInvoicesScreenState();
}

class _PaymentsInvoicesScreenState extends State<PaymentsInvoicesScreen> {
  final List<PaymentReceipt> _receipts = const [
    PaymentReceipt(
      invoiceNo: 'INV-2024-0821',
      date: '18 Sep 2024, 02:45 PM',
      description: 'Featured Top-Spot Ad Boost (7 Days)',
      amount: '₹ 1,499.00',
      method: 'Apple Pay (•• 4242)',
    ),
    PaymentReceipt(
      invoiceNo: 'INV-2024-0419',
      date: '12 Aug 2024, 11:20 AM',
      description: 'Verified Merchant Trust Badge & Priority Listing',
      amount: '₹ 2,999.00',
      method: 'UPI (alexg@okhdfc)',
    ),
  ];

  void _viewInvoiceModal(PaymentReceipt receipt) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax Invoice / Receipt',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        receipt.status,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildReceiptRow('Invoice Number', receipt.invoiceNo),
                _buildReceiptRow('Date & Time', receipt.date),
                _buildReceiptRow('Description', receipt.description),
                _buildReceiptRow('Payment Method', receipt.method),
                const Divider(height: 24, color: Color(0xFFE2E8F0)),
                _buildReceiptRow('Total Paid', receipt.amount, isBold: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading ${receipt.invoiceNo}.pdf...'),
                          backgroundColor: const Color(0xFF6366F1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      'Download PDF Receipt',
                      style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xFF0F172A),
              ),
            ),
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
          'Payments & Invoices',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Payment Methods
            Text('Saved Payment Methods', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _buildCardTile(Icons.apple, 'Apple Pay', 'Default payment method', isApple: true),
            const SizedBox(height: 8),
            _buildCardTile(Icons.credit_card_rounded, 'Visa ending in 4242', 'Expires 11/27'),
            const SizedBox(height: 8),
            _buildCardTile(Icons.account_balance_rounded, 'UPI: alexg@okhdfc', 'Direct bank debit'),

            const SizedBox(height: 24),

            // Invoices Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invoices & Receipts (2)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                Text('All Time', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
              ],
            ),
            const SizedBox(height: 12),

            // Invoices List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _receipts.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final r = _receipts[i];
                return InkWell(
                  key: Key('invoice_tile_$i'),
                  onTap: () => _viewInvoiceModal(r),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6FE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1E9FD)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Icon(Icons.receipt_long_outlined, color: Color(0xFF6366F1), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.description,
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${r.invoiceNo} • ${r.date}',
                                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              r.amount,
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              r.status,
                              style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF16A34A)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTile(IconData icon, String title, String subtitle, {bool isApple = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isApple ? Colors.black : const Color(0xFF6366F1), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 16),
        ],
      ),
    );
  }
}
