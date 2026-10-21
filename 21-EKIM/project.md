# Randevu Oluşturma Sistemi

## 1. Proje Özeti
Farklı sektörlerdeki hizmet verenler (kuaför, tesisatçı, elektrikçi, danışman, özel ders öğretmeni, şoför vb.) ile müşterileri buluşturan; müsaitlik durumuna, konum/ulaşım tercihine (**"Ben Geleyim / Sen Gel"**), **adres yönetimine** ve **karşılıklı fiyat/saat teklifine** dayalı çalışan çift taraflı mobil randevu uygulaması. Uygulama herhangi bir sunucu (backend) kullanmadan, yerel JSON veri setleri (`assets/data/`) ve uygulama içi durum yönetimi (State Management) ile çalışır.

## 2. Proje Amacı
Sabit fiyatlı ve tek yönlü randevu sistemlerinin aksine; müşteri adresine gelen ustadan kendi dükkanında hizmet veren kuaföre kadar farklı çalışma dinamiklerine sahip sektörleri tek çatı altında toplamak, tarafların fiyat, saat ve lokasyon konusunda pazarlık (karşı teklif) yapabilmesini ve uygulama içinden doğrudan mesajlaşabilmesini sağlamak.

## 3. Tahmini Ekran ve Sayfa Sayısı (8 Ana Ekran)
Uygulama **Müşteri Modu** ve **Hizmet Veren Modu** olmak üzere iki farklı arayüz akışına sahiptir:

1. **Giriş (Login) ve Rol Seçim Ekranı:** Kullanıcı seçimi ve test kolaylığı için "Müşteri" veya "Hizmet Veren" olarak devam etme ekranı.
2. **Müşteri Ana Sayfası (İlanlar / Randevu Keşfet):**
   - **Üst Kısım (Filtreler):** Sektör filtresi (Tesisat, Kuaför, Öğretmen vb.), Zaman filtresi (Saat, Gün, Hafta) ve Ulaşım/Konum filtresi (*"Ben Geleyim"* / *"Sen Gel"*).
   - **Alt Kısım (İlan Listesi):** İlan görseli, dükkan/uzman adı, sektör etiketi, ilçe/konum bilgisi, müsait olunan hafta/gün/saat dilimleri ve "Gel/Git" durumunu gösteren kartlar.
3. **Randevu Oluşturma / Teklif Atma Ekranı (Müşteri & Hizmet Veren Ortak Mantık):**
   - Randevu hakkında kısa özet başlık, detaylı açıklama, gün/saat seçimi ve **Fiyat Teklifi** giriş alanı.
   - **Konum ve Adres Seçimi:**
     - **"Sen Gel" (Hizmet veren müşteriye gelir) seçilirse:** Müşteriye *"Profilimdeki Kayıtlı Adresi Kullan"* seçeneği sunulur veya farklı bir yerde hizmet alınacaksa *"Yeni Adres / Konum Gir"* alanından manuel adres yazılır.
     - **"Ben Geleyim" (Müşteri dükkana/ofise gider) seçilirse:** Hizmet verenin profilindeki/ilanındaki dükkan adresi ekranda otomatik olarak sabitlenir.
   - Bu ekran hem ilk randevu talebinde hem de **"Tekrar Teklif Ver (Karşı Teklif)"** işleminde kullanılır.
4. **Müşteri - Randevularım Ekranı:**
   - **Kart Görünümü:** Dükkan/sektör resmi, müşterinin girdiği kısa özet başlık, teklif edilen fiyat, "Gel/Git" durumu ve durum etiketi (`Onaylandı`, `Beklemede`, `İptal`, `Bitti`).
   - **Detay / Açılır Alan:** Karta tıklandığında tam açıklama, saat/gün detayı, **hizmetin gerçekleşeceği açık adres (profil adresi veya girilen adres)** ve alt kısımda **"Tekrar Teklif Ver"** ile **"Mesaj Gönder"** butonları.
5. **Hizmet Veren - Randevularım (Gelen Talepler) Ekranı:**
   - Müşterilerden gelen taleplerin listelendiği ekran. Kart üzerinde müşteri adı, işin kısa özeti, talep edilen saat, teklif edilen fiyat, **"Gel/Git" durumu ile müşterinin konumu/adresi** ve randevu durumu (`Beklemede`, `Onaylandı`, `İptal`, `Bitti`) yer alır.
6. **Hizmet Veren - Randevu Yönetimi ve Karşı Teklif Ekranı:**
   - Hizmet verenin gelen talebi ve adresi inceleyip **Onaylama**, **İptal Etme** veya mesafe/iş yüküne göre yeni bir saat/fiyat belirleyerek müşteriye **Karşı Teklif Gönderme** ekranı.
7. **Hizmet Veren - İlan / Müsaitlik Oluşturma Ekranı:**
   - Hizmet verenin kendi dükkanı/hizmeti için müsait olduğu hafta, gün, boş/dolu saat dilimlerini, çalışma şeklini (Gel/Git) ve dükkan adresini (profilinden çekerek veya yeni girerek) yayınladığı ekran.
8. **Mesajlaşma (Dialog / Chat) ve Profil Ekranları:**
   - **Chat Ekranı:** Randevu taraflarının WhatsApp benzeri arayüzle mesajlaştığı ekran.
   - **Profil Ekranı:** Kullanıcı bilgileri, **varsayılan adres/konum bilgisini düzenleme alanı** ve modlar arası (Müşteri / Hizmet Veren) geçiş butonu.

## 4. Temel Özellikler
- **Dolu ve Boş Saat Dilimlerini Gösterme:** İlanlarda hizmet verenin müsaitlik takviminin (dolu/boş saat blokları) anlık gösterimi.
- **Karşılıklı Teklif (Pazarlık) Mekanizması:** Hem müşterinin hem de hizmet verenin fiyat, gün ve saat üzerinden birbirine karşı teklif gönderebilmesi.
- **Akıllı Konum ve Adres Yönetimi:** "Ben Geleyim / Sen Gel" tercihine göre kullanıcı profilindeki kayıtlı adresin otomatik çekilmesi veya işlem sırasında özel adres girilebilmesi.
- **Yönetici (Hizmet Veren) Onay/İptal Paneli:** Gelen randevu taleplerini onaylama, iptal etme, işi tamamlama (`Bitti`) veya revize teklif sunma.
- **WhatsApp Tarzı Mesajlaşma:** Her randevu kartına özel diyalog ekranı.
- **Sunucusuz (Offline-First) JSON Mimarisi:** Backend olmadan yerel JSON dosyaları ve uygulama içi state yönetimi ile tam fonksiyonel çalışma.

## 5. Hedef Kitle
Genel kullanıcılar, öğrenciler, bireysel hizmet arayan müşteriler ve bağımsız çalışan hizmet sağlayıcılar / esnaflar.

## 6. Öğrenci Çalışma ve Detay Alanı

### 6.1. Kullanılacak Teknolojiler & Kütüphaneler
- **Frontend:** Flutter, Dart
- **Backend / Veri Depolama:** Backend yok. Başlangıç verileri için yerel JSON dosyaları (`assets/data/`), oturum içi veri kalıcılığı için `shared_preferences`.
- **Ek Kütüphaneler / API'ler:** Durum yönetimi için `provider` (veya `riverpod`), tarih formatlama için `intl`, ikonlar için `lucide_icons` / Material Icons.

### 6.2. Klasör Yapısı ve Sayfa Hiyerarşisi

```text
proje_adi/
├── assets/
│   ├── data/
│   │   ├── users.json              # Müşteri ve Hizmet Veren profilleri (Varsayılan adres dahil)
│   │   ├── listings.json           # Hizmet verenlerin açtığı randevu ilanları ve saatler
│   │   ├── appointments.json       # Randevular, teklifler, adres ve durum bilgileri
│   │   └── messages.json           # Mesajlaşma geçmişi
│   └── images/                     # Sektör ve profil görselleri
│
└── lib/
    ├── core/
    │   ├── constants/              # Renkler, sektör listesi, sabitler
    │   ├── services/               # JsonDataService (JSON okuma ve state senkronizasyonu)
    │   └── theme/                  # Uygulama teması
    ├── models/
    │   ├── user_model.dart         # Kullanıcı ve kayıtlı adres modeli
    │   ├── listing_model.dart      # İlan ve müsait saat modeli
    │   ├── appointment_model.dart  # Teklif, konum ve randevu modeli
    │   └── message_model.dart      # Sohbet mesaj modeli
    ├── providers/
    │   ├── auth_provider.dart      # Aktif kullanıcı, profil adresi ve rol yönetimi
    │   ├── listing_provider.dart   # İlan listeleme ve filtreleme (Sektör, Zaman, Gel/Git)
    │   ├── appointment_provider.dart # Teklif verme, onay, iptal ve karşı teklif mantığı
    │   └── chat_provider.dart      # Mesaj gönderme ve listeleme
    ├── views/
    │   ├── auth/
    │   │   └── login_screen.dart
    │   ├── customer/
    │   │   ├── customer_home_screen.dart         # Sayfa 1: Filtreli ilan vitrini
    │   │   └── customer_appointments_screen.dart # Sayfa 3: Müşteri randevularım ve detay
    │   ├── provider/
    │   │   ├── provider_appointments_screen.dart # Sayfa 4: Hizmet veren gelen talepler
    │   │   └── create_listing_screen.dart        # Sayfa 5: Yeni ilan/müsaitlik açma
    │   └── shared/
    │       ├── offer_form_screen.dart            # Sayfa 2: Teklif / Karşı teklif ve adres ekranı
    │       ├── chat_screen.dart                  # Sayfa 6: WhatsApp tarzı mesajlaşma
    │       └── profile_screen.dart               # Sayfa 7: Profil, adres güncelleme ve rol seçimi
    └── main.dart
```

## 7. Geliştirme, Analiz ve Test Komutları
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlakaq alttaki komutların çalıştığını doğrulamalıdır:

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
  ```bash
  flutter analyze
  ```

* **Birim ve widget testleri:**
  ```bash
  flutter test
  ```

* **Projeyi çalıştırma:**
  ```bash
  flutter run
  ```

## 8. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan, net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; yalnızca hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya *"Şimdi `flutter analyze` ile kontrol edebilirsin"* şeklinde doğrulama yönergeleri ver.

## 9. Ajan Yetenekleri ve Yardımcı Araçlar

Projede geliştirme yapacak ajanlar ve geliştiriciler, `THEME.md`, `.agents/skills/` dizini altındaki standartları kullanmalıdır:
- **Otomatik İskelet Betiği:** generate\_feature.sh
- **Durum Akış Referansı:** state\_flow.md
- **Altın Standart Referans Kod:** sample\_screen.dart

