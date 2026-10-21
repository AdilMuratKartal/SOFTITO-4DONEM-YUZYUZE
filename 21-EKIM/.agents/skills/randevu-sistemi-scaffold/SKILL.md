---
name: randevu-sistemi-scaffold
description: Çok Sektörlü Teklif Usulü Randevu ve Hizmet Platformu (Müşteri & Hizmet Veren, Ben Geleyim / Sen Gel konum-adres yönetimi, karşılıklı teklif ve offline-first JSON mimarisi) için standart klasör yapısı, Provider durum yönetimi, UI bileşenleri ve test iskeletini eksiksiz üretir.
---

# Randevu Sistemi Scaffold (Çok Sektörlü Teklif Usulü Randevu Platformu İskeleti)

Bu yetenek, **Çok Sektörlü Teklif Usulü Randevu ve Hizmet Platformu** projesinde [21-EKIM/project.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/project.md) ve [21-EKIM/THEME.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/THEME.md) standartlarına tam sadık kalarak yeni model, provider, ekran ve bileşenlerin üretilmesini, mimari kuralların korunmasını ve statik analiz standartlarının (`flutter analyze` 0 hata/0 uyarı) sağlanmasını garanti eder.

---

## 1. Temel Mimari Prensipler ve Kurallar

1. **Çift Taraflı Rol Desteği (Müşteri & Hizmet Veren):**
   - Uygulama tek bir codebase üzerinde hem **Müşteri (Customer)** hem de **Hizmet Veren (Provider/Uzman)** akışını destekler.
   - Ortak ekranlar (`offer_form_screen.dart`, `chat_screen.dart`, `profile_screen.dart`) role göre dinamik davranış sergiler.
2. **Akıllı Konum ve Adres Yönetimi ("Ben Geleyim" / "Sen Gel"):**
   - **"Sen Gel" (`sen_gel` - Adrese Hizmet):** Hizmet sağlayıcı müşterinin adresine gider. Müşterinin profilindeki kayıtlı adresi otomatik seçilir veya form üzerinden anlık açık adres/konum girilir.
   - **"Ben Geleyim" (`ben_geleyim` - Dükkanda Hizmet):** Müşteri dükkana/ofise gider. Hizmet sağlayıcının ilandaki sabit adresi randevu lokasyonu olarak sabitlenir.
3. **Karşılıklı Teklif ve Pazarlık Mekanizması:**
   - İlk randevu talebi müşteri tarafından fiyat ve saat önerisiyle (`status: 'beklemede'`) oluşturulur.
   - Hizmet veren gelen talebi doğrudan onaylayabilir (`status: 'onaylandi'`), reddedebilir (`status: 'iptal'`) veya yeni fiyat/saat ile **Karşı Teklif** gönderebilir.
   - Müşteri randevularım ekranından gelen karşı teklifi görüp tekrar teklif verebilir ya da onaylayabilir.
4. **Dolu ve Boş Saat Dilimleri (Time Slots):**
   - Hizmet verenlerin müsaitlik takvimleri saat dilimleri (`HH:mm`) halinde tutulur.
   - Onaylanan randevular ilgili gün ve saat dilimini otomatik olarak kilitler (`isBooked: true`), çakışmaları engeller.
5. **Offline-First JSON Veri Mimarisi:**
   - Harici backend olmadan `assets/data/` altındaki `users.json`, `listings.json`, `appointments.json` ve `messages.json` dosyaları `JsonDataService` ile okunur.
   - Oturum içi değişiklikler `ChangeNotifier` (Provider) ve `shared_preferences` ile cihaz hafızasında güncel tutulur.
6. **Kod ve Tasarım Kalitesi:**
   - `THEME.md` renk paletine harfiyen uyulur (`AppColors.primary: #2563EB`, `secondary: #EA580C`, durum rozetleri, konum rozetleri).
   - Asla sabit renk (`Color(0xFF...)`) bileşen içine gömülmez; `AppColors` veya `Theme.of(context).colorScheme` kullanılır.
   - `build` metotları 40-50 satırı aşamaz; alt bileşenler `widgets/` altına parçalanır.
   - Mümkün olan tüm widget'larda `const` zorunludur.

---

## 2. Proje Dizin Yapısı ([project.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/project.md) Standardı)

```text
lib/
├── core/
│   ├── constants/              # app_constants.dart, mock_data.dart
│   ├── services/               # json_data_service.dart, storage_service.dart
│   └── theme/                  # app_theme.dart (AppColors & AppTheme)
├── models/
│   ├── user_model.dart         # Kullanıcı, rol ve kayıtlı adres modeli
│   ├── listing_model.dart      # İlan, sektör ve saat dilimi modeli
│   ├── appointment_model.dart  # Teklif, adres, durum ve randevu modeli
│   └── message_model.dart      # Chat mesaj modeli
├── providers/
│   ├── auth_provider.dart      # Aktif kullanıcı, profil adresi ve rol seçimi
│   ├── listing_provider.dart   # İlan listeleme, sektör & zaman & konum filtreleme
│   ├── appointment_provider.dart # Teklif atma, karşı teklif, onay/iptal yönetimi
│   └── chat_provider.dart      # Randevu bazlı mesajlaşma akışı
├── views/
│   ├── auth/
│   │   └── login_screen.dart                 # Rol seçimi (Müşteri / Hizmet Veren)
│   ├── customer/
│   │   ├── customer_home_screen.dart         # Filtreli ilan vitrini
│   │   └── customer_appointments_screen.dart # Müşteri randevuları ve detay
│   ├── provider/
│   │   ├── provider_appointments_screen.dart # Gelen randevu talepleri ve yönetim
│   │   └── create_listing_screen.dart        # Yeni ilan/müsaitlik takvimi açma
│   └── shared/
│       ├── offer_form_screen.dart            # Teklif / Karşı Teklif verme ve adres formu
│       ├── chat_screen.dart                  # WhatsApp benzeri mesajlaşma
│       ├── profile_screen.dart               # Profil, adres düzenleme & mod değiştirme
│       └── widgets/                          # StatusBadge, LocationBadge, TimeSlotChip, ChatBubble
└── main.dart
```

---

## 3. Katmanlı Geliştirme Adımları

### Adım 1: Veri Modellerini Tanımlama (`models/`)
Tüm modeller `@immutable` olmalı; `copyWith`, `fromJson` ve `toJson` içermelidir:

```dart
// lib/models/appointment_model.dart
import 'package:flutter/foundation.dart';

@immutable
class AppointmentModel {
  final String id;
  final String listingId;
  final String customerId;
  final String providerId;
  final String serviceTitle;
  final String description;
  final String appointmentDate;     // 'YYYY-MM-DD'
  final String appointmentTime;     // '14:00'
  final double offeredPrice;        // Teklif edilen güncel tutar
  final String locationType;        // 'sen_gel' | 'ben_geleyim'
  final String address;             // Açık adres veya dükkan adresi
  final String status;              // 'beklemede' | 'onaylandi' | 'iptal' | 'bitti'
  final String lastOfferBy;         // 'customer' | 'provider' (Karşı teklif takibi için)
  final String createdAt;

  const AppointmentModel({
    required this.id,
    required this.listingId,
    required this.customerId,
    required this.providerId,
    required this.serviceTitle,
    required this.description,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.offeredPrice,
    required this.locationType,
    required this.address,
    required this.status,
    required this.lastOfferBy,
    required this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? listingId,
    String? customerId,
    String? providerId,
    String? serviceTitle,
    String? description,
    String? appointmentDate,
    String? appointmentTime,
    double? offeredPrice,
    String? locationType,
    String? address,
    String? status,
    String? lastOfferBy,
    String? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      description: description ?? this.description,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      locationType: locationType ?? this.locationType,
      address: address ?? this.address,
      status: status ?? this.status,
      lastOfferBy: lastOfferBy ?? this.lastOfferBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      providerId: json['providerId'] as String? ?? '',
      serviceTitle: json['serviceTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      appointmentDate: json['appointmentDate'] as String? ?? '',
      appointmentTime: json['appointmentTime'] as String? ?? '',
      offeredPrice: (json['offeredPrice'] as num?)?.toDouble() ?? 0.0,
      locationType: json['locationType'] as String? ?? 'ben_geleyim',
      address: json['address'] as String? ?? '',
      status: json['status'] as String? ?? 'beklemede',
      lastOfferBy: json['lastOfferBy'] as String? ?? 'customer',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'customerId': customerId,
      'providerId': providerId,
      'serviceTitle': serviceTitle,
      'description': description,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'offeredPrice': offeredPrice,
      'locationType': locationType,
      'address': address,
      'status': status,
      'lastOfferBy': lastOfferBy,
      'createdAt': createdAt,
    };
  }
}
```

---

### Adım 2: JSON Servisi ve State Yönetimi (`providers/`)
`ChangeNotifier` ile teklif oluşturma, karşı teklif gönderme ve durum geçişleri:

```dart
// lib/providers/appointment_provider.dart
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../core/services/json_data_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final JsonDataService _dataService;
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  AppointmentProvider({required JsonDataService dataService})
      : _dataService = dataService;

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  bool get isLoading => _isLoading;

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    _appointments = await _dataService.loadAppointments();
    _isLoading = false;
    notifyListeners();
  }

  List<AppointmentModel> getByCustomer(String customerId) {
    return _appointments.where((a) => a.customerId == customerId).toList();
  }

  List<AppointmentModel> getByProvider(String providerId) {
    return _appointments.where((a) => a.providerId == providerId).toList();
  }

  /// Yeni randevu talebi / ilk teklif
  void createOffer(AppointmentModel newAppointment) {
    _appointments = [newAppointment, ..._appointments];
    notifyListeners();
  }

  /// Karşı teklif gönderme (Fiyat veya Saat revizesi)
  void submitCounterOffer({
    required String appointmentId,
    required double newPrice,
    required String newTime,
    required String counterOfferBy, // 'customer' veya 'provider'
  }) {
    _appointments = _appointments.map((item) {
      if (item.id == appointmentId) {
        return item.copyWith(
          offeredPrice: newPrice,
          appointmentTime: newTime,
          status: 'beklemede',
          lastOfferBy: counterOfferBy,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  /// Randevu durumunu güncelleme ('onaylandi', 'iptal', 'bitti')
  void updateStatus(String appointmentId, String newStatus) {
    _appointments = _appointments.map((item) {
      if (item.id == appointmentId) {
        return item.copyWith(status: newStatus);
      }
      return item;
    }).toList();
    notifyListeners();
  }
}
```

---

### Adım 3: Ortak UI Bileşenleri (`views/shared/widgets/`)
`THEME.md` ile birebir uyumlu rozetler ve saat dilimi çipleri kullanılmalıdır:

- **`StatusBadge`**: `onaylandi` (Yeşil), `beklemede` (Amber), `iptal` (Kırmızı), `bitti` (Gri/Mavi).
- **`LocationBadge`**: `sen_gel` (Mor rozet - Adrese Hizmet), `ben_geleyim` (Açık Mavi rozet - Dükkanda).
- **`TimeSlotChip`**: Dolu saatler gri çizili, seçili saat ana renk (`AppColors.primary`), boş saatler beyaz kart.
- **`ChatBubble`**: WhatsApp tarzı sağa yaslı (gönderen) veya sola yaslı (alıcı) sohbet kutuları.

---

### Adım 4: Ekran Geliştirme Standartları

1. **Müşteri Ana Sayfası (`customer_home_screen.dart`):**
   - Üst çip filtreleri: Sektör (`Tümü`, `Kuaför`, `Tesisat`, `Elektrik`, `Öğretmen`), Ulaşım (`Tümü`, `Ben Geleyim`, `Sen Gel`).
   - İlan kartında dükkan adı, sektör rozeti, konum rozeti, başlangıç fiyatı ve müsaitlik durumu.
2. **Teklif ve Adres Ekranı (`offer_form_screen.dart`):**
   - Hizmet verenin dolu/boş saat dilimleri `Wrap` ve `TimeSlotChip` ile listelenir.
   - Ulaşım tercihi: Radio/SegmentedButton ile `sen_gel` / `ben_geleyim`.
   - `sen_gel` seçilirse profil kayıtlı adresi checkbox ile sunulur veya manuel açık adres girilir.
   - `ben_geleyim` seçilirse ilandaki dükkan adresi salt-okunur olarak gösterilir.
   - Fiyat teklifi giriş alanı (`TextInputType.number`) ve "Teklif Gönder" / "Karşı Teklif Gönder" butonu.
3. **Randevularım Ekranları (`customer_appointments_screen.dart` & `provider_appointments_screen.dart`):**
   - Durum filtre sekmeleri (`Tümü`, `Bekleyenler`, `Onaylananlar`, `Tamamlananlar`).
   - Karta tıklanarak genişleyen açılır detay: Açık adres, güncel teklif tutarı, son teklifi kimin yaptığı (`lastOfferBy`).
   - Aksiyon butonları: Müşteride `Tekrar Teklif Ver`, `Mesaj Gönder`; Hizmet Verende `Onayla`, `Karşı Teklif`, `İptal Et`, `Mesaj Gönder`.
4. **Chat Ekranı (`chat_screen.dart`):**
   - AppBar üzerinde randevu özet bilgisi (Başlık, Tarih, Durum).
   - WhatsApp benzeri mesaj geçmişi listesi ve altta mesaj yazma çubuğu (`TextField` + Gönder butonu).

---

## 4. Doğrulama ve Test Komutları

Geliştirilen her ekran ve modülden sonra şu komutlar sırayla çalıştırılarak doğrulanmalıdır:

```bash
# 1. Statik kod analizi (0 hata ve 0 uyarı kuralı)
flutter analyze

# 2. Birim ve widget testleri
flutter test

# 3. Uygulamayı yerel cihazda veya emülatörde çalıştırma
flutter run
```

---

## 5. SSS (Sıkça Sorulan Sorular)

### Soru 1: Bu yeteneği ne zaman kullanmalıyım?
- **Cevap:** Randevu platformunda yeni bir ekran (`views/`), yeni bir veri sağlayıcı (`providers/`), model (`models/`) veya ortak widget (`widgets/`) üretirken; teklif-pazarlık mantığını ve adres seçimini kurgularken bu yetenek rehber alınmalıdır.

### Soru 2: Gerçek bir REST API veya Firebase eklemeli miyim?
- **Cevap:** Hayır. [project.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/project.md) uyarınca proje sunucusuzdur (Offline-First). Tüm veriler yerel JSON (`assets/data/`) dosyalarından yüklenir ve `shared_preferences` / provider durumunda işlenir.

### Soru 3: "Sen Gel" ile "Ben Geleyim" adres farkı kodda nasıl ele alınır?
- **Cevap:** `appointment.locationType == 'sen_gel'` ise randevunun adresi müşterinin kayıtlı profil adresi veya teklif ekranında yazdığı yeni adrestir. `ben_geleyim` ise hizmet verenin dükkan/ofis adresi sabitlenir.

---

## 6. 📂 Yardımcı Kaynaklar ve Betikler

### 1. Otomatik İskelet Üretici Betikler (`script/`)
- [generate_feature.sh](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/script/generate_feature.sh): Proje dizin yapısını, model, provider, view ve widget iskeletlerini otomatik üreten Bash betiği.
- [generate_feature.ps1](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/script/generate_feature.ps1): Windows PowerShell ortamı için otomatik iskelet üretici betik.

### 2. Mimari Referans Dokümanları (`references/`)
- [state_flow.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/references/state_flow.md): Durum akış şemaları (Mermaid), teklif/karşı teklif yaşam döngüsü ve JSON senkronizasyon mantığı.
- [theme_spec.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/references/theme_spec.md): `THEME.md` renk kodları, tipografi standartları ve atomik widget spesifikasyonları.

### 3. Altın Standart Örnek Kodlar (`examples/`)
- [sample_screen.dart](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/examples/sample_screen.dart): Teklif verme, karşı teklif ve adres seçimini eksiksiz gösteren çalışan referans ekran (`OfferFormScreen`).
- [sample_test.dart](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/.agents/skills/randevu-sistemi-scaffold/examples/sample_test.dart): Provider durum testleri ve widget testlerini içeren örnek test paketi.
