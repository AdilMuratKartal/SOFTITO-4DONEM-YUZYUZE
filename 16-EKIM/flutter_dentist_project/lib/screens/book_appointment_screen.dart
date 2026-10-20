import 'package:flutter/material.dart';
import '../models/dentist.dart';
import '../models/treatment.dart';
import '../models/time_slot.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDentistIndex = 0;
  int _selectedTreatmentIndex = -1;
  int _selectedTimeIndex = -1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          _buildStepIndicator(),
          _buildDentistSelector(),
          _buildTreatmentSelector(),
          _buildDateSelector(),
          _buildTimeSlotGrid(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 1) Üst Bar
  // ──────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      color: const Color(0xFFF8FAFC),
      child: const Text(
        'Randevu Al',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // 2) Adım Göstergesi
  // ──────────────────────────────────────────
  Widget _buildStepIndicator() {
    int currentStep = 0;
    if (_selectedDentistIndex >= 0) currentStep = 1;
    if (_selectedTreatmentIndex >= 0) currentStep = 2;
    if (_selectedTimeIndex >= 0) currentStep = 3;

    final steps = ['Doktor', 'Tedavi', 'Tarih & Saat'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i < currentStep;
          final isCurrent = i == currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF0EA5E9)
                        : isCurrent
                            ? const Color(0xFFE0F2FE)
                            : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? const Color(0xFF0EA5E9)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      color: isActive || isCurrent
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (i < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      height: 1,
                      width: 16,
                      color: isActive
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────
  // 3) Doktor Seçimi — Yatay Kartlar
  // ──────────────────────────────────────────
  Widget _buildDentistSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Doktor Seçin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyDentists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final d = dummyDentists[index];
                final isSelected = _selectedDentistIndex == index;
                return GestureDetector(
                  onTap: d.isAvailable
                      ? () => setState(() => _selectedDentistIndex = index)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: !d.isAvailable
                          ? const Color(0xFFF1F5F9)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0EA5E9).withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isSelected
                              ? Colors.white24
                              : const Color(0xFFE0F2FE),
                          child: Icon(
                            Icons.person,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF0EA5E9),
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          d.name.replaceFirst('Dr. ', ''),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: !d.isAvailable
                                ? const Color(0xFF94A3B8)
                                : isSelected
                                    ? Colors.white
                                    : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d.isAvailable ? d.specialty : 'Müsait Değil',
                          style: TextStyle(
                            fontSize: 10,
                            color: !d.isAvailable
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white70
                                    : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 4) Tedavi Seçimi — Chip Listesi
  // ──────────────────────────────────────────
  Widget _buildTreatmentSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tedavi Seçin',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(dummyTreatments.length, (index) {
              final t = dummyTreatments[index];
              final isSelected = _selectedTreatmentIndex == index;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedTreatmentIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0EA5E9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        t.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₺${t.price.toInt()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white70
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 5) Tarih Seçimi — Yatay Gün Listesi
  // ──────────────────────────────────────────
  Widget _buildDateSelector() {
    final days = List.generate(
        14, (i) => DateTime.now().add(Duration(days: i + 1)));
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tarih Seçin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = _selectedDate.day == day.day &&
                    _selectedDate.month == day.month;
                final isWeekend = day.weekday == 6 || day.weekday == 7;
                return GestureDetector(
                  onTap: isWeekend
                      ? null
                      : () => setState(() => _selectedDate = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    decoration: BoxDecoration(
                      color: isWeekend
                          ? const Color(0xFFF1F5F9)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayNames[day.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            color: isWeekend
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white70
                                    : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isWeekend
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 6) Saat Seçimi — Grid
  // ──────────────────────────────────────────
  Widget _buildTimeSlotGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saat Seçin',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: dummyTimeSlots.length,
            itemBuilder: (context, index) {
              final slot = dummyTimeSlots[index];
              final isSelected = _selectedTimeIndex == index;
              return GestureDetector(
                onTap: slot.isAvailable
                    ? () => setState(() => _selectedTimeIndex = index)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: !slot.isAvailable
                        ? const Color(0xFFF1F5F9)
                        : isSelected
                            ? const Color(0xFF0EA5E9)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !slot.isAvailable
                          ? const Color(0xFFE2E8F0)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      slot.time,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: !slot.isAvailable
                            ? const Color(0xFFCBD5E1)
                            : isSelected
                                ? Colors.white
                                : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 7) Onayla Butonu
  // ──────────────────────────────────────────
  Widget _buildConfirmButton() {
    final isReady = _selectedDentistIndex >= 0 &&
        _selectedTreatmentIndex >= 0 &&
        _selectedTimeIndex >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isReady
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Randevunuz başarıyla oluşturuldu! ✅'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5E9),
            disabledBackgroundColor: const Color(0xFFE2E8F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: isReady ? 4 : 0,
            shadowColor: const Color(0xFF0EA5E9).withOpacity(0.3),
          ),
          child: Text(
            isReady ? 'Randevuyu Onayla' : 'Lütfen Seçimlerinizi Tamamlayın',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isReady ? Colors.white : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}
