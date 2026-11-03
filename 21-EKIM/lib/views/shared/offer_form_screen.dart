import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../models/listing_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/appointment_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/appointment_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'widgets/time_slot_chip.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import 'widgets/location_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class OfferFormScreen extends StatefulWidget { // OfferFormScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final ListingModel? listing; // ListingModel? türünden listing adlı değişkenimiz
  final AppointmentModel? existingAppointment; // Karşı teklif için mevcut randevu
  final bool isCounterOffer; // bool türünden isCounterOffer adlı değişkenimiz

  const OfferFormScreen({ // Genel, sabit sınıf constructor'ı
    super.key,
    this.listing, // listing alanına değer aktarıyoruz
    this.existingAppointment, // existingAppointment alanına değer aktarıyoruz
    this.isCounterOffer = false, // isCounterOffer alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends State<OfferFormScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _customAddressController;
  late final TextEditingController _noteController;

  String? _selectedTime;
  late String _selectedLocationType; // String türünden _selectedLocationType adlı değişkenimiz
  bool _useProfileAddress = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (_useProfileAddress)
  String _selectedDate = '2026-10-22'; // String türünden _selectedDate değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    final basePrice = widget.existingAppointment?.offeredPrice ??
        widget.listing?.basePrice ??
        400.0;
    _priceController = TextEditingController(text: basePrice.toStringAsFixed(0)); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    _customAddressController = TextEditingController( // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
      text: widget.existingAppointment?.address ?? '',
    );
    _noteController = TextEditingController( // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
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

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _priceController.dispose();
    _customAddressController.dispose();
    _noteController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
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

      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
        const SnackBar(
          content: Text('Karşı teklif başarıyla iletildi!'),
          backgroundColor: AppColors.approvedText,
        ),
      );
      Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
    } else if (widget.listing != null) {
      // Yeni randevu talebi / İlk teklif
      final newAppointment = AppointmentModel(
        id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
        listingId: widget.listing!.id,
        customerId: currentUser.id,
        customerName: currentUser.name,
        providerId: widget.listing!.providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
        providerName: widget.listing!.providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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

      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
        const SnackBar(
          content: Text('Teklifiniz ve randevu talebiniz hizmet verene iletildi!'),
          backgroundColor: AppColors.approvedText,
        ),
      );
      Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
    }
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final appointmentProvider = context.watch<AppointmentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    final serviceTitle = widget.listing?.title ?? widget.existingAppointment?.serviceTitle ?? 'Hizmet';
    final providerName = widget.listing?.providerName ?? widget.existingAppointment?.providerName ?? 'Uzman'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    final shopAddress = widget.listing?.shopAddress ?? 'Dükkan Adresi';
    final timeSlots = widget.listing?.timeSlots ??
        ['09:00', '10:30', '12:00', '14:00', '15:30', '17:00'];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: Text(widget.isCounterOffer ? 'Karşı Teklif Sun' : 'Randevu ve Teklif Formu'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                // Başlık Kartı
                Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.all(14),
                    child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withAlpha(25),
                          child: const Icon(Icons.handyman_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                            children: [
                              Text(
                                serviceTitle,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Text(
                                providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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
                const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                // 1. Saat Dilimi Seçimi
                const Text(
                  'Saat Dilimi Seçimi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
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
                        setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                          _selectedTime = time;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                // 2. Ulaşım ve Konum Seçimi
                const Text(
                  'Ulaşım ve Hizmet Yeri Tercihi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () {
                          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                            _selectedLocationType = 'sen_gel';
                          });
                        },
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(
                              color: _selectedLocationType == 'sen_gel' ? AppColors.comeToMeText : AppColors.border,
                              width: _selectedLocationType == 'sen_gel' ? 1.5 : 1,
                            ),
                          ),
                          child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                            children: [
                              Icon(Icons.home_repair_service_outlined, size: 15, color: AppColors.comeToMeText),
                              SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Flexible(
                                child: Text(
                                  'Sen Gel (Adrese)',
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.comeToMeText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () {
                          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                            _selectedLocationType = 'ben_geleyim';
                          });
                        },
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(
                              color: _selectedLocationType == 'ben_geleyim' ? AppColors.iWillComeText : AppColors.border,
                              width: _selectedLocationType == 'ben_geleyim' ? 1.5 : 1,
                            ),
                          ),
                          child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                            children: [
                              Icon(Icons.storefront_outlined, size: 15, color: AppColors.iWillComeText),
                              SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Flexible(
                                child: Text(
                                  'Ben Geleyim (Dükkan)',
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
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
                const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                // Adres Kartı
                if (_selectedLocationType == 'ben_geleyim') ...[
                  Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                    child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.all(12),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.iWillComeText, size: 20),
                          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                              children: [
                                const Text('Hizmet Verenin Dükkan Adresi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(shopAddress, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                    child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.all(12),
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          CheckboxListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Profilimdeki Kayıtlı Adresi Kullan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), // Sayfa başlığını ekrana yazdırıyoruz
                            value: _useProfileAddress,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                _useProfileAddress = val ?? true;
                              });
                            },
                          ),
                          if (_useProfileAddress)
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Text(
                                currentUser?.savedAddress ?? 'Kayıtlı adresiniz bulunmuyor, lütfen yeni adres giriniz.',
                                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                              ),
                            )
                          else
                            TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                              controller: _customAddressController,
                              maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
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
                const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                // 3. Fiyat Teklifi ve Not
                const Text(
                  'Fiyat Teklifiniz (₺)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
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
                const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                const Text(
                  'Detay / Açıklama',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: _noteController,
                  maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                  decoration: const InputDecoration(
                    hintText: 'İşin özeti, arıza veya randevu notunuzu belirtiniz...',
                  ),
                ),
                const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                // Gönder Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
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
