import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../controllers/roadmap_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../widgets/roadmap_card.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/roadmap_node_tree.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/create_roadmap_sheet.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import 'roadmap_detail_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

/// 1. Hiyerarşik Ekran Yapısı: Liste Ekranı (Aktif Yol Haritalarım ve Tamamlananlar Arşivi)
class RoadmapListView extends StatelessWidget { // RoadmapListView sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final RoadmapController roadmapController; // RoadmapController türünden roadmapController adlı değişkenimiz
  final HabitController habitController; // HabitController türünden habitController adlı değişkenimiz

  const RoadmapListView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.roadmapController, // roadmapController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.habitController, // habitController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  void _openDetail(BuildContext context, RoadmapModel roadmap) {
    Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
      MaterialPageRoute(
        builder: (_) => RoadmapDetailView(
          roadmap: roadmap,
          roadmapController: roadmapController,
          habitController: habitController,
        ),
      ),
    );
  }

  void _openCreateSheet(BuildContext context) {
    CreateRoadmapSheet.show(
      context: context,
      availableHabits: habitController.habitsNotifier.value,
      onSave: (newRoadmap) {
        roadmapController.addRoadmap(newRoadmap);
      },
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: ValueListenableBuilder<List<RoadmapModel>>(
          valueListenable: roadmapController.roadmapsNotifier,
          builder: (context, roadmaps, _) {
            final activeRoadmaps = roadmaps.where((r) => !r.isCompleted).toList();
            final completedRoadmaps = roadmaps.where((r) => r.isCompleted).toList();

            return ValueListenableBuilder<RoadmapModel?>(
              valueListenable: roadmapController.selectedRoadmapNotifier,
              builder: (context, selectedRoadmap, _) {
                // Seçili harita yoksa aktiflerin ilkini al
                final currentRoadmap = (selectedRoadmap != null &&
                        activeRoadmaps.any((r) => r.id == selectedRoadmap.id))
                    ? selectedRoadmap
                    : (activeRoadmaps.isNotEmpty ? activeRoadmaps.first : null);

                return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                    crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                    children: [
                      // Header Section
                      _buildHeader(context, isDark),

                      const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      // 1. AKTİF YOL HARİTASI HERO KARTI
                      if (currentRoadmap != null) ...[
                        RoadmapCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                          roadmap: currentRoadmap,
                          isFeatured: true,
                          onTap: () => _openDetail(context, currentRoadmap),
                        ),

                        // Birden fazla aktif yol haritası varsa aralarında geçiş çipi
                        if (activeRoadmaps.length > 1) ...[
                          SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
                            scrollDirection: Axis.horizontal,
                            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                              children: activeRoadmaps.map((r) {
                                final isSelected = r.id == currentRoadmap.id;
                                return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                                  padding: const EdgeInsets.only(right: 8, bottom: 12),
                                  child: ChoiceChip(
                                    label: Text(r.title, style: const TextStyle(fontSize: 12)),
                                    selected: isSelected,
                                    onSelected: (_) => roadmapController.selectRoadmap(r),
                                    selectedColor: AppColors.primary,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],

                        // Dikey Aşama Basamakları Ağacı (Milestone Stepper Tree)
                        RoadmapNodeTree(
                          roadmap: currentRoadmap,
                          roadmapController: roadmapController,
                          habitController: habitController,
                          onNodeTap: (node) => _openDetail(context, currentRoadmap),
                        ),
                      ] else ...[
                        // Aktif harita yoksa boş durum
                        _buildEmptyActiveState(context, isDark),
                      ],

                      const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      // 2. TAMAMLANAN YOL HARİTALARI (AÇILIR/KAPANIR AKORDEON)
                      if (completedRoadmaps.isNotEmpty)
                        _buildCompletedAccordion(context, completedRoadmaps, isDark),

                      // FAB için alt boşluk
                      const SizedBox(height: 80), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( // Sayfanın üzerinde yüzen hızlı aksiyon butonu (FAB)
        onPressed: () => _openCreateSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 4, // Kartın arkasına gölge veriyoruz (z koordinatı)
        tooltip: 'Yeni Yol Haritası Ekle',
        child: const Icon(Icons.add_rounded, size: 28, color: AppColors.onPrimary),
      ),
    );
  }

  /// Üst Başlık Bölümü
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              Text(
                'Yol Haritası & Hedefler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.01,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text(
                'Basamak basamak inşa edilen büyük alışkanlıklar',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          mainAxisSize: MainAxisSize.min,
          children: [
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              width: 38,
              height: 38,
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
              child: IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                icon: const Icon(Icons.tune_rounded, size: 18),
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                padding: EdgeInsets.zero,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                    const SnackBar(content: Text('Yol haritası filtreleme aktif.')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              width: 38,
              height: 38,
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
              child: IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                padding: EdgeInsets.zero,
                onPressed: roadmapController.toggleCompletedAccordion,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Aktif Harita Bulunmadığında Boş Durum
  Widget _buildEmptyActiveState(BuildContext context, bool isDark) {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
        ),
      ),
      child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: [
            Icon(Icons.alt_route_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.8)),
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Aktif Bir Yol Haritanız Yok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Büyük bir hedefi basamaklara ayırmak için yeni bir yol haritası oluşturun.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            ElevatedButton.icon(
              onPressed: () => _openCreateSheet(context),
              icon: const Icon(Icons.add, size: 16, color: AppColors.onPrimary),
              label: const Text('Yeni Yol Haritası Başlat', style: TextStyle(color: AppColors.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tamamlanan Yol Haritaları Akordeonu (Expansion Accordion)
  Widget _buildCompletedAccordion(
    BuildContext context,
    List<RoadmapModel> completedRoadmaps,
    bool isDark,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: roadmapController.isCompletedExpandedNotifier,
      builder: (context, isExpanded, _) {
        return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: [
            InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
              onTap: roadmapController.toggleCompletedAccordion,
              borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(
                    color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                  ),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    const Icon(Icons.task_alt_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Text(
                        'Tamamlanan Yol Haritaları (${completedRoadmaps.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.onSurface : AppColors.textLight,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              ...completedRoadmaps.map((r) {
                return RoadmapCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  roadmap: r,
                  isFeatured: false,
                  onTap: () => _openDetail(context, r),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
