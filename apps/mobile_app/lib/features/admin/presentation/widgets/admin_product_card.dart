import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/admin_mock_data.dart';

class AdminProductCard extends StatelessWidget {
  final AdminCatalogProduct product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Box
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Icon(
              product.icon,
              color: const Color(0xFF334155),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),

          // Title, Subtitle, Price & Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                          height: 1.25,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: Color(0xFF94A3B8)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit Product')),
                        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                      onSelected: (val) {
                        if (val == 'edit' && onEdit != null) onEdit!();
                        if (val == 'delete' && onDelete != null) onDelete!();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.categoryAndSku,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      product.price,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: product.isInStock
                            ? const Color(0xFFDCFCE7)
                            : (product.status == 'Draft'
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.isInStock
                            ? 'In Stock'
                            : (product.status == 'Draft' ? 'Draft' : 'Out Stock'),
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: product.isInStock
                              ? const Color(0xFF16A34A)
                              : (product.status == 'Draft'
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFFDC2626)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
