// Flutter'ın temel UI ve materyal tasarım bileşenlerini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Tema renklerine context.colors üzerinden hızlı erişim sağlayan extension'ı içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// TakeGO Benzin / Batarya Grafik Göstergesi (FuelGaugeWidget)
///
/// Aracın teslim anındaki yakıt deposu veya batarya şarj seviyesini
/// dinamik renkli ilerleme çubuğu ve tahmini menzil bilgisiyle gösterir.
class FuelGaugeWidget extends StatelessWidget { // FuelGaugeWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Yakıt veya batarya doluluk yüzdesi (%0 - %100 arası tam sayı)
  final int fuelPercent; // int türünden fuelPercent adlı değişkenimiz

  /// Aracın %100 elektrikli mi yoksa benzinli/dizel mi olduğunu belirten bayrak
  final bool isElectric; // bool türünden isElectric adlı değişkenimiz

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Yakıt yüzdesini ve motor tipini zorunlu parametre olarak alır
  const FuelGaugeWidget({ // Genel, sabit sınıf constructor'ı
    // Widget ağacında performans optimizasyonu sağlayan super.key
    super.key,
    // Yakıt/batarya yüzdesi zorunlu parametresi
    required this.fuelPercent, // fuelPercent parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Elektrikli araç durumu zorunlu parametresi
    required this.isElectric, // isElectric parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 1. Değişken: Aktif tema renk paletini context üzerinden alıyoruz
    final colors = context.colors;

    // 2. Değişken: Yakıt seviyesinin güvenli (%50 ve üzeri) olup olmadığını kontrol eden boolean
    final isGood = fuelPercent >= 50;

    // 3. Değişken: Seviye yeterliyse ikincil (yeşil/turkuaz), düşükse uyarı (hata) rengini seçiyoruz
    final statusColor = isGood ? colors.secondary : colors.error;

    // 4. Değişken: Kalan yüzdeye göre tahmini menzili kilometre cinsinden hesaplıyoruz
    final estimatedKm = ((fuelPercent / 100.0) * (isElectric ? 500 : 750)).round();

    // Gösterge kutusunun dış kapsayıcı Container bileşeni
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      // Kart içi 16px iç boşluk
      padding: const EdgeInsets.all(16),
      // Kartın arka plan rengi, yuvarlak köşeleri ve kenarlık çizgisi
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        // Temanın yüzey rengi
        color: colors.surfaceContainer,
        // 16px yuvarlatılmış modern köşeler
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        // Kartı çevreleyen ince kenarlık çizgisi
        border: Border.all(color: colors.outlineVariant),
      ),
      // Gösterge başlığını, ilerleme çubuğunu ve menzil bilgisini dikeyde sıralayan Column
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        // İçerikleri sola dayalı hizalıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        // Dikey sütun çocukları
        children: [
          // 1. Satır: İkon, Başlık ve Yüzde Değerini gösteren Row
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            // İki ucu yatayda birbirinden en uzak köşelere yerleştiriyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              // Sol Kısım: İkon ve İsim
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                children: [
                  // Motor tipine göre şimşek (elektrik) veya benzin pompası ikonu
                  Icon(
                    isElectric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
                    color: statusColor,
                    size: 20,
                  ),
                  // İkon ile yazı arasına 6px boşluk
                  const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  // Gösterge başlık metni
                  Text(
                    isElectric ? 'Batarya Durumu' : 'Yakıt Deposu',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // Sağ Kısım: Kalın puntoyla yüzde değeri (Örn: %75)
              Text(
                '%$fuelPercent',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: statusColor,
                ),
              ),
            ],
          ),
          // Başlık satırı ile ilerleme çubuğu arasına 12px dikey boşluk
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

          // 2. Satır: Yuvarlatılmış köşeli İlerleme Çubuğu (Progress Indicator)
          ClipRRect(
            // İlerleme çubuğunun köşelerini 8px yuvarlatıyoruz
            borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            // Çizgisel ilerleme göstergesi
            child: LinearProgressIndicator(
              // Doluluk oranını 0.0 ile 1.0 aralığında veriyoruz
              value: fuelPercent / 100.0,
              // Çubuğun yüksekliğini 10px olarak belirliyoruz
              minHeight: 10,
              // Çubuğun boş arka plan zemin rengi
              backgroundColor: colors.surfaceContainerHighest,
              // Çubuğun dolan kısmının durum rengi (yeşil veya kırmızı)
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          // İlerleme çubuğu ile açıklama metni arasına 10px dikey boşluk
          const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

          // 3. Satır: Tahmini Menzil ve Teslimat Notu Metni
          Text(
            'Tahmini menzil: ~$estimatedKm km • Araç aynı seviyede teslim alınır/edilir.',
            style: TextStyle(
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
