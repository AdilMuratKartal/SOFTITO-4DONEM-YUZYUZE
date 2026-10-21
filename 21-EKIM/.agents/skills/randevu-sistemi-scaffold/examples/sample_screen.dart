import 'package:flutter/material.dart';

/// AppColors: THEME.md standart renk paleti
class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFFEA580C);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  // Durum Renkleri
  static const Color approvedText = Color(0xFF16A34A);
  static const Color approvedBg = Color(0xFFDCFCE7);
  static const Color pendingText = Color(0xFFD97706);
  static const Color pendingBg = Color(0xFFFEF3C7);
  static const Color cancelledText = Color(0xFFDC2626);
  static const Color cancelledBg = Color(0xFFFEE2E2);
  static const Color completedText = Color(0xFF475569);
  static const Color completedBg = Color(0xFFF1F5F9);

  // Konum Renkleri (Gel / Git)
  static const Color comeToMeText = Color(0xFF7C3AED);
  static const Color comeToMeBg = Color(0xFFEDE9FE);
  static const Color iWillComeText = Color(0xFF0284C7);
  static const Color iWillComeBg = Color(0xFFE0F2FE);
}

/// Altın Standart Referans Ekran: Randevu Teklif ve Adres Ekranı (OfferFormScreen)
/// Bu ekran hem ilk teklif vermede hem de "Karşı Teklif (Counter Offer)" sürecinde kullanılır.
class SampleOfferFormScreen extends StatefulWidget {
  final String providerName;
  final String serviceTitle;
  final String shopAddress;
  final String customerSavedAddress;
  final double basePrice;
  final bool isCounterOffer;
  final String? initialTime;
  final double? initialPrice;

  const SampleOfferFormScreen({
    super.key,
    required this.providerName,
    required this.serviceTitle,
    required this.shopAddress,
    required this.customerSavedAddress,
    required this.basePrice,
    this.isCounterOffer = false,
    this.initialTime,
    this.initialPrice,
  });

  @override
  State<SampleOfferFormScreen> createState() => _SampleOfferFormScreenState();
}

class _SampleOfferFormScreenState extends State<SampleOfferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _customAddressController;
  late final TextEditingController _noteController;

  // Seçili saat dilimi
  String? _selectedTime;

  // Ulaşım tercihi: 'sen_gel' (Adrese Servis) | 'ben_geleyim' (Dükkanda Hizmet)
  String _selectedLocationType = 'sen_gel';

  // Profil kayıtlı adresi kullanılsın mı?
  bool _useProfileAddress = true;

  // Örnek saat dilimleri ve doluluk durumları
  final List<Map<String, dynamic>> _mockTimeSlots = const [
    {'time': '09:00', 'isBooked': false},
    {'time': '10:30', 'isBooked': true}, // Dolu randevu
    {'time': '12:00', 'isBooked': false},
    {'time': '14:00', 'isBooked': false},
    {'time': '15:30', 'isBooked': true}, // Dolu randevu
    {'time': '17:00', 'isBooked': false},
  ];

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: (widget.initialPrice ?? widget.basePrice).toStringAsFixed(0),
    );
    _customAddressController = TextEditingController();
    _noteController = TextEditingController();
    _selectedTime = widget.initialTime ?? '12:00';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _customAddressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitOffer() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen uygun bir randevu saati seçiniz.')),
      );
      return;
    }

    final double price = double.tryParse(_priceController.text) ?? widget.basePrice;
    final String finalAddress = _selectedLocationType == 'ben_geleyim'
        ? widget.shopAddress
        : (_useProfileAddress ? widget.customerSavedAddress : _customAddressController.text);

    // Geriye teklif özetini döndür
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isCounterOffer ? 'Karşı Teklif Gönderildi' : 'Teklif Gönderildi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hizmet: ${widget.serviceTitle}'),
            Text('Uzman: ${widget.providerName}'),
            Text('Saat: $_selectedTime'),
            Text('Teklif Edilen Fiyat: ${price.toStringAsFixed(0)} ₺'),
            Text('Ulaşım: ${_selectedLocationType == "sen_gel" ? "Sen Gel (Adrese)" : "Ben Geleyim (Dükkanda)"}'),
            const SizedBox(height: 6),
            Text('Adres: $finalAddress', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          widget.isCounterOffer ? 'Karşı Teklif Sun' : 'Randevu ve Teklif Formu',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hizmet ve Uzman Bilgi Kartı
                _buildHeaderCard(),
                const SizedBox(height: 16),

                // 1. Saat Dilimi Seçimi
                const Text(
                  'Uygun Saat Dilimi Seçiniz',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeSlotSection(),
                const SizedBox(height: 16),

                // 2. Konum / Ulaşım Tercihi
                const Text(
                  'Ulaşım ve Konum Tercihi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildLocationTypeSelector(),
                const SizedBox(height: 12),

                // 3. Adres Yönetimi Kartı
                _buildAddressSection(),
                const SizedBox(height: 16),

                // 4. Fiyat Teklifi ve Not
                _buildPriceAndNoteSection(),
                const SizedBox(height: 24),

                // Gönder Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitOffer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCounterOffer ? AppColors.secondary : AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      widget.isCounterOffer ? 'Karşı Teklifi Gönder' : 'Teklif Ver ve Randevu İste',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.handyman_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.serviceTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.providerName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.basePrice.toStringAsFixed(0)} ₺',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _mockTimeSlots.map((slot) {
        final String time = slot['time'] as String;
        final bool isBooked = slot['isBooked'] as bool;
        final bool isSelected = _selectedTime == time;

        return GestureDetector(
          onTap: isBooked
              ? null
              : () {
                  setState(() {
                    _selectedTime = time;
                  });
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.grey.shade200
                  : (isSelected ? AppColors.primary : AppColors.surface),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isBooked
                    ? Colors.grey.shade300
                    : (isSelected ? AppColors.primary : AppColors.border),
              ),
            ),
            child: Text(
              isBooked ? '$time (Dolu)' : time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: isBooked ? TextDecoration.lineThrough : null,
                color: isBooked
                    ? Colors.grey.shade500
                    : (isSelected ? Colors.white : AppColors.textPrimary),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedLocationType = 'sen_gel';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeBg : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeText : AppColors.border,
                  width: _selectedLocationType == 'sen_gel' ? 1.5 : 1.0,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_repair_service_outlined, size: 16, color: AppColors.comeToMeText),
                  SizedBox(width: 6),
                  Text(
                    'Sen Gel (Adrese)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.comeToMeText),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeBg : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeText : AppColors.border,
                  width: _selectedLocationType == 'ben_geleyim' ? 1.5 : 1.0,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, size: 16, color: AppColors.iWillComeText),
                  SizedBox(width: 6),
                  Text(
                    'Ben Geleyim (Dükkana)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.iWillComeText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    if (_selectedLocationType == 'ben_geleyim') {
      // Dükkan Adresi Sabit Gösterimi
      return Card(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
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
                    const Text('Dükkan/Ofis Açık Adresi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(widget.shopAddress, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sen Gel (Adrese Servis) Akışı
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
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
                  widget.customerSavedAddress,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
              )
            else
              TextFormField(
                controller: _customAddressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Hizmet alınacak tam açık adresi giriniz...',
                ),
                validator: (val) {
                  if (!_useProfileAddress && (val == null || val.trim().isEmpty)) {
                    return 'Lütfen geçerli bir açık adres belirtiniz.';
                  }
                  return null;
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            if (double.tryParse(val) == null) return 'Geçerli bir rakam yazınız.';
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Açıklama / İş Detayı',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _noteController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Arıza durumu, ek talepler veya randevu notu ekleyin...',
          ),
        ),
      ],
    );
  }
}
