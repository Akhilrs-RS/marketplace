import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrderStepper extends StatelessWidget {
  final int currentStep; // 0 to 5

  const AdminOrderStepper({
    super.key,
    required this.currentStep,
  });

  static const List<String> _stepLabels = [
    'Placed',
    'Confirmed',
    'Processing',
    'Packed',
    'Shipped',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_stepLabels.length * 2 - 1, (index) {
          if (index.isEven) {
            // Step Node
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex <= currentStep;
            final isCurrent = stepIndex == currentStep;

            return Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF5046E5) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? const Color(0xFF5046E5) : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      size: 10,
                      color: isCompleted ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _stepLabels[stepIndex],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.inter(
                      fontSize: 8.5,
                      fontWeight: isCurrent
                          ? FontWeight.w700
                          : (isCompleted ? FontWeight.w600 : FontWeight.w500),
                      color: isCompleted ? const Color(0xFF5046E5) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Connector Line between nodes
            final prevStep = index ~/ 2;
            final isLineCompleted = prevStep < currentStep;

            return Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(top: 7),
                height: 1.5,
                color: isLineCompleted ? const Color(0xFF5046E5) : const Color(0xFFE2E8F0),
              ),
            );
          }
        }),
      ),
    );
  }
}
