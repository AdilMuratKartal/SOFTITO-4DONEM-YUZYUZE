import 'package:flutter/material.dart';
import '../models/appointment.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> _filterByStatuses(List<AppointmentStatus> statuses) {
    return dummyAppointments
        .where((a) => statuses.contains(a.status))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(
                _filterByStatuses([
                  AppointmentStatus.confirmed,
                  AppointmentStatus.pending,
                ]),
                emptyMessage: 'Aktif randevunuz bulunmuyor.',
              ),
              _buildAppointmentList(
                _filterByStatuses([AppointmentStatus.completed]),
                emptyMessage: 'Tamamlanmış randevunuz yok.',
              ),
              _buildAppointmentList(
                _filterByStatuses([AppointmentStatus.cancelled]),
                emptyMessage: 'İptal edilen randevu yok.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  // 1) Üst Başlık
  // ──────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      color: const Color(0xFFF8FAFC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Randevularım',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${dummyAppointments.length} kayıt',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0EA5E9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 2) Tab Bar — Aktif / Tamamlanan / İptal
  // ──────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFF0EA5E9),
        unselectedLabelColor: const Color(0xFF94A3B8),
        labelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Aktif'),
          Tab(text: 'Tamamlanan'),
          Tab(text: 'İptal'),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 3) Randevu Listesi
  // ──────────────────────────────────────────
  Widget _buildAppointmentList(
    List<Appointment> appointments, {
    required String emptyMessage,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy_rounded,
                size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _appointmentCard(appointments[index]);
      },
    );
  }

  // ──────────────────────────────────────────
  // 4) Tek Randevu Kartı
  // ──────────────────────────────────────────
  Widget _appointmentCard(Appointment appt) {
    final statusInfo = _statusStyle(appt.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Üst: Doktor bilgisi + durum badge
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE0F2FE),
                child: Text(
                  appt.dentist.name.split(' ').last[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.dentist.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appt.dentist.specialty,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusInfo.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusInfo.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusInfo.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),
          // Alt: Tedavi, tarih, saat
          Row(
            children: [
              _infoChip(Icons.medical_services_outlined,
                  appt.treatment.name),
              const Spacer(),
              _infoChip(Icons.calendar_today_rounded,
                  '${appt.date.day}/${appt.date.month}/${appt.date.year}'),
              const SizedBox(width: 12),
              _infoChip(Icons.access_time_rounded, appt.time),
            ],
          ),
          // İptal / Yeniden planla butonları (aktif randevularda)
          if (appt.status == AppointmentStatus.confirmed ||
              appt.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Randevu iptal edildi.'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('İptal Et',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Yeniden planlama açıldı.'),
                          backgroundColor: Color(0xFF0EA5E9),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text('Yeniden Planla',
                        style:
                            TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  _StatusStyle _statusStyle(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return _StatusStyle('Onaylandı', const Color(0xFF22C55E));
      case AppointmentStatus.pending:
        return _StatusStyle('Bekliyor', const Color(0xFFF59E0B));
      case AppointmentStatus.cancelled:
        return _StatusStyle('İptal', const Color(0xFFEF4444));
      case AppointmentStatus.completed:
        return _StatusStyle('Tamamlandı', const Color(0xFF6366F1));
    }
  }
}

class _StatusStyle {
  final String label;
  final Color color;
  const _StatusStyle(this.label, this.color);
}
