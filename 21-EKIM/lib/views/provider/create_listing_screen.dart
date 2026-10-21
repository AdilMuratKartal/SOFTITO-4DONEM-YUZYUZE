import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listing_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _districtController;
  late final TextEditingController _priceController;
  late final TextEditingController _shopAddressController;

  String _selectedSector = 'Tesisat';
  String _selectedLocationType = 'her_ikisi';

  final List<String> _availableSlots = [
    '09:00',
    '10:30',
    '12:00',
    '13:30',
    '15:00',
    '16:30',
    '18:00',
  ];
  final Set<String> _selectedSlots = {'09:00', '10:30', '13:30', '15:00'};

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    _titleController = TextEditingController();
    _districtController = TextEditingController(text: 'Kadıköy / Üsküdar');
    _priceController = TextEditingController(text: '400');
    _shopAddressController = TextEditingController(
      text: user?.shopAddress ?? 'Üsküdar Selimiye Mah. No:5, İstanbul',
    );
    if (user?.sector != null && user!.sector!.isNotEmpty) {
      _selectedSector = user.sector!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _districtController.dispose();
    _priceController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  void _saveListing() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir müsait saat dilimi seçiniz.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final listingProvider = context.read<ListingProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    final newListing = ListingModel(
      id: 'lst-${DateTime.now().millisecondsSinceEpoch}',
      providerId: user.id,
      providerName: user.name,
      title: _titleController.text.trim(),
      sector: _selectedSector,
      district: _districtController.text.trim(),
      shopAddress: _shopAddressController.text.trim(),
      locationType: _selectedLocationType,
      basePrice: double.tryParse(_priceController.text.trim()) ?? 400.0,
      timeSlots: _selectedSlots.toList()..sort(),
      availableDays: const ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'],
    );

    listingProvider.addListing(newListing);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yeni ilanınız ve müsaitlik takviminiz yayınlandı!'),
        backgroundColor: AppColors.approvedText,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yeni İlan & Müsaitlik Aç'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // İlan Başlığı
              const Text('Hizmet / İlan Başlığı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Örn: Kombi Bakımı ve Petek Temizliği'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Başlık zorunludur' : null,
              ),
              const SizedBox(height: 14),

              // Sektör Seçimi
              const Text('Sektör', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: AppConstants.sectors.contains(_selectedSector) ? _selectedSector : 'Tesisat',
                items: AppConstants.sectors
                    .where((s) => s != 'Tümü')
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSector = val);
                },
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 14),

              // Ulaşım / Hizmet Verme Şekli
              const Text('Çalışma Şekli (Ulaşım Tercihi)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedLocationType,
                items: const [
                  DropdownMenuItem(value: 'her_ikisi', child: Text('Her İkisi de (Adreste veya Dükkanda)')),
                  DropdownMenuItem(value: 'sen_gel', child: Text('Yalnızca Adrese Git (Sen Gel)')),
                  DropdownMenuItem(value: 'ben_geleyim', child: Text('Yalnızca Dükkanda Hizmet Ver (Ben Geleyim)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLocationType = val);
                },
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 14),

              // İlçe / Konum ve Dükkan Adresi
              const Text('Hizmet Bölgesi / İlçe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(hintText: 'Örn: Kadıköy / Üsküdar / Ataşehir'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Bölge bilgisi zorunludur' : null,
              ),
              const SizedBox(height: 14),

              const Text('Sabit Dükkan / Ofis Adresi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _shopAddressController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Müşterinin geleceği açık adres...'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Adres bilgisi zorunludur' : null,
              ),
              const SizedBox(height: 14),

              // Taban Fiyat
              const Text('Başlangıç / Taban Fiyat (₺)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.currency_lira, color: AppColors.secondary)),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Geçerli fiyat giriniz' : null,
              ),
              const SizedBox(height: 16),

              // Müsait Saat Blokları
              const Text('Müsait Olduğunuz Saat Dilimlerini Seçiniz', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableSlots.map<Widget>((slot) {
                  final isSelected = _selectedSlots.contains(slot);
                  return FilterChip(
                    label: Text(slot),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSlots.add(slot);
                        } else {
                          _selectedSlots.remove(slot);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveListing,
                  child: const Text('İlanı Yayınla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
