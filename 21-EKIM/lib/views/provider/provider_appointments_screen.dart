import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../shared/offer_form_screen.dart';
import '../shared/chat_screen.dart';
import '../shared/profile_screen.dart';
import '../shared/conversations_screen.dart';
import '../shared/widgets/status_badge.dart';
import '../shared/widgets/location_badge.dart';
import 'provider_listings_screen.dart';

class ProviderAppointmentsScreen extends StatefulWidget {
  final int initialIndex;

  const ProviderAppointmentsScreen({super.key, this.initialIndex = 0});

  @override
  State<ProviderAppointmentsScreen> createState() => _ProviderAppointmentsScreenState();
}

class _ProviderAppointmentsScreenState extends State<ProviderAppointmentsScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _ProviderAppointmentsTab(),
      const ProviderListingsScreen(isTab: true),
      const ConversationsScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary.withAlpha(30),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox, color: AppColors.secondary),
            label: 'Talepler',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.secondary),
            label: 'İlanlarım',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
            label: 'Mesajlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _ProviderAppointmentsTab extends StatelessWidget {
  const _ProviderAppointmentsTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final currentUser = authProvider.currentUser;

    final providerAppointments = currentUser != null
        ? appointmentProvider.getByProvider(currentUser.id)
        : [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gelen Talepler & Randevular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'Aktif: ${currentUser?.name ?? "Hizmet Veren"}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: providerAppointments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.inbox_outlined, size: 48, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Henüz Gelen Randevu Talebi Yok',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Müşteriler ilanlarınıza teklif verdiğinde talepler anlık olarak burada listelenecektir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: providerAppointments.length,
              itemBuilder: (context, index) {
                final apt = providerAppointments[index];

                return Card(
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            apt.serviceTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${apt.offeredPrice.toStringAsFixed(0)} ₺',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Müşteri: ${apt.customerName} • ${apt.appointmentDate} ${apt.appointmentTime}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                          StatusBadge(status: apt.status),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 6),

                      // Ulaşım ve Açık Adres
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Hizmet Konumu: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    LocationBadge(locationType: apt.locationType),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  apt.address,
                                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (apt.description.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.notes_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Müşteri Notu: ${apt.description}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      const SizedBox(height: 10),

                      // Hizmet Veren Yönetim Butonları (Wrap ile taşma korumalı)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (apt.status == 'beklemede') ...[
                            ElevatedButton(
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'onaylandi');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Randevu başarıyla onaylandı! Saat rezerve edildi.'),
                                    backgroundColor: AppColors.approvedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.approvedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Onayla', style: TextStyle(fontSize: 12)),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OfferFormScreen(
                                      existingAppointment: apt,
                                      isCounterOffer: true,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.secondary),
                                foregroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Karşı Teklif Sun', style: TextStyle(fontSize: 12)),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'iptal');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Randevu talebi reddedildi/iptal edildi.'),
                                    backgroundColor: AppColors.cancelledText,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.cancelledText),
                                foregroundColor: AppColors.cancelledText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('İptal Et', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          if (apt.status == 'onaylandi') ...[
                            ElevatedButton(
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'bitti');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Hizmet tamamlandı olarak işaretlendi.'),
                                    backgroundColor: AppColors.completedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.completedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('İşi Tamamla (Bitti)', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(appointment: apt),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 14),
                            label: const Text('Mesajlaş', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
