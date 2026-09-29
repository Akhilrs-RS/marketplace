import 'package:flutter/material.dart';

class FigmaBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPressed;

  const FigmaBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Home
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            isSelected: currentIndex == 0,
            onTap: () => onTabSelected(0),
          ),

          // 2. Search
          _buildNavItem(
            icon: Icons.search_rounded,
            isSelected: currentIndex == 1,
            onTap: () => onTabSelected(1),
          ),

          // 3. Center Vibrant Purple Plus Button
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // 4. Chat / Messages
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            isSelected: currentIndex == 3,
            onTap: () => onTabSelected(3),
          ),

          // 5. Profile
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            isSelected: currentIndex == 4,
            onTap: () => onTabSelected(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        isSelected ? (activeIcon ?? icon) : icon,
        size: 24,
        color: isSelected ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
      ),
    );
  }
}
