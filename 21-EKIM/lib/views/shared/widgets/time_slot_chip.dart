import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isBooked,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey.shade200
              : (isSelected ? AppColors.primary : AppColors.surface),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isBooked
                ? Colors.grey.shade300
                : (isSelected ? AppColors.primary : AppColors.border),
          ),
        ),
        child: Text(
          isBooked ? '$time (Dolu)' : time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: isBooked ? TextDecoration.lineThrough : null,
            color: isBooked
                ? Colors.grey.shade500
                : (isSelected ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
