import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/listing_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/listing_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

class CreateListingScreen extends StatefulWidget { // CreateListingScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const CreateListingScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _districtController;
  late final TextEditingController _priceController;
  late final TextEditingController _shopAddressController;

  String _selectedSector = 'Tesisat'; // String türünden _selectedSector değişkenimiz
  String _selectedLocationType = 'her_ikisi'; // String türünden _selectedLocationType değişkenimiz

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

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    _titleController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    _districtController = TextEditingController(text: 'Kadıköy / Üsküdar'); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    _priceController = TextEditingController(text: '400'); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    _shopAddressController = TextEditingController( // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
      text: user?.shopAddress ?? 'Üsküdar Selimiye Mah. No:5, İstanbul',
    );
    if (user?.sector != null && user!.sector!.isNotEmpty) {
      _selectedSector = user.sector!;
    }
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _titleController.dispose();
    _districtController.dispose();
    _priceController.dispose();
    _shopAddressController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  void _saveListing() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
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
      providerId: user.id, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      providerName: user.name, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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

    ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
      const SnackBar(
        content: Text('Yeni ilanınız ve müsaitlik takviminiz yayınlandı!'),
        backgroundColor: AppColors.approvedText,
      ),
    );
    Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Yeni İlan & Müsaitlik Aç'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              // İlan Başlığı
              const Text('Hizmet / İlan Başlığı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Örn: Kombi Bakımı ve Petek Temizliği'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Başlık zorunludur' : null,
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Sektör Seçimi
              const Text('Sektör', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              DropdownButtonFormField<String>(
                initialValue: AppConstants.sectors.contains(_selectedSector) ? _selectedSector : 'Tesisat',
                items: AppConstants.sectors
                    .where((s) => s != 'Tümü')
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSector = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                },
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Ulaşım / Hizmet Verme Şekli
              const Text('Çalışma Şekli (Ulaşım Tercihi)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              DropdownButtonFormField<String>(
                initialValue: _selectedLocationType,
                items: const [
                  DropdownMenuItem(value: 'her_ikisi', child: Text('Her İkisi de (Adreste veya Dükkanda)')),
                  DropdownMenuItem(value: 'sen_gel', child: Text('Yalnızca Adrese Git (Sen Gel)')),
                  DropdownMenuItem(value: 'ben_geleyim', child: Text('Yalnızca Dükkanda Hizmet Ver (Ben Geleyim)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLocationType = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                },
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // İlçe / Konum ve Dükkan Adresi
              const Text('Hizmet Bölgesi / İlçe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: _districtController,
                decoration: const InputDecoration(hintText: 'Örn: Kadıköy / Üsküdar / Ataşehir'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Bölge bilgisi zorunludur' : null,
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              const Text('Sabit Dükkan / Ofis Adresi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: _shopAddressController,
                maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                decoration: const InputDecoration(hintText: 'Müşterinin geleceği açık adres...'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Adres bilgisi zorunludur' : null,
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Taban Fiyat
              const Text('Başlangıç / Taban Fiyat (₺)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.currency_lira, color: AppColors.secondary)),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Geçerli fiyat giriniz' : null,
              ),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Müsait Saat Blokları
              const Text('Müsait Olduğunuz Saat Dilimlerini Seçiniz', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
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
                      setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
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
              const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
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
