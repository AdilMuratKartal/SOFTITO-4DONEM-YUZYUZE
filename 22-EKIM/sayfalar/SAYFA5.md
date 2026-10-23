# Sayfa 5: Oyunlaştırma, Rozetler ve Profil Ekranı (sayfalar/SAYFA5.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının mikro-alışkanlıkları sürdürme motivasyonunu en üst seviyede tutan **Oyunlaştırma (Gamification) ve Profil Modülü**dür.

Bu ekran; kazanılan deneyim puanlarını (XP), mevcut seviye ve unvan basamaklarını (Level System), tamamlanan başarılara göre açılan veya hedeflenen **Rozetler Vitrini**ni (Badges Showcase), genel seri (streak) rekorlarını ve uygulama ayarlarını (karanlık mod, bildirim hatırlatıcıları, veri yedekleme) barındırır.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Yerleşimi

```text
+-----------------------------------------------------------------------+
|  Profil ve Başarılar                                     [ ⚙️ Ayarlar ]|
+-----------------------------------------------------------------------+
|  PROFİL BAŞLIĞI:                                                      |
|  [ (Avatar) ]  Adil Murat                     [ 🌟 Kıdemli İradeci ]  |
|                Seviye 4 • Toplam 1.420 XP                              |
+-----------------------------------------------------------------------+
|  SEVİYE İLERLEME ÇUBUĞU:                                              |
|  Seviye 4 ───────────────[ 420 / 500 XP ]───────────────> Seviye 5   |
|  [========================================--------]       %84         |
|  Sonraki Seviyeye: 80 XP Kaldı                                        |
+-----------------------------------------------------------------------+
|  ÖNE ÇIKAN İSTATİSTİK ŞERİDİ:                                         |
|  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐          |
|  │  🔥 18 Gün   │     │  🏆 12 Rozet │     │  ⏱️ 24 Oturum│          |
|  │  Aktif Seri  │     │  Kazanılan   │     │  Pomodoro    │          |
|  └──────────────┘     └──────────────┘     └──────────────┘          |
+-----------------------------------------------------------------------+
|  ROZETLER VİTRİNİ (Badges Grid):                                      |
|  Filtre: [ (✓) Tümü (18) ]   [ Kazanılan (12) ]   [ Kilitli (6) ]    |
|                                                                       |
|  [ 💧 Su Savaşçısı ]  [ 📖 Kitap Kurdu ]  [ 🧘 Zihin Ustası ]         |
|    (7 Gün 2L/gün)       (30 Gün Kesintisiz)   (10 Nefes Seansı)       |
|       (AÇIK ✓)              (AÇIK ✓)             (AÇIK ✓)             |
|                                                                       |
|  [ ❄️ Buz Adam ]      [ 🚭 Özgür İrade ]   [ 🎯 Pomodoro Ustası ]     |
|   (14 Gün Soğuk Duş)   (30 Gün Dumansız)    (50 Odak Oturumu)         |
|       (AÇIK ✓)             (🔒 KİLİTLİ)          (🔒 KİLİTLİ)         |
+-----------------------------------------------------------------------+
|  UYGULAMA VE HESAP AYARLARI:                                          |
|  [ 🔔 Günlük Hatırlatıcı Bildirimler                     ( ON ) ]     |
|  [ 🌙 Karanlık Mod                                      ( AUTO ) ]    |
|  [ 💾 Verileri Dışa Aktar (JSON Yedek)                        > ]     |
|  [ 🔄 Tüm İlerlemeyi Sıfırla                                  > ]     |
+-----------------------------------------------------------------------+
```

### 2.1. Profil Başlığı ve Unvan Sistemi
- Kullanıcı avatarı, adı ve kazandığı en son aktif unvan rozeti (`Çırak`, `İrade Savaşçısı`, `Kıdemli İradeci`, `Disiplin Üstadı`).
- Toplam biriken XP ve mevcut seviye numarası.

### 2.2. Seviye İlerleme Kartı (XP Progress Card)
- Mevcut seviyeden bir sonraki seviyeye geçmek için gereken XP eşiğini gösterir.
- Formül: Her seviye için gereken XP: $\text{Gereken XP} = \text{Seviye} \times 250$.
- Yüzdelik lineer doluluk çubuğu (`LinearProgressIndicator`).

### 2.3. Rozetler Vitrini (Badges Showcase Grid)
- Rozetler 2 sütunlu veya 3 sütunlu ızgara (`GridView`) şeklinde listelenir.
- **Kazanılmış Rozet:** Canlı renkli dairesel ikon kapsayıcısı, rozet adı, kazanılma tarihi ve zümrüt yeşili onay tiki. Dokunulduğunda kutlama detay popup'ı açılır.
- **Kilitli Rozet:** Gri tonlama (grayscale/opacity: 0.4), asma kilit ikonu (`Icons.lock_rounded`), ilerleme oranı (örn: `18/30 Gün`) ve kilit açma şartı açıklaması.

### 2.4. Hızlı Ayarlar ve Veri Yönetimi Bölümü
- Günlük hatırlatma saati seçimi (Mood sorusu ve alışkanlık hatırlatıcıları için push notification ayarı).
- Tema seçimi: Sistem, Açık veya Koyu Mod.
- JSON veri yedekleme ve sıfırlama aksiyonları.

---

## 3. Durum Yönetimi (State Architecture)

### 3.1. `ProfileController` (`features/controllers/profile_controller.dart`)
- `ValueNotifier<UserProfileModel> userProfileNotifier`: Kullanıcı bilgileri, toplam XP ve seviye durumunu tutar.
- `ValueNotifier<List<BadgeModel>> badgesNotifier`: Tüm rozetlerin kilit/açık durumunu tutar.
- `ValueNotifier<int> selectedBadgeFilterNotifier`: `0` (Tümü), `1` (Kazanılan), `2` (Kilitli).
- `ValueNotifier<bool> isDarkModeNotifier`: Tema modunu tutar.

**Metotlar:**
- `addExperiencePoints(int xp)`: Kullanıcıya XP ekler, seviye atlama (Level Up) kontrolü yapar ve gerekiyorsa tebrik modalı tetikler.
- `unlockBadge(String badgeId)`: Şartları sağlanan rozetin kilidini açar, bildirim üretir.
- `toggleTheme(bool isDark)`: Uygulama temasını günceller ve yerel hafızaya (`SharedPreferences`) yazar.
- `filterBadges(int filterIndex)`: Rozet vitrinini sekmeye göre filtreler.

---

## 4. Veri Modelleri

### 4.1. `BadgeModel` (`features/models/badge_model.dart`)

```dart
class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String iconCode;
  final String category;
  final int requiredCount;
  final int currentCount;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCode,
    required this.category,
    required this.requiredCount,
    required this.currentCount,
    required this.isUnlocked,
    this.unlockedAt,
  });

  double get progressRatio => requiredCount == 0 ? 0.0 : (currentCount / requiredCount).clamp(0.0, 1.0);

  BadgeModel copyWith({
    int? currentCount,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return BadgeModel(
      id: id,
      title: title,
      description: description,
      iconCode: iconCode,
      category: category,
      requiredCount: requiredCount,
      currentCount: currentCount ?? this.currentCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconCode: json['iconCode'] ?? 'military_tech',
      category: json['category'] ?? 'Genel',
      requiredCount: json['requiredCount'] ?? 1,
      currentCount: json['currentCount'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCode': iconCode,
      'category': category,
      'requiredCount': requiredCount,
      'currentCount': currentCount,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}
```

### 4.2. `UserProfileModel` (`features/models/user_level_model.dart`)

```dart
class UserProfileModel {
  final String id;
  final String name;
  final String avatarUrl;
  final int totalXp;
  final int currentLevel;
  final int currentLevelXp;
  final int requiredLevelXp;
  final String rankTitle;
  final int activeStreak;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.totalXp,
    required this.currentLevel,
    required this.currentLevelXp,
    required this.requiredLevelXp,
    required this.rankTitle,
    required this.activeStreak,
  });

  double get levelProgressRatio => requiredLevelXp == 0 ? 0.0 : (currentLevelXp / requiredLevelXp).clamp(0.0, 1.0);

  UserProfileModel copyWith({
    int? totalXp,
    int? currentLevel,
    int? currentLevelXp,
    int? requiredLevelXp,
    String? rankTitle,
    int? activeStreak,
  }) {
    return UserProfileModel(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      currentLevelXp: currentLevelXp ?? this.currentLevelXp,
      requiredLevelXp: requiredLevelXp ?? this.requiredLevelXp,
      rankTitle: rankTitle ?? this.rankTitle,
      activeStreak: activeStreak ?? this.activeStreak,
    );
  }
}
```

---

## 5. View Kod İskeleti (`features/views/profile_view.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';
import '../models/badge_model.dart';
import '../models/user_level_model.dart';
import '../widgets/badge_grid_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _controller.loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profil & Başarılar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ayarlar',
            onPressed: () => _openSettingsModal(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(isDark),
              const SizedBox(height: 16),
              _buildLevelProgressCard(isDark),
              const SizedBox(height: 16),
              _buildQuickStatsRow(isDark),
              const SizedBox(height: 24),
              _buildBadgesSectionHeader(),
              const SizedBox(height: 12),
              _buildBadgesFilterTabs(),
              const SizedBox(height: 16),
              _buildBadgesGrid(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return ValueListenableBuilder<UserProfileModel>(
      valueListenable: _controller.userProfileNotifier,
      builder: (context, user, _) {
        return Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.person, size: 36, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.rankTitle,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${user.totalXp} Toplam XP',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLevelProgressCard(bool isDark) {
    return ValueListenableBuilder<UserProfileModel>(
      valueListenable: _controller.userProfileNotifier,
      builder: (context, user, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seviye ${user.currentLevel}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${user.currentLevelXp} / ${user.requiredLevelXp} XP',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: user.levelProgressRatio,
                  minHeight: 10,
                  backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sonraki seviyeye ${user.requiredLevelXp - user.currentLevelXp} XP kaldı.',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStatsRow(bool isDark) {
    return ValueListenableBuilder<UserProfileModel>(
      valueListenable: _controller.userProfileNotifier,
      builder: (context, user, _) {
        return Row(
          children: [
            _buildStatItem('🔥 ${user.activeStreak} Gün', 'Aktif Seri', isDark),
            const SizedBox(width: 10),
            _buildStatItem('🏆 12 Rozet', 'Kazanılan', isDark),
            const SizedBox(width: 10),
            _buildStatItem('⚡ Seviye ${user.currentLevel}', 'Mevcut Rütbe', isDark),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String val, String label, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSectionHeader() {
    return const Text(
      'Rozetler Vitrini',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBadgesFilterTabs() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.selectedBadgeFilterNotifier,
      builder: (context, activeIndex, _) {
        return Row(
          children: [
            _buildBadgeFilterChip('Tümü', 0, activeIndex),
            const SizedBox(width: 8),
            _buildBadgeFilterChip('Kazanılanlar', 1, activeIndex),
            const SizedBox(width: 8),
            _buildBadgeFilterChip('Kilitli', 2, activeIndex),
          ],
        );
      },
    );
  }

  Widget _buildBadgeFilterChip(String label, int index, int activeIndex) {
    final isSelected = index == activeIndex;
    return GestureDetector(
      onTap: () => _controller.filterBadges(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBadgesGrid() {
    return ValueListenableBuilder<List<BadgeModel>>(
      valueListenable: _controller.badgesNotifier,
      builder: (context, badges, _) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return BadgeGridCard(
              badge: badge,
              onTap: () => _showBadgeDetailModal(context, badge),
            );
          },
        );
      },
    );
  }

  void _showBadgeDetailModal(BuildContext context, BadgeModel badge) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: badge.isUnlocked ? AppColors.primary.withOpacity(0.15) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge.isUnlocked ? Icons.military_tech_rounded : Icons.lock_outline_rounded,
                  size: 48,
                  color: badge.isUnlocked ? AppColors.primary : Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(badge.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                badge.isUnlocked ? 'Kazanıldı ✓' : 'İlerleme: ${badge.currentCount} / ${badge.requiredCount}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: badge.isUnlocked ? AppColors.primary : AppColors.secondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSettingsModal(BuildContext context) {
    // Ayarlar BottomSheet açılır
  }
}
```