import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    String label;

    switch (status) {
      case 'onaylandi':
        textColor = AppColors.approvedText;
        bgColor = AppColors.approvedBg;
        label = 'Onaylandı';
        break;
      case 'iptal':
        textColor = AppColors.cancelledText;
        bgColor = AppColors.cancelledBg;
        label = 'İptal Edildi';
        break;
      case 'bitti':
        textColor = AppColors.completedText;
        bgColor = AppColors.completedBg;
        label = 'Tamamlandı';
        break;
      case 'beklemede':
      default:
        textColor = AppColors.pendingText;
        bgColor = AppColors.pendingBg;
        label = 'Beklemede';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
