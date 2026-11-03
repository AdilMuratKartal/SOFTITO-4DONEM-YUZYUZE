import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../controllers/roadmap_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../widgets/roadmap_node_tree.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/confirmation_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// Yol Haritası Detay Ekranı (Düğüm Ağacı ve Görevler)
class RoadmapDetailView extends StatelessWidget { // RoadmapDetailView sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final RoadmapModel roadmap; // RoadmapModel türünden roadmap adlı değişkenimiz
  final RoadmapController roadmapController; // RoadmapController türünden roadmapController adlı değişkenimiz
  final HabitController habitController; // HabitController türünden habitController adlı değişkenimiz

  const RoadmapDetailView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.roadmap, // roadmap parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.roadmapController, // roadmapController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.habitController, // habitController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<RoadmapModel>>(
      valueListenable: roadmapController.roadmapsNotifier,
      builder: (context, roadmaps, _) {
        final currentRoadmap = roadmaps.firstWhere(
          (r) => r.id == roadmap.id,
          orElse: () => roadmap,
        );

        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
            title: Text(currentRoadmap.title), // Sayfa başlığını ekrana yazdırıyoruz
            actions: [
              IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                tooltip: 'Yol Haritasını Sil',
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context: context,
                    title: 'Yol Haritasını Sil?',
                    message: '"${currentRoadmap.title}" yol haritasını silmek istediğinize emin misiniz?',
                    confirmText: 'Evet, Sil',
                    confirmColor: AppColors.danger,
                    isDestructive: true,
                  );
                  if (confirmed && context.mounted) {
                    roadmapController.deleteRoadmap(currentRoadmap.id);
                    Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                  }
                },
              ),
            ],
          ),
          body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
            child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  // Detay Başlık Özeti
                  Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    padding: const EdgeInsets.all(AppSizes.spaceLg),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(
                        color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.5) : AppColors.borderLight,
                      ),
                    ),
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                      children: [
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                                child: Text(currentRoadmap.iconName, style: const TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                children: [
                                  Text(
                                    currentRoadmap.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                  Text(
                                    '${currentRoadmap.category} • ${currentRoadmap.durationWeeks}',
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

                        const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                        // İlerleme Barı
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                          children: [
                            Text(
                              '${currentRoadmap.completedNodesCount} / ${currentRoadmap.nodes.length} Aşama Tamamlandı',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            Text(
                              '%${currentRoadmap.progressPercentage.toInt()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          child: LinearProgressIndicator(
                            value: currentRoadmap.progressRatio,
                            minHeight: 8,
                            backgroundColor: isDark ? AppColors.surfaceContainerHighest : AppColors.borderLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  // Düğüm Ağacı
                  RoadmapNodeTree(
                    roadmap: currentRoadmap,
                    roadmapController: roadmapController,
                    habitController: habitController,
                    onNodeTap: (node) {
                      _showNodeDetailsModal(context, currentRoadmap, node, isDark);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNodeDetailsModal(
    BuildContext context,
    RoadmapModel roadmap,
    RoadmapNodeModel node,
    bool isDark,
  ) {
    showModalBottomSheet( // Ekranın altından yukarı doğru açılan modal form penceresi
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
              children: [
                Text(
                  'Basamak ${node.stepNumber}: ${node.title}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              node.description,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Gereken Seri Hedefi: ${node.targetDaysStreak} Gün',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            if (!node.isCompleted && !node.isLocked)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    roadmapController.completeNodeManually(roadmap.id, node.id);
                    Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: AppColors.onPrimary),
                  label: const Text('Bu Aşamayı Tamamlandı Olarak İşaretle', style: TextStyle(color: AppColors.onPrimary)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
