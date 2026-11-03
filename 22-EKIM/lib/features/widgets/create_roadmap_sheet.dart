import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/habit_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Dinamik Yol Haritası Oluşturma Sihirbazı Modalı
class CreateRoadmapSheet extends StatefulWidget { // CreateRoadmapSheet sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final List<HabitModel> availableHabits; // List<HabitModel> türünden availableHabits adlı değişkenimiz
  final ValueChanged<RoadmapModel> onSave; // ValueChanged<RoadmapModel> türünden onSave adlı değişkenimiz

  const CreateRoadmapSheet({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.availableHabits, // availableHabits parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onSave, // onSave parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  static Future<void> show({
    required BuildContext context,
    required List<HabitModel> availableHabits,
    required ValueChanged<RoadmapModel> onSave,
  }) {
    return showModalBottomSheet( // Ekranın altından yukarı doğru açılan modal form penceresi
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateRoadmapSheet(
        availableHabits: availableHabits,
        onSave: onSave,
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<CreateRoadmapSheet> createState() => _CreateRoadmapSheetState();
}

class _CreateRoadmapSheetState extends State<CreateRoadmapSheet> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final _titleController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  final _durationController = TextEditingController(text: '4 Hafta'); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  final _rewardController = TextEditingController(text: 'Başarı Rozeti'); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz

  String _selectedCategory = 'Kişisel Gelişim'; // String türünden _selectedCategory değişkenimiz
  String _selectedIcon = '🎯'; // String türünden _selectedIcon değişkenimiz

  final List<Map<String, dynamic>> _nodesData = [];

  final List<String> _categories = [
    'Kişisel Gelişim',
    'Spor',
    'Sağlık',
    'Zihin',
    'Müzik & Sanat',
    'Kariyer',
  ];

  final List<String> _emojis = ['🎯', '🏃', '💧', '📚', '🎸', '🧘', '🌙', '⚡', '💻'];

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    // Başlangıçta 2 adet hazır basamak ekle
    _addNode(title: 'Temel Adaptasyon & Giriş', streak: 7);
    _addNode(title: 'Derinleşme & Sürdürülebilirlik', streak: 14);
  }

  void _addNode({String title = '', int streak = 7}) {
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _nodesData.add({
        'titleController': TextEditingController(text: title),
        'descController': TextEditingController(text: 'Bu aşamadaki hedefleri düzenli sürdürün.'),
        'targetDaysStreak': streak,
        'linkedHabitIds': <String>[],
      });
    });
  }

  void _removeNode(int index) {
    if (_nodesData.length <= 1) return;
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _nodesData.removeAt(index);
    });
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _titleController.dispose();
    _durationController.dispose();
    _rewardController.dispose();
    for (var n in _nodesData) {
      (n['titleController'] as TextEditingController).dispose();
      (n['descController'] as TextEditingController).dispose();
    }
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
        const SnackBar(content: Text('Lütfen yol haritası için bir başlık girin.')),
      );
      return;
    }

    final id = 'rm_${DateTime.now().millisecondsSinceEpoch}';

    final nodes = <RoadmapNodeModel>[];
    for (int i = 0; i < _nodesData.length; i++) {
      final data = _nodesData[i];
      final nodeTitle = (data['titleController'] as TextEditingController).text.trim(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
      final nodeDesc = (data['descController'] as TextEditingController).text.trim(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
      final streak = data['targetDaysStreak'] as int? ?? 7;
      final linkedIds = List<String>.from(data['linkedHabitIds'] as List);

      nodes.add(
        RoadmapNodeModel(
          id: '${id}_node_${i + 1}',
          stepNumber: i + 1,
          title: nodeTitle.isEmpty ? 'Basamak ${i + 1}' : nodeTitle,
          description: nodeDesc,
          targetDaysStreak: streak,
          linkedHabitIds: linkedIds,
          isCompleted: false,
          isLocked: i != 0, // İlk basamak açık, sonrakiler kilitli
        ),
      );
    }

    final newRoadmap = RoadmapModel(
      id: id,
      title: title,
      category: _selectedCategory,
      iconName: _selectedIcon,
      durationWeeks: _durationController.text.trim().isEmpty ? '4 Hafta' : _durationController.text.trim(),
      nextReward: _rewardController.text.trim().isEmpty ? 'Özel Rozet' : _rewardController.text.trim(),
      isCompleted: false,
      nodes: nodes,
    );

    widget.onSave(newRoadmap);
    Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.9,
      ),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          // Drag Handle
          Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
            ),
          ),

          // Header
          Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
              children: [
                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    const Icon(Icons.add_road_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text(
                      'Yeni Yol Haritası',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                ),
              ],
            ),
          ),

          const Divider(height: 1), // Bölümler arasına ince bir ayırıcı çizgi çekmek için

          // Form İçeriği
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
              padding: const EdgeInsets.all(20),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  // Başlık Alanı
                  Text(
                    'Hedef Yol Haritası Başlığı',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  TextField( // Kullanıcıdan metin girdisi almak için form alanı
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Örn: 30 Günde 5K Koşu veya Gitar Eğitimi',
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  // Kategori & İkon Seçimi
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      // Kategori
                      Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            Text(
                              'Kategori',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  items: _categories.map((c) {
                                    return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      // İkon Seçimi
                      Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Text(
                            'İkon',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedIcon,
                                items: _emojis.map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 18)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedIcon = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  // Süre ve Ödül
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            Text(
                              'Tahmini Süre',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            TextField( // Kullanıcıdan metin girdisi almak için form alanı
                              controller: _durationController,
                              decoration: InputDecoration(
                                hintText: '4 Hafta',
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            Text(
                              'Tamamlama Ödülü',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            TextField( // Kullanıcıdan metin girdisi almak için form alanı
                              controller: _rewardController,
                              decoration: InputDecoration(
                                hintText: 'Odak Nişanı',
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  // DİNAMİK BASAMAKLAR BÖLÜMÜ
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                    children: [
                      Text(
                        'Aşama Basamakları (${_nodesData.length})',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.onSurface : AppColors.textLight,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _addNode(title: 'Yeni Basamak', streak: 7),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Basamak Ekle'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  ...List.generate(_nodesData.length, (index) {
                    final nodeData = _nodesData[index];
                    final titleCtrl = nodeData['titleController'] as TextEditingController; // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
                    final descCtrl = nodeData['descController'] as TextEditingController; // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
                    final streak = nodeData['targetDaysStreak'] as int;
                    final linkedIds = nodeData['linkedHabitIds'] as List<String>;

                    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(
                          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                        ),
                      ),
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                            children: [
                              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                ),
                                child: Text(
                                  'Basamak ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              if (_nodesData.length > 1)
                                IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                                  onPressed: () => _removeNode(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          TextField( // Kullanıcıdan metin girdisi almak için form alanı
                            controller: titleCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Basamak Başlığı',
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          TextField( // Kullanıcıdan metin girdisi almak için form alanı
                            controller: descCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Aşama Açıklaması',
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                            children: [
                              const Text('Gereken Seri (Streak):', style: TextStyle(fontSize: 12)),
                              DropdownButton<int>(
                                value: streak,
                                items: [3, 5, 7, 10, 14, 21, 30].map((d) {
                                  return DropdownMenuItem(value: d, child: Text('$d Gün'));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => nodeData['targetDaysStreak'] = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          const Text('Bağlı Mikro-Alışkanlıklar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                            spacing: 6,
                            runSpacing: 4,
                            children: widget.availableHabits.map((habit) {
                              final isSelected = linkedIds.contains(habit.id);
                              return FilterChip(
                                label: Text(habit.title, style: const TextStyle(fontSize: 11)),
                                selected: isSelected,
                                onSelected: (sel) {
                                  setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                    if (sel) {
                                      linkedIds.add(habit.id);
                                    } else {
                                      linkedIds.remove(habit.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                  // Onay Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.flag_rounded, color: AppColors.onPrimary),
                      label: const Text(
                        'Yol Haritasını Başlat',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
