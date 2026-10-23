import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/notification_service.dart';

class ProfileView extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const ProfileView({super.key, required this.themeModeNotifier});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profil & Başarılar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil Başlığı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Kullanıcı',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '🌟 Kıdemli İradeci',
                                  style: TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seviye 4 • Toplam 1.420 XP',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Seviye İlerleme Çubuğu
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seviye 4 (420 / 500 XP)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        const Text(
                          'Seviye 5\'e 80 XP Kaldı',
                          style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 8,
                        backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Rozetler Vitrini
              Text(
                'Rozetler Vitrini',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _buildBadgeCard('💧 Su Savaşçısı', '7 Gün 2L/gün', true, isDark),
                  _buildBadgeCard('📖 Kitap Kurdu', '30 Gün Kesintisiz', true, isDark),
                  _buildBadgeCard('🧘 Zihin Ustası', '10 Nefes Seansı', true, isDark),
                  _buildBadgeCard('🏃 Maratoncu', '10 Koşu Tamamla', true, isDark),
                  _buildBadgeCard('🎯 Odak Ustası', '25 Pomodoro', false, isDark),
                  _buildBadgeCard('❄️ Buz Adam', '14 Gün Soğuk Duş', false, isDark),
                ],
              ),
              const SizedBox(height: 20),

              // Uygulama Ayarları
              Text(
                'Uygulama Ayarları',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Günlük Hatırlatıcı Bildirimler',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.onSurface : AppColors.textLight,
                        ),
                      ),
                      subtitle: Text(
                        _notificationsEnabled ? 'Aktif (Saatinde hatırlatma yapar)' : 'Kapalı',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                        ),
                      ),
                      value: _notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) async {
                        setState(() => _notificationsEnabled = val);
                        if (val) {
                          await NotificationService.requestPermissions();
                        } else {
                          await NotificationService.cancelAllNotifications();
                        }
                      },
                    ),
                    if (_notificationsEnabled) ...[
                      Divider(height: 1, color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                      ListTile(
                        leading: const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
                        title: Text(
                          'Anlık Test Bildirimi Gönder',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        subtitle: Text(
                          'Cihazınıza anlık test bildirimi gönderir',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(Icons.send_rounded, size: 18, color: AppColors.primary),
                        onTap: () async {
                          final success = await NotificationService.showInstantNotification(
                            title: '🔔 Test Bildirimi: Alışkanlık Takibi',
                            body: 'Harika! Bildirim sistemi başarıyla çalışıyor ve aktif.',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: success ? AppColors.primary : AppColors.danger,
                                content: Text(
                                  success
                                      ? '✓ Test bildirimi cihaza gönderildi!'
                                      : 'Bildirim gönderilemedi. Lütfen sistem izinlerini kontrol edin.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: success ? AppColors.onPrimary : Colors.white,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    Divider(height: 1, color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: widget.themeModeNotifier,
                      builder: (context, mode, _) {
                        return SwitchListTile(
                          title: Text(
                            'Karanlık Mod (Mindful Emerald)',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                          value: mode == ThemeMode.dark,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            widget.themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String title, String subtitle, bool isUnlocked, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.primary.withValues(alpha: 0.12)
            : (isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked
              ? AppColors.primary.withValues(alpha: 0.4)
              : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? Icons.verified : Icons.lock_outline,
            color: isUnlocked ? AppColors.primary : AppColors.outline,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? (isDark ? AppColors.onSurface : AppColors.textLight)
                  : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
