import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart';
import '../models/habit_model.dart';

/// Dinamik Yol Haritası Oluşturma Sihirbazı Modalı
class CreateRoadmapSheet extends StatefulWidget {
  final List<HabitModel> availableHabits;
  final ValueChanged<RoadmapModel> onSave;

  const CreateRoadmapSheet({
    super.key,
    required this.availableHabits,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required List<HabitModel> availableHabits,
    required ValueChanged<RoadmapModel> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateRoadmapSheet(
        availableHabits: availableHabits,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CreateRoadmapSheet> createState() => _CreateRoadmapSheetState();
}

class _CreateRoadmapSheetState extends State<CreateRoadmapSheet> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '4 Hafta');
  final _rewardController = TextEditingController(text: 'Başarı Rozeti');

  String _selectedCategory = 'Kişisel Gelişim';
  String _selectedIcon = '🎯';

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

  @override
  void initState() {
    super.initState();
    // Başlangıçta 2 adet hazır basamak ekle
    _addNode(title: 'Temel Adaptasyon & Giriş', streak: 7);
    _addNode(title: 'Derinleşme & Sürdürülebilirlik', streak: 14);
  }

  void _addNode({String title = '', int streak = 7}) {
    setState(() {
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
    setState(() {
      _nodesData.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _rewardController.dispose();
    for (var n in _nodesData) {
      (n['titleController'] as TextEditingController).dispose();
      (n['descController'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen yol haritası için bir başlık girin.')),
      );
      return;
    }

    final id = 'rm_${DateTime.now().millisecondsSinceEpoch}';

    final nodes = <RoadmapNodeModel>[];
    for (int i = 0; i < _nodesData.length; i++) {
      final data = _nodesData[i];
      final nodeTitle = (data['titleController'] as TextEditingController).text.trim();
      final nodeDesc = (data['descController'] as TextEditingController).text.trim();
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_road_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
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
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Form İçeriği
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Örn: 30 Günde 5K Koşu veya Gitar Eğitimi',
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kategori & İkon Seçimi
                  Row(
                    children: [
                      // Kategori
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kategori',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  items: _categories.map((c) {
                                    return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // İkon Seçimi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İkon',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedIcon,
                                items: _emojis.map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 18)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedIcon = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Süre ve Ödül
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tahmini Süre',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _durationController,
                              decoration: InputDecoration(
                                hintText: '4 Hafta',
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tamamlama Ödülü',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _rewardController,
                              decoration: InputDecoration(
                                hintText: 'Odak Nişanı',
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // DİNAMİK BASAMAKLAR BÖLÜMÜ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  const SizedBox(height: 8),

                  ...List.generate(_nodesData.length, (index) {
                    final nodeData = _nodesData[index];
                    final titleCtrl = nodeData['titleController'] as TextEditingController;
                    final descCtrl = nodeData['descController'] as TextEditingController;
                    final streak = nodeData['targetDaysStreak'] as int;
                    final linkedIds = nodeData['linkedHabitIds'] as List<String>;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
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
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                                  onPressed: () => _removeNode(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: titleCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Basamak Başlığı',
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Aşama Açıklaması',
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Gereken Seri (Streak):', style: TextStyle(fontSize: 12)),
                              DropdownButton<int>(
                                value: streak,
                                items: [3, 5, 7, 10, 14, 21, 30].map((d) {
                                  return DropdownMenuItem(value: d, child: Text('$d Gün'));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => nodeData['targetDaysStreak'] = val);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text('Bağlı Mikro-Alışkanlıklar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: widget.availableHabits.map((habit) {
                              final isSelected = linkedIds.contains(habit.id);
                              return FilterChip(
                                label: Text(habit.title, style: const TextStyle(fontSize: 11)),
                                selected: isSelected,
                                onSelected: (sel) {
                                  setState(() {
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

                  const SizedBox(height: 20),

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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
