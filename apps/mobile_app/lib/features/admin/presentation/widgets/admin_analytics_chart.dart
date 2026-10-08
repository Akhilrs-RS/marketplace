import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAnalyticsChart extends StatelessWidget {
  const AdminAnalyticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Growth Trajectory',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+18.4% vs last week',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Bezier Chart Canvas
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _ChartCurvePainter(),
            ),
          ),

          const SizedBox(height: 14),

          // Activity Breakdown Bars
          _buildActivityRow(label: 'Enquiries', count: '142', progress: 0.85, color: const Color(0xFF7C3AED)),
          const SizedBox(height: 10),
          _buildActivityRow(label: 'Orders', count: '74', progress: 0.62, color: const Color(0xFF10B981)),
          const SizedBox(height: 10),
          _buildActivityRow(label: 'Purchases', count: '68', progress: 0.54, color: const Color(0xFF0284C7)),
        ],
      ),
    );
  }

  Widget _buildActivityRow({
    required String label,
    required String count,
    required double progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ChartCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.20, size.height * 0.70),
      Offset(size.width * 0.40, size.height * 0.50),
      Offset(size.width * 0.65, size.height * 0.60),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width, size.height * 0.15),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Gradient fill under curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF7C3AED).withValues(alpha: 0.25),
          const Color(0xFF7C3AED).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final strokePaint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Endpoint dot
    final lastPoint = points.last;
    final dotPaint = Paint()..color = const Color(0xFF7C3AED);
    final dotOuter = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(lastPoint, 5, dotPaint);
    canvas.drawCircle(lastPoint, 5, dotOuter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
