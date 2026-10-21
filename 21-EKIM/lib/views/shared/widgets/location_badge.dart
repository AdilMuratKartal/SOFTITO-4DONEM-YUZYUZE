import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LocationBadge extends StatelessWidget {
  final String locationType; // 'sen_gel', 'ben_geleyim', 'her_ikisi'

  const LocationBadge({super.key, required this.locationType});

  @override
  Widget build(BuildContext context) {
    final bool isComeToMe = locationType == 'sen_gel';
    final bool isBoth = locationType == 'her_ikisi';

    final Color textColor = isBoth
        ? AppColors.bothText
        : (isComeToMe ? AppColors.comeToMeText : AppColors.iWillComeText);

    final Color bgColor = isBoth
        ? AppColors.bothBg
        : (isComeToMe ? AppColors.comeToMeBg : AppColors.iWillComeBg);

    final IconData icon = isBoth
        ? Icons.swap_horiz_outlined
        : (isComeToMe ? Icons.home_repair_service_outlined : Icons.storefront_outlined);

    final String text = isBoth
        ? 'Adreste veya Dükkanda'
        : (isComeToMe ? 'Sen Gel (Adrese)' : 'Ben Geleyim (Dükkana)');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
