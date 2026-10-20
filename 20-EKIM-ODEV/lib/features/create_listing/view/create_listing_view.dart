// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart';
// Context extension ile tema renklerine ve SnackBar yardımcısına erişim sağlıyoruz
import '../../../core/extensions/context_extensions.dart';
// Üretilecek araç veri modelini içe aktarıyoruz
import '../../car_listing/models/car_model.dart';
// İlan verme formu iş mantığı ve doğrulama denetleyicisini içe aktarıyoruz
import '../controller/create_listing_controller.dart';
// Takvimden müsaitlik tarih aralığı seçici bileşenini içe aktarıyoruz
import '../widget/date_range_picker_widget.dart';
// Yakıt / batarya kaydırıcı bileşenini içe aktarıyoruz
import '../widget/fuel_input_slider.dart';
// 140px sabit boyutlu resim seçici alanını içe aktarıyoruz
import '../widget/image_upload_placeholder.dart';

/// TakeGO Yeni Araç İlanı Verme Form Ekranı (CreateListingView)
///
/// Bireysel araç sahiplerinin kendi araçlarını kiralama vitrinine
/// eklemek üzere detaylı bilgileri girdiği zengin form sayfasıdır.
class CreateListingView extends StatelessWidget {
  // Form girdi alanlarını ve doğrulama mantığını yöneten kontrolcü
  final CreateListingController controller;

  // Yeni araç başarıyla üretilip kaydedildiğinde çağrılan eylem (callback)
  final void Function(CarModel newCar)? onListingCreated;

  // Sabit kurucu metot
  const CreateListingView({
    super.key,
    required this.controller,
    this.onListingCreated,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun ana sayfa düzeni
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Yeni Araç İlanı Ver'),
      ),
      // Klavye açıldığında taşmayı önleyen tek yönlü dikey kaydırma alanı
      body: SingleChildScrollView(
        // Ekran kenarlarından 16 piksel dolgu boşluğu
        padding: const EdgeInsets.all(16),
        // Form bileşenlerini dikeyde alt alta dizen Column
        child: Column(
          // Elemanları sola hizalıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sabit 140px Fotoğraf Yükleme Çerçevesi (RenderFlex overflow önler)
            const ImageUploadPlaceholder(),
            // 20 piksel dikey boşluk
            const SizedBox(height: 20),

            // 2. Araç Temel Bilgileri Girdi Alanları (Marka, Model, Yıl, Plaka)
            _CarInfoInputs(controller: controller),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // 3. Şanzıman ve Elektrikli Araç Seçim Satırı
            _TransmissionAndPowertrainRow(controller: controller),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // 4. Benzin / Şarj Seviyesi Ayar Kaydırıcısı (Slider)
            FuelInputSlider(
              // Yakıt yüzdesi bildiricisi
              fuelPercentNotifier: controller.fuelPercentNotifier,
              // Elektrikli araç durumu bildiricisi
              isElectricNotifier: controller.isElectricNotifier,
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // 5. Kiralama Periyot Fiyatları (Günlük, Haftalık, Aylık)
            _PriceInputs(controller: controller),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // 6. Müsaitlik Tarih Aralığı Takvim Seçicisi
            DateRangePickerWidget(
              dateRangeNotifier: controller.dateRangeNotifier,
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // 7. Lokasyon ve Ek Açıklama Girdi Alanları
            _LocationAndDescriptionInputs(controller: controller),
            // 20 piksel dikey boşluk
            const SizedBox(height: 20),

            // 8. Hata Mesajı Bildirimi Banner'ı (Doğrulama hatası varsa açılır)
            _ErrorMessageBanner(controller: controller),
            // 12 piksel dikey boşluk
            const SizedBox(height: 12),

            // 9. Kaydet ve Vitrinde Yayınla Butonu
            _SubmitButton(
              // Kontrolcü referansı
              controller: controller,
              // İlan kaydedildiğinde tetiklenen callback
              onListingCreated: onListingCreated,
            ),
            // Sayfa altı güvenli boşluğu: 40 piksel
            const SizedBox(height: 40),
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
class _CarInfoInputs extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;

  // Kurucu fonksiyon
  const _CarInfoInputs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Satır: Marka ve Model Girişi
        Row(
          children: [
            // Marka giriş kutusu (kalan genişliği eşit böler)
            Expanded(
              child: TextField(
                // Kontrolcü bağlanıyor
                controller: controller.brandController,
                // Görsel süsleme ve etiket
                decoration: const InputDecoration(
                  labelText: 'Marka (Örn: Tesla)',
                ),
              ),
            ),
            // İki kutu arasına 12 piksel boşluk
            const SizedBox(width: 12),
            // Model giriş kutusu
            Expanded(
              child: TextField(
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
        const SizedBox(height: 12),

        // 2. Satır: Üretim Yılı ve Plaka Girişi
        Row(
          children: [
            // Üretim yılı kutusu (sayısal klavye)
            Expanded(
              child: TextField(
                controller: controller.yearController,
                // Sadece rakam klavyesi açılır
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Üretim Yılı',
                ),
              ),
            ),
            // İki kutu arasına 12 piksel boşluk
            const SizedBox(width: 12),
            // Plaka kutusu (otomatik büyük harf)
            Expanded(
              child: TextField(
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
class _TransmissionAndPowertrainRow extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;

  // Kurucu fonksiyon
  const _TransmissionAndPowertrainRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Elemanları yan yana dizen Row
    return Row(
      children: [
        // Sol Taraf: Otomatik / Manuel Şanzıman Seçici (SegmentedButton)
        Expanded(
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
        const SizedBox(width: 12),

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
class _PriceInputs extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;

  // Kurucu fonksiyon
  const _PriceInputs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fiyatlandırma bölüm başlığı
        const Text(
          'Kiralama Fiyatları (TL)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        // 8 piksel dikey boşluk
        const SizedBox(height: 8),

        // 3 Fiyat kutusunu yan yana dizen satır
        Row(
          children: [
            // 1. Kutu: Günlük Fiyat (Zorunlu)
            Expanded(
              child: TextField(
                controller: controller.dailyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Günlük (₺) *'),
              ),
            ),
            // 8 piksel boşluk
            const SizedBox(width: 8),

            // 2. Kutu: Haftalık Fiyat (Opsiyonel / Otomatik hesaplanabilir)
            Expanded(
              child: TextField(
                controller: controller.weeklyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Haftalık (₺)'),
              ),
            ),
            // 8 piksel boşluk
            const SizedBox(width: 8),

            // 3. Kutu: Aylık Fiyat (Opsiyonel / Otomatik hesaplanabilir)
            Expanded(
              child: TextField(
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
class _LocationAndDescriptionInputs extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;

  // Kurucu fonksiyon
  const _LocationAndDescriptionInputs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lokasyon giriş kutusu
        TextField(
          controller: controller.locationController,
          decoration: const InputDecoration(
            labelText: 'Teslim Lokasyonu (İlçe, Şehir)',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        // 12 piksel dikey boşluk
        const SizedBox(height: 12),

        // Açıklama ve kiralama şartları metin kutusu (2 satır)
        TextField(
          controller: controller.descriptionController,
          maxLines: 2,
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
class _ErrorMessageBanner extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;

  // Kurucu fonksiyon
  const _ErrorMessageBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Hata mesajı bildiricisini dinliyoruz
    return ValueListenableBuilder<String?>(
      valueListenable: controller.errorMessageNotifier,
      builder: (context, error, _) {
        // Hata yoksa ekranda yer kaplamayan SizedBox.shrink() döndürüyoruz
        if (error == null) return const SizedBox.shrink();

        // Hata varsa kırmızı çerçeveli uyarı kutusu çiziyoruz
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.colors.error),
          ),
          child: Row(
            children: [
              // Hata ikonu
              Icon(
                Icons.error_outline_rounded,
                color: context.colors.error,
                size: 20,
              ),
              // 8 piksel boşluk
              const SizedBox(width: 8),
              // Hata metni
              Expanded(
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
class _SubmitButton extends StatelessWidget {
  // Form kontrolcüsü
  final CreateListingController controller;
  // Başarılı kayıt geri çağırma eylemi
  final void Function(CarModel newCar)? onListingCreated;

  // Kurucu fonksiyon
  const _SubmitButton({
    required this.controller,
    required this.onListingCreated,
  });

  @override
  Widget build(BuildContext context) {
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
