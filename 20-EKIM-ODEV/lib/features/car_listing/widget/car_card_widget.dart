// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Uygulama renk sabitleri ve 16:9 görsel ölçülerini içe aktarıyoruz
import '../../../core/constants/app_colors.dart';
// BuildContext üzerinden tema renklerine pratik erişim uzantısını içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Gösterilecek aracın veri modelini içe aktarıyoruz
import '../models/car_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Kiralama periyot türü enumını (günlük, haftalık, aylık) içe aktarıyoruz
import '../models/rental_period_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// TakeGO Standart İlan Kartı Bileşeni (CarCardWidget)
///
/// Kırmızı Çizgi Kuralı: İlan kartlarındaki görsel alanı kesinlikle sabit
/// 16:9 oranında (veya 180px) tutulur; dinamik taşma ve zıplama engellenir.
class CarCardWidget extends StatelessWidget { // CarCardWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  /// Gösterilecek araç modeli verisi
  final CarModel car; // CarModel türünden car adlı değişkenimiz

  /// Aktif seçili kiralama periyodu (Günlük/Haftalık/Aylık fiyatlama için)
  final RentalPeriodType selectedPeriod; // RentalPeriodType türünden selectedPeriod adlı değişkenimiz

  /// Karta tıklandığında detay sayfasına yönlendiren opsiyonel eylem
  final VoidCallback? onTap; // VoidCallback? türünden onTap adlı değişkenimiz

  // Sabit kurucu metot
  const CarCardWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.car, // car parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.selectedPeriod, // selectedPeriod parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onTap, // onTap alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 40 satır kuralına uygun ana build yapısı: Dış kart kutusu
    return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
      // Kartlar arasına yatayda 16, dikeyde 8 piksel dış kenar boşluğu
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Tıklama efektini (ripple) kart sınırlarına kırparak veren InkWell
      child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
        // Karta tıklandığında dışarıdan gelen onTap fonksiyonunu çalıştır
        onTap: onTap,
        // Kart içeriğini dikeyde dizen Column bileşeni
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          // Elemanları sola yaslıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            // 1. Sabit 16:9 Görsel ve Üst Rozetler Katmanı
            _FixedCardBanner(car: car),

            // 2. Fiyat, Başlık ve Özellikler Detay Katmanı
            _CardDetails(
              car: car,
              selectedPeriod: selectedPeriod,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: SABİT 16:9 GÖRSEL ALANI VE ROZETLER
// -----------------------------------------------------------------------------

/// Taşmaları önleyen sabit 16:9 görsel alanı ve üzerindeki rozetler
class _FixedCardBanner extends StatelessWidget { // _FixedCardBanner sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Gösterilecek araç nesnesi
  final CarModel car; // CarModel türünden car adlı değişkenimiz

  // Kurucu fonksiyon
  const _FixedCardBanner({required this.car}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renk şemasını alıyoruz
    final colors = context.colors;

    // Görsel kutusunu kesin 16:9 en-boy oranına kilitleyen AspectRatio widget'ı
    return AspectRatio(
      // Sabit 16.0 / 9.0 oranı (RenderFlex taşmasını tamamen engeller)
      aspectRatio: AppColors.standardAspectRatio,
      // Zemin ve rozetleri üst üste bindiren Stack bileşeni
      child: Stack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
        // Çocuk widget'ların tüm kutuyu kaplamasını sağlıyoruz
        fit: StackFit.expand,
        children: [
          // Zemin Silüet Dolgusu (Fotoğraf yüklenemese de kutu boyutu asla bozulmaz)
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            // Temaya uygun hafif arka plan dolgusu
            color: colors.surfaceContainerHighest,
            // Araç ikonunu ortaya yerleştiriyoruz
            child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
              // Elektrikli ise şimşekli araç, değilse standart binek araç ikonu
              child: Icon(
                car.isElectric
                    ? Icons.electric_car_rounded
                    : Icons.directions_car_rounded,
                // İkon boyutu
                size: 54,
                // Yarı saydam gri ikon rengi
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Sol Üst Rozet: Yakıt / Batarya Durum Göstergesi
          Positioned( // Stack içindeki widget'ın konumunu (sol, sağ, üst, alt) piksel olarak ayarlamak için
            top: 12,
            left: 12,
            child: _FuelStatusBadge(
              // Depo doluluk yüzdesi
              fuelPercent: car.fuelPercent,
              // Elektrikli araç bayrağı
              isElectric: car.isElectric,
            ),
          ),

          // Sağ Üst Rozet: Şanzıman ve Kullanıcıya Olan Mesafe Bilgisi
          Positioned( // Stack içindeki widget'ın konumunu (sol, sağ, üst, alt) piksel olarak ayarlamak için
            top: 12,
            right: 12,
            child: _SpecBadge(
              // Vites ve mesafe metnini birleştirip yazdırıyoruz
              label: '${car.transmission} • ${car.distanceKm} km',
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: BAŞLIK, FİYAT VE LOKASYON ALANI
// -----------------------------------------------------------------------------

/// Araç adı, seçili periyot tutarı ve lokasyon bilgilerini gösteren panel
class _CardDetails extends StatelessWidget { // _CardDetails sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Araç verisi
  final CarModel car; // CarModel türünden car adlı değişkenimiz
  // Seçili periyot (Günlük/Haftalık/Aylık)
  final RentalPeriodType selectedPeriod; // RentalPeriodType türünden selectedPeriod adlı değişkenimiz

  // Kurucu fonksiyon
  const _CardDetails({ // Genel, sabit sınıf constructor'ı
    required this.car, // car parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.selectedPeriod, // selectedPeriod parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Seçili periyoda ait birim fiyatı model üzerinden hesaplıyoruz
    final activePrice = car.priceForPeriod(selectedPeriod);

    // Kart gövdesine 14 piksel iç boşluk uyguluyoruz
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.all(14),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          // Marka/Model Başlığı ve Dinamik Periyot Fiyatı Satırı
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            // Başlık sola, fiyat sağa hizalanır
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              // Araç adı uzunsa taşmasın diye Expanded içine alıyoruz
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Text(
                  // Marka ve model birleşik tam adı
                  car.fullName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                  // Tek satıra kilitliyoruz
                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                  // Taşarsa üç nokta koyuyoruz (...)
                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                ),
              ),
              // Sağdaki fiyat etiketi (Örn: 2400 ₺ / Gün)
              Text(
                '${activePrice.toStringAsFixed(0)} ${selectedPeriod.unitSuffix}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          // Başlık ile alt satır arasına 8 piksel boşluk
          const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

          // Müsaitlik Tarih Aralığı ve Teslim Lokasyonu Satırı
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              // Takvim ikonu
              Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              // İkon ile metin arası 4 piksel boşluk
              const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Müsaitlik tarih aralığı metni
              Text(
                '${car.availableFrom.day}.${car.availableFrom.month} - ${car.availableTo.day}.${car.availableTo.month}',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              // Araya esnek boşluk koyarak lokasyonu en sağa itiyoruz
              const Spacer(),
              // Lokasyon pin ikonu
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              // İkon ile metin arası 2 piksel boşluk
              const SizedBox(width: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Lokasyon metni (Örn: Kadıköy, İstanbul)
              Text(
                car.location,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// YARDIMCI ROZET BİLEŞENLERİ (Badges)
// -----------------------------------------------------------------------------

/// Benzin veya elektrik seviyesini renklendirerek gösteren rozet
class _FuelStatusBadge extends StatelessWidget { // _FuelStatusBadge sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Depo yüzdesi (%0 - %100)
  final int fuelPercent; // int türünden fuelPercent adlı değişkenimiz
  // Elektrikli araç olup olmadığı
  final bool isElectric; // bool türünden isElectric adlı değişkenimiz

  // Kurucu fonksiyon
  const _FuelStatusBadge({ // Genel, sabit sınıf constructor'ı
    required this.fuelPercent, // fuelPercent parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isElectric, // isElectric parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Depo %50 veya üzerindeyse iyi (yeşil), altındaysa kırmızı/uyarı
    final isGood = fuelPercent >= 50;
    // Durum rengini belirliyoruz
    final badgeColor = isGood ? colors.secondary : colors.error;

    // Rozet kapsayıcısı
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      // Yatayda 10, dikeyde 5 piksel iç dolgu
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // Arka plan ve kenarlık tasarımı
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        // Yarı saydam yüzey rengi
        color: colors.surface.withValues(alpha: 0.9),
        // Yuvarlatılmış hap (pill) şekli
        borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        // İnce renkli durum çerçevesi
        border: Border.all(color: badgeColor, width: 1.2),
      ),
      // İkon ve metni yan yana dizen satır
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        mainAxisSize: MainAxisSize.min,
        children: [
          // Elektrikli ise şimşek, benzinli ise pompa ikonu
          Icon(
            isElectric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
            size: 14,
            color: badgeColor,
          ),
          // İkon ile metin arası 4 piksel boşluk
          const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Yüzde metni (Örn: %88 Şarj veya %65 Depo)
          Text(
            '%$fuelPercent ${isElectric ? 'Şarj' : 'Depo'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vites ve mesafe gibi özellikleri gösteren yarı saydam hap rozet
class _SpecBadge extends StatelessWidget { // _SpecBadge sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Gösterilecek metin
  final String label; // String türünden label adlı değişkenimiz

  // Kurucu fonksiyon
  const _SpecBadge({required this.label}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Yarı saydam arka planlı hap kutusu
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: colors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
      // Etiket metni
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
