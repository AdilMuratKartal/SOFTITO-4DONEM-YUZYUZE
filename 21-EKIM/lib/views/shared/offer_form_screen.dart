import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/listing_model.dart';
import '../../models/appointment_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import 'widgets/time_slot_chip.dart';
import 'widgets/location_badge.dart';

class OfferFormScreen extends StatefulWidget {
  final ListingModel? listing;
  final AppointmentModel? existingAppointment; // Karşı teklif için mevcut randevu
  final bool isCounterOffer;

  const OfferFormScreen({
    super.key,
    this.listing,
    this.existingAppointment,
    this.isCounterOffer = false,
  });

  @override
  State<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends State<OfferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _customAddressController;
  late final TextEditingController _noteController;

  String? _selectedTime;
  late String _selectedLocationType;
  bool _useProfileAddress = true;
  String _selectedDate = '2026-10-22';

  @override
  void initState() {
    super.initState();
    final basePrice = widget.existingAppointment?.offeredPrice ??
        widget.listing?.basePrice ??
        400.0;
    _priceController = TextEditingController(text: basePrice.toStringAsFixed(0));
    _customAddressController = TextEditingController(
      text: widget.existingAppointment?.address ?? '',
    );
    _noteController = TextEditingController(
      text: widget.existingAppointment?.description ?? '',
    );

    _selectedTime = widget.existingAppointment?.appointmentTime ??
        (widget.listing?.timeSlots.isNotEmpty == true ? widget.listing!.timeSlots.first : '10:30');

    if (widget.existingAppointment != null) {
      _selectedLocationType = widget.existingAppointment!.locationType;
      _selectedDate = widget.existingAppointment!.appointmentDate;
    } else {
      _selectedLocationType = widget.listing?.locationType == 'ben_geleyim'
          ? 'ben_geleyim'
          : 'sen_gel';
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _customAddressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir randevu saati seçiniz.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) return;

    final double price = double.tryParse(_priceController.text) ?? 400.0;
    final shopAddr = widget.listing?.shopAddress ??
        widget.existingAppointment?.address ??
        'Dükkan Adresi';

    final String finalAddress = _selectedLocationType == 'ben_geleyim'
        ? shopAddr
        : (_useProfileAddress
            ? (currentUser.savedAddress ?? 'Kadıköy Moda Caddesi No:18')
            : _customAddressController.text.trim());

    if (widget.isCounterOffer && widget.existingAppointment != null) {
      // Karşı teklif gönderme
      appointmentProvider.submitCounterOffer(
        appointmentId: widget.existingAppointment!.id,
        newPrice: price,
        newTime: _selectedTime!,
        counterOfferBy: currentUser.role,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karşı teklif başarıyla iletildi!'),
          backgroundColor: AppColors.approvedText,
        ),
      );
      Navigator.of(context).pop();
    } else if (widget.listing != null) {
      // Yeni randevu talebi / İlk teklif
      final newAppointment = AppointmentModel(
        id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
        listingId: widget.listing!.id,
        customerId: currentUser.id,
        customerName: currentUser.name,
        providerId: widget.listing!.providerId,
        providerName: widget.listing!.providerName,
        serviceTitle: widget.listing!.title,
        description: _noteController.text.trim().isEmpty
            ? 'Randevu talebi oluşturuldu.'
            : _noteController.text.trim(),
        appointmentDate: _selectedDate,
        appointmentTime: _selectedTime!,
        offeredPrice: price,
        locationType: _selectedLocationType,
        address: finalAddress,
        status: 'beklemede',
        lastOfferBy: 'customer',
        createdAt: DateTime.now().toIso8601String(),
      );

      appointmentProvider.createOffer(newAppointment);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teklifiniz ve randevu talebiniz hizmet verene iletildi!'),
          backgroundColor: AppColors.approvedText,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = context.watch<AppointmentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    final serviceTitle = widget.listing?.title ?? widget.existingAppointment?.serviceTitle ?? 'Hizmet';
    final providerName = widget.listing?.providerName ?? widget.existingAppointment?.providerName ?? 'Uzman';
    final shopAddress = widget.listing?.shopAddress ?? 'Dükkan Adresi';
    final timeSlots = widget.listing?.timeSlots ??
        ['09:00', '10:30', '12:00', '14:00', '15:30', '17:00'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isCounterOffer ? 'Karşı Teklif Sun' : 'Randevu ve Teklif Formu'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık Kartı
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withAlpha(25),
                          child: const Icon(Icons.handyman_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceTitle,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                providerName,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (widget.listing != null)
                          LocationBadge(locationType: widget.listing!.locationType),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Saat Dilimi Seçimi
                const Text(
                  'Saat Dilimi Seçimi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: timeSlots.map<Widget>((time) {
                    final isBooked = widget.listing != null
                        ? appointmentProvider.isSlotBooked(widget.listing!.id, _selectedDate, time)
                        : false;
                    final isSelected = _selectedTime == time;

                    return TimeSlotChip(
                      time: time,
                      isBooked: isBooked,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 2. Ulaşım ve Konum Seçimi
                const Text(
                  'Ulaşım ve Hizmet Yeri Tercihi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLocationType = 'sen_gel';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeText : AppColors.border,
                              width: _selectedLocationType == 'sen_gel' ? 1.5 : 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_repair_service_outlined, size: 15, color: AppColors.comeToMeText),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Sen Gel (Adrese)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.comeToMeText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLocationType = 'ben_geleyim';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeText : AppColors.border,
                              width: _selectedLocationType == 'ben_geleyim' ? 1.5 : 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_outlined, size: 15, color: AppColors.iWillComeText),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Ben Geleyim (Dükkan)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.iWillComeText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Adres Kartı
                if (_selectedLocationType == 'ben_geleyim') ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.iWillComeText, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hizmet Verenin Dükkan Adresi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(shopAddress, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Profilimdeki Kayıtlı Adresi Kullan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            value: _useProfileAddress,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _useProfileAddress = val ?? true;
                              });
                            },
                          ),
                          if (_useProfileAddress)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentUser?.savedAddress ?? 'Kayıtlı adresiniz bulunmuyor, lütfen yeni adres giriniz.',
                                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                              ),
                            )
                          else
                            TextFormField(
                              controller: _customAddressController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: 'Hizmet alınacak tam açık adresi yazınız...',
                              ),
                              validator: (val) {
                                if (!_useProfileAddress && (val == null || val.trim().isEmpty)) {
                                  return 'Lütfen bir açık adres belirtiniz.';
                                }
                                return null;
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // 3. Fiyat Teklifi ve Not
                const Text(
                  'Fiyat Teklifiniz (₺)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_lira, color: AppColors.secondary),
                    hintText: 'Örn: 450',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Lütfen teklif tutarı giriniz.';
                    if (double.tryParse(val) == null) return 'Geçerli bir rakam giriniz.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Detay / Açıklama',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'İşin özeti, arıza veya randevu notunuzu belirtiniz...',
                  ),
                ),
                const SizedBox(height: 24),

                // Gönder Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCounterOffer ? AppColors.secondary : AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      widget.isCounterOffer ? 'Karşı Teklifi Gönder' : 'Teklif Ver ve Randevu İste',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
