import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 15,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 3),
          Text(
            '$streakDays Gün',
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
