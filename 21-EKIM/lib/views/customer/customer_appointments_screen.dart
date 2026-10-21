import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../shared/offer_form_screen.dart';
import '../shared/chat_screen.dart';
import '../shared/widgets/status_badge.dart';
import '../shared/widgets/location_badge.dart';

class CustomerAppointmentsScreen extends StatelessWidget {
  final bool isTab;

  const CustomerAppointmentsScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final currentUser = authProvider.currentUser;

    final customerAppointments = currentUser != null
        ? appointmentProvider.getByCustomer(currentUser.id)
        : [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Randevularım ve Tekliflerim'),
        automaticallyImplyLeading: !isTab,
      ),
      body: customerAppointments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_month_outlined, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aktif Randevunuz Bulunmuyor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'İlanlar sekmesinden kuaför, tesisatçı veya öğretmen ilanlarını inceleyip teklif oluşturabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customerAppointments.length,
              itemBuilder: (context, index) {
                final apt = customerAppointments[index];

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
                              '${apt.providerName} • ${apt.appointmentDate} ${apt.appointmentTime}',
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
                                    const Text(
                                      'Hizmet Yeri: ',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
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

                      // Açıklama / Not
                      if (apt.description.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.notes_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Açıklama: ${apt.description}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Karşı Teklif Uyarısı
                      if (apt.status == 'beklemede' && apt.lastOfferBy == 'provider') ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.pendingBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.pendingText.withAlpha(60)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.pendingText, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hizmet veren yeni bir fiyat/saat karşı teklifi sundu! (${apt.offeredPrice.toStringAsFixed(0)} ₺)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pendingText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Taşmaları Önleyen Wrap Aksiyon Butonları
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (apt.status == 'beklemede' && apt.lastOfferBy == 'provider') ...[
                            ElevatedButton(
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'onaylandi');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Karşı teklifi onayladınız! Randevu kesinleşti.'),
                                    backgroundColor: AppColors.approvedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.approvedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Kabul Et (Onayla)', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          if (apt.status == 'beklemede') ...[
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
                              child: const Text('Tekrar Teklif Ver', style: TextStyle(fontSize: 12)),
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
                            label: const Text('Mesaj Gönder', style: TextStyle(fontSize: 12)),
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
