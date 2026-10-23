import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
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
                              const Text(
                                'Kullanıcı',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          const Text(
                            'Seviye 4 • Toplam 1.420 XP',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Seviye 4 (420 / 500 XP)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('Seviye 5\'e 80 XP Kaldı', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 8,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Rozetler Vitrini
              const Text('Rozetler Vitrini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _buildBadgeCard('💧 Su Savaşçısı', '7 Gün 2L/gün', true),
                  _buildBadgeCard('📖 Kitap Kurdu', '30 Gün Kesintisiz', true),
                  _buildBadgeCard('🧘 Zihin Ustası', '10 Nefes Seansı', true),
                  _buildBadgeCard('🏃 Maratoncu', '10 Koşu Tamamla', true),
                  _buildBadgeCard('🎯 Odak Ustası', '25 Pomodoro', false),
                  _buildBadgeCard('❄️ Buz Adam', '14 Gün Soğuk Duş', false),
                ],
              ),
              const SizedBox(height: 20),

              // Ayarlar
              const Text('Uygulama Ayarları', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Material(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Günlük Hatırlatıcı Bildirimler', style: TextStyle(fontSize: 14)),
                        value: _notificationsEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) => setState(() => _notificationsEnabled = val),
                      ),
                      const Divider(height: 1),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: widget.themeModeNotifier,
                        builder: (context, mode, _) {
                          return SwitchListTile(
                            title: const Text('Karanlık Mod', style: TextStyle(fontSize: 14)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String title, String subtitle, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.borderLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withValues(alpha: 0.4) : AppColors.borderLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? Icons.verified : Icons.lock_outline,
            color: isUnlocked ? AppColors.primary : AppColors.textSecondary,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? null : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
