import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

class LayoutStylingScreen extends StatefulWidget { // LayoutStylingScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const LayoutStylingScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  bool isBalanceVisible = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (isBalanceVisible)
  String lastAction = 'Hazır - Butonlara Tıklayabilirsiniz.'; // String türünden lastAction değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
      padding: const EdgeInsets.only(bottom: 32),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          // Profil Online Rozeti.
          buildProfileHeader(),
          // Cüzdan Kartı.
          buildWalletCard(), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
          // Aksiyon Butonları.
          buildQuickActions(),
          // İstatistiklik Bölümü.
          buildFlexStatistics(),
          // Notification Bildirim Banner.
          buildNotificationBanner(),
          // Canlı Durum Bildirimi.
          Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Son İşlem: $lastAction',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWalletCard() { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: const Color(0xFF16366F),
        borderRadius: BorderRadius.circular(24), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              const Text('Toplam Bakiye',
                  style: TextStyle(color: Colors.white70)),
              IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                tooltip:
                    isBalanceVisible ? 'Bakiyeyi gizle' : 'Bakiyeyi göster',
                color: Colors.white,
                icon: Icon(isBalanceVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () {
                  setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                    isBalanceVisible = !isBalanceVisible;
                    lastAction = isBalanceVisible
                        ? 'Bakiye gösterildi.'
                        : 'Bakiye gizlendi.';
                  });
                },
              ),
            ],
          ),
          Text(
            isBalanceVisible ? '₺24.580,00' : '••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          const Text('Örnek cüzdan verisi',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget buildQuickActions() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton.icon(
            onPressed: () {
              setState(() => lastAction = 'Para gönder seçildi.'); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            },
            icon: const Icon(Icons.send_outlined),
            label: const Text('Gönder'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => lastAction = 'Para al seçildi.'); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            },
            icon: const Icon(Icons.call_received),
            label: const Text('Al'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => lastAction = 'Para yatır seçildi.'); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            },
            icon: const Icon(Icons.add),
            label: const Text('Yatır'),
          ),
        ],
      ),
    );
  }

  Widget buildFlexStatistics() {
    return const Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: EdgeInsets.all(20),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: EdgeInsets.all(16),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.green),
                    SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text('Örnek Gelir'),
                    Text('₺8.500,00',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: EdgeInsets.all(16),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.red),
                    SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text('Örnek Gider'),
                    Text('₺3.200,00',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationBanner() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        child: ListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          ),
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Cüzdanını takip et'), // Sayfa başlığını ekrana yazdırıyoruz
          subtitle:
              const Text('Gelir ve giderlerini düzenli olarak kontrol et.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() => lastAction = 'Bildirim görüntülendi.'); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
          },
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          Stack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
            clipBehavior: Clip.none,
            children: [
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                width: 56,
                height: 56,
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  shape: BoxShape.circle,
                  color: const Color(0xFFEDE9FE),
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF6366F1),
                  size: 36,
                ),
              ),
              Positioned( // Stack içindeki widget'ın konumunu (sol, sağ, üst, alt) piksel olarak ayarlamak için
                right: 0,
                bottom: 0,
                child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8FAFC),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          const Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                Text(
                  'Hoş Geldin, Mustafa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Text(
                  'Cüzdanınıza genel bakış',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
