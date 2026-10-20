// Flutter materyal tasarım kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Tema renklerine ve ekran yardımcılarına hızlı erişim sağlayan extension'ı içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Dijital anahtar ve asistan durumlarını yöneten kontrolcüyü içe aktarıyoruz
import '../controller/smart_key_controller.dart';
// Mesaj verilerini tip güvenli tutan modeli içe aktarıyoruz
import '../models/assistant_message_model.dart';

/// TakeGO Canlı Yol Asistanı Sohbet Penceresi (QuickAssistantDialog)
///
/// Sürüş esnasında kullanıcının aklına takılan sorulara hazır akıllı
/// yanıtlar sunan ve interaktif balon sohbeti içeren modaldır.
class QuickAssistantDialog extends StatefulWidget {
  // Asistan mantığını ve mesaj listesini yöneten ana denetleyici nesnesi
  final SmartKeyController controller;

  // Kurucu metot: Dışarıdan zorunlu olarak SmartKeyController alır
  const QuickAssistantDialog({
    super.key,
    required this.controller,
  });

  // State nesnesini oluşturan override metodu
  @override
  State<QuickAssistantDialog> createState() => _QuickAssistantDialogState();
}

// QuickAssistantDialog için yerel UI durumunu (input text kontrolü) yöneten State sınıfı
class _QuickAssistantDialogState extends State<QuickAssistantDialog> {
  // Kullanıcının mesaj yazdığı TextField bileşenini kontrol eden TextEditingController
  final TextEditingController _textController = TextEditingController();

  // Widget ağaçtan kaldırıldığında çağrılan yaşam döngüsü metodu
  @override
  void dispose() {
    // TextEditingController bellekte sızıntı yapmasın diye dispose ediyoruz
    _textController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  }

  // Arayüzü inşa eden ana build metodu
  @override
  Widget build(BuildContext context) {
    // Ekranda açılan modal pencere widget'ı
    return Dialog(
      // Köşeleri 20 piksel yuvarlatılmış kart kenarlığı
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Genişlik ve yükseklik sınırlarını belirleyen kutu
      child: ConstrainedBox(
        // Maksimum yükseklik 520px, maksimum genişlik 420px olarak sınırlandırılıyor
        constraints: const BoxConstraints(
          maxHeight: 520,
          maxWidth: 420,
        ),
        // İçerik etrafına 16 piksel boşluk ekleyen Padding
        child: Padding(
          padding: const EdgeInsets.all(16),
          // İçerikleri dikey olarak alt alta sıralayan Column bileşeni
          child: Column(
            children: [
              // 1. Asistan Başlık Çubuğu: İkon, başlık ve kapatma butonunu barındırır
              _AssistantHeader(
                // Kapat butonuna basıldığında modalı ekrandan kaldıran callback
                onClose: () {
                  // Navigator pop ile mevcut dialog penceresini kapatıyoruz
                  Navigator.pop(context);
                },
              ),
              // Başlık ile içerik arasına ince ayırıcı çizgi
              const Divider(height: 20),

              // 2. Hızlı SSS (Sıkça Sorulan Sorular) çipleri listesi
              _FaqChips(
                // Kontrolcü referansını çip bileşenine aktarıyoruz
                controller: widget.controller,
              ),
              // Çipler ile mesaj listesi arasına 10 piksel boşluk
              const SizedBox(height: 10),

              // 3. Canlı Mesajlaşma Listesi: Kalan dikey alanı tamamen doldurur
              Expanded(
                child: _MessageList(
                  // Mesaj listesini dinlemesi için kontrolcüyü gönderiyoruz
                  controller: widget.controller,
                ),
              ),
              // Mesaj listesi ile girdi alanı arasına 10 piksel boşluk
              const SizedBox(height: 10),

              // 4. Soru Yazma Girdi Alanı: TextField ve Gönder butonunu içerir
              _MessageInputField(
                // Metin denetleyicisini parametre olarak bağlıyoruz
                controller: _textController,
                // Kullanıcı gönder butonuna veya Enter'a bastığında çalışan fonksiyon
                onSend: (text) {
                  // Kullanıcının yazdığı metin boşluklardan arındırıldığında boş değilse çalışır
                  if (text.trim().isNotEmpty) {
                    // Kontrolcü üzerinden asistana soruyu iletiyoruz
                    widget.controller.askAssistant(text.trim());
                    // Gönderim yapıldıktan sonra giriş kutusunu temizliyoruz
                    _textController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: ASİSTAN BAŞLIĞI
// -----------------------------------------------------------------------------

// Asistan avatarı, başlık metinleri ve kapatma butonunu içeren StatelessWidget
class _AssistantHeader extends StatelessWidget {
  // Pencereyi kapatma eylemini tetikleyen geri çağırma işlevi
  final VoidCallback onClose;

  // Zorunlu kurucu fonksiyon
  const _AssistantHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Context extension üzerinden aktif tema renk paletini alıyoruz
    final colors = context.colors;

    // Yatay hizada elemanları dizen Row bileşeni
    return Row(
      children: [
        // Dairesel asistan avatarı
        CircleAvatar(
          // Temanın primary renginin %15 opaklığıyla açık arka plan dolgusu
          backgroundColor: colors.primary.withValues(alpha: 0.15),
          // Destek/Asistan ikonu
          child: Icon(
            Icons.support_agent_rounded,
            color: colors.primary,
          ),
        ),
        // Avatar ile metinler arasına 12 piksel yatay boşluk
        const SizedBox(width: 12),
        // Başlık ve alt başlığı kalan genişliğe esneten Expanded
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kalın yazı tipiyle asistan başlığı
              Text(
                'TakeGO Yol Asistanı',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // İkincil açıklama metni
              Text(
                '7/24 Canlı Destek & Akıllı Rehber',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        // Pencereyi kapatmaya yarayan çarpı ikonu butonu
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: HIZLI SSS ÇİPLERİ
// -----------------------------------------------------------------------------

// Sıkça sorulan soruları yatay kaydırılabilir butonlar olarak sunan bileşen
class _FaqChips extends StatelessWidget {
  // Soru tıklandığında asistan metodunu çağırmak için kontrolcü
  final SmartKeyController controller;

  // Kurucu fonksiyon
  const _FaqChips({required this.controller});

  // Hazır soru şablonlarının bulunduğu sabit liste
  static const List<String> faqs = [
    'Yakıt kapağı nasıl açılır?',
    'Haftalık kiralama uzatılabilir mi?',
    'Park yasağı var mı?',
    'Acil durum & arıza',
  ];

  @override
  Widget build(BuildContext context) {
    // Ekrana sığmayan çipleri yatayda kaydırmaya yarayan SingleChildScrollView
    return SingleChildScrollView(
      // Yatay kaydırma yönü
      scrollDirection: Axis.horizontal,
      // Çipleri yan yana dizen Row bileşeni
      child: Row(
        // faqs listesindeki her metni ActionChip bileşenine dönüştürüyoruz
        children: faqs.map((q) {
          // Her çipin sağına 6 piksel boşluk ekleyen Padding
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            // Tıklanabilir işlem çipi
            child: ActionChip(
              // Çipin üzerindeki metin etiketi
              label: Text(
                q,
                style: const TextStyle(fontSize: 11),
              ),
              // Çipe tıklandığında bu soruyu asistana doğrudan soran fonksiyon
              onPressed: () {
                controller.askAssistant(q);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 3: MESAJ BALONCUKLARI LİSTESİ
// -----------------------------------------------------------------------------

// Karşılıklı sohbet mesajlarını dinleyen ve listeleyen bileşen
class _MessageList extends StatelessWidget {
  // Mesaj listesini tutan kontrolcü
  final SmartKeyController controller;

  // Kurucu fonksiyon
  const _MessageList({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Aktif tema renklerini alıyoruz
    final colors = context.colors;

    // Mesaj listesini reaktif olarak dinleyen ValueListenableBuilder
    return ValueListenableBuilder<List<AssistantMessageModel>>(
      // smart_key_controller içindeki mesaj listesi bildiricisi
      valueListenable: controller.messagesNotifier,
      // Liste değiştikçe çalışan inşa edici (builder) fonksiyon
      builder: (context, messages, _) {
        // Dinamik mesaj listesini oluşturan ListView.builder
        return ListView.builder(
          // En yeni mesajın en altta kalması için ters sıralama (reverse)
          reverse: true,
          // Listedeki toplam mesaj sayısı
          itemCount: messages.length,
          // Her bir mesaj öğesi için çağrılan builder fonksiyonu
          itemBuilder: (context, index) {
            // Ters sıralama nedeniyle doğru indeksteki mesajı alıyoruz
            final msg = messages[messages.length - 1 - index];
            // Mesajın kullanıcıya mı ait olduğunu kontrol ediyoruz
            final isUser = msg.isUser;

            // Mesajı kullanıcı ise sağa, asistan ise sola hizalıyoruz
            return Align(
              // Sağa veya sola hizalama kuralı
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              // Mesaj balonu kutusu
              child: Container(
                // Dikeyde mesajlar arası 4 piksel boşluk
                margin: const EdgeInsets.symmetric(vertical: 4),
                // Balonun içindeki metin etrafına dolgu
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                // Balonun maksimum genişliğini 280 pikselle sınırlıyoruz
                constraints: const BoxConstraints(maxWidth: 280),
                // Balonun köşe yuvarlaklığı ve arka plan rengi
                decoration: BoxDecoration(
                  // Kullanıcı mesajı ise primary mavi, asistan ise yüzey grisi
                  color: isUser
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  // 14 piksel yuvarlatılmış köşeler
                  borderRadius: BorderRadius.circular(14),
                ),
                // Mesaj metnini gösteren Text bileşeni
                child: Text(
                  // Mesajın metin içeriği
                  msg.text,
                  // Yazı stili
                  style: TextStyle(
                    fontSize: 13,
                    // Kullanıcı mesajında beyaz, asistanda temaya uygun koyu/açık metin
                    color: isUser ? Colors.white : colors.onSurface,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 4: METİN GİRDİ SATIRI
// -----------------------------------------------------------------------------

// Kullanıcının klavye ile soru yazıp gönderdiği alt satır bileşeni
class _MessageInputField extends StatelessWidget {
  // Metin alanını kontrol eden denetleyici
  final TextEditingController controller;
  // Gönderim yapıldığında metni dışarı aktaran geri çağırma fonksiyonu
  final ValueChanged<String> onSend;

  // Kurucu fonksiyon
  const _MessageInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    // Giriş kutusu ve gönder butonunu yan yana dizen Row bileşeni
    return Row(
      children: [
        // Metin giriş alanını yatayda kalan tüm genişliğe yayan Expanded
        Expanded(
          child: TextField(
            // TextEditingController nesnesi bağlanıyor
            controller: controller,
            // Giriş alanının görsel süslemeleri
            decoration: const InputDecoration(
              // İpucu metni
              hintText: 'Bir soru sorun...',
              // İç dolgu boşluğu
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            // Klavyedeki 'Git/Enter' tuşuna basıldığında çalışan fonksiyon
            onSubmitted: onSend,
          ),
        ),
        // Giriş kutusu ile gönder butonu arasına 8 piksel boşluk
        const SizedBox(width: 8),
        // Gönderme ikonu içeren yuvarlak buton
        IconButton.filled(
          // Butona tıklandığında metin kutusundaki yazıyı onSend ile iletiyoruz
          onPressed: () {
            onSend(controller.text);
          },
          // Gönderme uçağı ikonu
          icon: const Icon(Icons.send_rounded, size: 18),
        ),
      ],
    );
  }
}
