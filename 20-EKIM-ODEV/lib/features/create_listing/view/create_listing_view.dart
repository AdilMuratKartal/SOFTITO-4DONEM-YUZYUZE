// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Context extension ile tema renklerine ve SnackBar yardımcısına erişim sağlıyoruz
import '../../../core/extensions/context_extensions.dart';
// Üretilecek araç veri modelini içe aktarıyoruz
import '../../car_listing/models/car_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// İlan verme formu iş mantığı ve doğrulama denetleyicisini içe aktarıyoruz
import '../controller/create_listing_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Takvimden müsaitlik tarih aralığı seçici bileşenini içe aktarıyoruz
import '../widget/date_range_picker_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
// Yakıt / batarya kaydırıcı bileşenini içe aktarıyoruz
import '../widget/fuel_input_slider.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
// 140px sabit boyutlu resim seçici alanını içe aktarıyoruz
import '../widget/image_upload_placeholder.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// TakeGO Yeni Araç İlanı Verme Form Ekranı (CreateListingView)
///
/// Bireysel araç sahiplerinin kendi araçlarını kiralama vitrinine
/// eklemek üzere detaylı bilgileri girdiği zengin form sayfasıdır.
class CreateListingView extends StatelessWidget { // CreateListingView sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form girdi alanlarını ve doğrulama mantığını yöneten kontrolcü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Yeni araç başarıyla üretilip kaydedildiğinde çağrılan eylem (callback)
  final void Function(CarModel newCar)? onListingCreated;

  // Sabit kurucu metot
  const CreateListingView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onListingCreated, // onListingCreated alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 40 satır kuralına uygun ana sayfa düzeni
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Üst başlık çubuğu
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        // Başlık metni
        title: const Text('Yeni Araç İlanı Ver'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      // Klavye açıldığında taşmayı önleyen tek yönlü dikey kaydırma alanı
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        // Ekran kenarlarından 16 piksel dolgu boşluğu
        padding: const EdgeInsets.all(16),
        // Form bileşenlerini dikeyde alt alta dizen Column
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          // Elemanları sola hizalıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            // 1. Sabit 140px Fotoğraf Yükleme Çerçevesi (RenderFlex overflow önler)
            const ImageUploadPlaceholder(),
            // 20 piksel dikey boşluk
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 2. Araç Temel Bilgileri Girdi Alanları (Marka, Model, Yıl, Plaka)
            _CarInfoInputs(controller: controller),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 3. Şanzıman ve Elektrikli Araç Seçim Satırı
            _TransmissionAndPowertrainRow(controller: controller), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 4. Benzin / Şarj Seviyesi Ayar Kaydırıcısı (Slider)
            FuelInputSlider(
              // Yakıt yüzdesi bildiricisi
              fuelPercentNotifier: controller.fuelPercentNotifier,
              // Elektrikli araç durumu bildiricisi
              isElectricNotifier: controller.isElectricNotifier,
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 5. Kiralama Periyot Fiyatları (Günlük, Haftalık, Aylık)
            _PriceInputs(controller: controller),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 6. Müsaitlik Tarih Aralığı Takvim Seçicisi
            DateRangePickerWidget(
              dateRangeNotifier: controller.dateRangeNotifier,
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 7. Lokasyon ve Ek Açıklama Girdi Alanları
            _LocationAndDescriptionInputs(controller: controller),
            // 20 piksel dikey boşluk
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 8. Hata Mesajı Bildirimi Banner'ı (Doğrulama hatası varsa açılır)
            _ErrorMessageBanner(controller: controller),
            // 12 piksel dikey boşluk
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 9. Kaydet ve Vitrinde Yayınla Butonu
            _SubmitButton(
              // Kontrolcü referansı
              controller: controller,
              // İlan kaydedildiğinde tetiklenen callback
              onListingCreated: onListingCreated,
            ),
            // Sayfa altı güvenli boşluğu: 40 piksel
            const SizedBox(height: 40), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: MARKA, MODEL, YIL VE PLAKA GİRDİLERİ
// -----------------------------------------------------------------------------

// Araç kimlik bilgilerini kullanıcıdan alan metin kutuları grubu
class _CarInfoInputs extends StatelessWidget { // _CarInfoInputs sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _CarInfoInputs({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      children: [
        // 1. Satır: Marka ve Model Girişi
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            // Marka giriş kutusu (kalan genişliği eşit böler)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                // Kontrolcü bağlanıyor
                controller: controller.brandController,
                // Görsel süsleme ve etiket
                decoration: const InputDecoration(
                  labelText: 'Marka (Örn: Tesla)',
                ),
              ),
            ),
            // İki kutu arasına 12 piksel boşluk
            const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Model giriş kutusu
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                // Kontrolcü bağlanıyor
                controller: controller.modelController,
                // Görsel süsleme ve etiket
                decoration: const InputDecoration(
                  labelText: 'Model (Örn: Model Y)',
                ),
              ),
            ),
          ],
        ),
        // Satırlar arasına 12 piksel dikey boşluk
        const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // 2. Satır: Üretim Yılı ve Plaka Girişi
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            // Üretim yılı kutusu (sayısal klavye)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: controller.yearController,
                // Sadece rakam klavyesi açılır
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Üretim Yılı',
                ),
              ),
            ),
            // İki kutu arasına 12 piksel boşluk
            const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Plaka kutusu (otomatik büyük harf)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: controller.plateController,
                // Klavyede yazılan harfleri otomatik büyük harf yapar
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Plaka (34 TGO 01)',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: ŞANZIMAN VE ELEKTRİKLİ ARAÇ TERCİHİ
// -----------------------------------------------------------------------------

// Vites türü ve elektrikli motor seçimi sağlayan arayüz satırı
class _TransmissionAndPowertrainRow extends StatelessWidget { // _TransmissionAndPowertrainRow sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _TransmissionAndPowertrainRow({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Elemanları yan yana dizen Row
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        // Sol Taraf: Otomatik / Manuel Şanzıman Seçici (SegmentedButton)
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: ValueListenableBuilder<String>(
            // Şanzıman bildiricisini dinliyoruz
            valueListenable: controller.transmissionNotifier,
            // Şanzıman değiştikçe çalışan builder
            builder: (context, transmission, _) {
              return SegmentedButton<String>(
                // Buton parçaları
                segments: const [
                  ButtonSegment(value: 'Otomatik', label: Text('Otomatik')),
                  ButtonSegment(value: 'Manuel', label: Text('Manuel')),
                ],
                // Aktif seçili küme
                selected: {transmission},
                // Seçim değiştiğinde bildirici değerini güncelliyoruz
                onSelectionChanged: (set) {
                  controller.transmissionNotifier.value = set.first;
                },
              );
            },
          ),
        ),
        // Araya 12 piksel boşluk
        const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // Sağ Taraf: 'Elektrikli' Araç Filtre Çipi
        ValueListenableBuilder<bool>(
          // Elektrikli durumunu dinliyoruz
          valueListenable: controller.isElectricNotifier,
          // Değer değiştikçe çipi güncelleyen builder
          builder: (context, isElectric, _) {
            return FilterChip(
              // Şimşek ikonu
              avatar: Icon(
                Icons.bolt_rounded,
                size: 16,
                color: isElectric ? Colors.white : colors.primary,
              ),
              // Çip etiketi
              label: const Text('Elektrikli'),
              // Seçili durumu
              selected: isElectric,
              // Tıklandığında boolean değeri güncelliyoruz
              onSelected: (val) {
                controller.isElectricNotifier.value = val;
              },
            );
          },
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 3: GÜNLÜK, HAFTALIK VE AYLIK FİYAT GİRDİLERİ
// -----------------------------------------------------------------------------

// Kiralama periyot bedellerini kullanıcıdan alan 3'lü kutu grubu
class _PriceInputs extends StatelessWidget { // _PriceInputs sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _PriceInputs({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        // Fiyatlandırma bölüm başlığı
        const Text(
          'Kiralama Fiyatları (TL)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        // 8 piksel dikey boşluk
        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // 3 Fiyat kutusunu yan yana dizen satır
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            // 1. Kutu: Günlük Fiyat (Zorunlu)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: controller.dailyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Günlük (₺) *'),
              ),
            ),
            // 8 piksel boşluk
            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 2. Kutu: Haftalık Fiyat (Opsiyonel / Otomatik hesaplanabilir)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: controller.weeklyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Haftalık (₺)'),
              ),
            ),
            // 8 piksel boşluk
            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 3. Kutu: Aylık Fiyat (Opsiyonel / Otomatik hesaplanabilir)
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: controller.monthlyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Aylık (₺)'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 4: LOKASYON VE AÇIKLAMA GİRDİSİ
// -----------------------------------------------------------------------------

// Teslim alınacak adres ve araç açıklamasını alan form alanı
class _LocationAndDescriptionInputs extends StatelessWidget { // _LocationAndDescriptionInputs sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _LocationAndDescriptionInputs({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      children: [
        // Lokasyon giriş kutusu
        TextField( // Kullanıcıdan metin girdisi almak için form alanı
          controller: controller.locationController,
          decoration: const InputDecoration(
            labelText: 'Teslim Lokasyonu (İlçe, Şehir)',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        // 12 piksel dikey boşluk
        const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // Açıklama ve kiralama şartları metin kutusu (2 satır)
        TextField( // Kullanıcıdan metin girdisi almak için form alanı
          controller: controller.descriptionController,
          maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
          decoration: const InputDecoration(
            labelText: 'Araç Açıklaması ve Kiralama Şartları',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 5: HATA BANNER'I
// -----------------------------------------------------------------------------

// Form doğrulaması başarısız olduğunda kırmızı hata kutusunu ekrana basan bileşen
class _ErrorMessageBanner extends StatelessWidget { // _ErrorMessageBanner sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _ErrorMessageBanner({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Hata mesajı bildiricisini dinliyoruz
    return ValueListenableBuilder<String?>(
      valueListenable: controller.errorMessageNotifier,
      builder: (context, error, _) {
        // Hata yoksa ekranda yer kaplamayan SizedBox.shrink() döndürüyoruz
        if (error == null) return const SizedBox.shrink();

        // Hata varsa kırmızı çerçeveli uyarı kutusu çiziyoruz
        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: context.colors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(color: context.colors.error),
          ),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              // Hata ikonu
              Icon(
                Icons.error_outline_rounded,
                color: context.colors.error,
                size: 20,
              ),
              // 8 piksel boşluk
              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Hata metni
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Text(
                  error,
                  style: TextStyle(
                    color: context.colors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 6: GÖNDER BUTONU
// -----------------------------------------------------------------------------

// Formu doğrulayıp yeni aracı vitrine kaydeden buton bileşeni
class _SubmitButton extends StatelessWidget { // _SubmitButton sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Form kontrolcüsü
  final CreateListingController controller; // CreateListingController türünden controller adlı değişkenimiz
  // Başarılı kayıt geri çağırma eylemi
  final void Function(CarModel newCar)? onListingCreated;

  // Kurucu fonksiyon
  const _SubmitButton({ // Genel, sabit sınıf constructor'ı
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onListingCreated, // onListingCreated parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // İkonlu ve dolu buton (FilledButton)
    return FilledButton.icon(
      // Butona dokunulduğunda formu doğruluyoruz
      onPressed: () {
        // Kontrolcü üzerinden formu doğrulayıp yeni aracı alıyoruz
        final newCar = controller.submitListing();

        // Eğer veriler geçerliyse ve yeni araç üretildiyse
        if (newCar != null) {
          // SnackBar ile kullanıcıya başarı mesajı gösteriyoruz
          context.showTakeGoSnackBar(
            'Harika! "${newCar.fullName}" ilanı TakeGO vitrininde yayınlandı.',
          );
          // Callback ile yeni aracı üst sekmeye iletiyoruz
          onListingCreated?.call(newCar);
        }
      },
      // Onay ikonu
      icon: const Icon(Icons.check_circle_outline_rounded),
      // Buton metni
      label: const Text('İlanı Doğrula ve Yayınla'),
    );
  }
}
