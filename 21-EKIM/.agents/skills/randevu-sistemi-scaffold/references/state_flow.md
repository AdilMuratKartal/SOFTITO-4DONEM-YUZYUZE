# Randevu Sistemi - Reaktif Durum Akışı ve Mimari Standartlar (`state_flow.md`)

Bu doküman, **Çok Sektörlü Teklif Usulü Randevu ve Hizmet Platformu** projesinde geliştirme yapacak yapay zeka ajanları ve geliştiriciler için durum yönetimi (`Provider` / `ChangeNotifier`), teklif-pazarlık döngüsü, konum-adres akışı ve yerel JSON senkronizasyonu için bağlayıcı referanstır.

---

## 1. Mimari Katmanlar ve Sorumluluk Dağılımı

Uygulama katmanlı ve modüler bir mimariye sahiptir:

```mermaid
graph TD
    subgraph DataLayer ["Veri ve Servis Katmanı (lib/core/services/ & assets/data/)"]
        JSON["Local JSON Files (users, listings, appointments, messages)"]
        Service["JsonDataService (Asset okuma, ayrıştırma, önbellekleme)"]
        Prefs["SharedPreferences (Oturum içi durum saklama)"]
    end

    subgraph StateLayer ["Durum Yönetimi (lib/providers/)"]
        AuthProv["AuthProvider (Aktif kullanıcı, mod: Müşteri/Hizmet Veren)"]
        ListProv["ListingProvider (İlanlar, sektör/ulaşım filtreleme)"]
        AppointProv["AppointmentProvider (Teklifler, karşı teklif, durumlar)"]
        ChatProv["ChatProvider (Mesajlaşma geçmişi)"]
    end

    subgraph UILayer ["Kullanıcı Arayüzü (lib/views/)"]
        CustomerViews["views/customer/ (Home, Appointments)"]
        ProviderViews["views/provider/ (Requests, CreateListing)"]
        SharedViews["views/shared/ (OfferForm, Chat, Profile)"]
        Widgets["views/shared/widgets/ (StatusBadge, LocationBadge, TimeSlotChip)"]
    end

    JSON --> Service
    Service --> StateLayer
    Prefs <--> StateLayer
    StateLayer --> UILayer
    UILayer --> Widgets
    UILayer -->|Kullanıcı Aksiyonu| StateLayer
```

### Katman Kuralları ve Yasaklar

| Katman | Sorumluluk | İzin Verilenler | Kesinlikle Yasak Olanlar |
| :--- | :--- | :--- | :--- |
| **Models** (`lib/models/`) | Saf veri transfer sınıfları. | `@immutable`, `copyWith`, `fromJson`, `toJson`. | UI widget kodları, `BuildContext`, iş mantığı. |
| **Services** (`lib/core/services/`) | `rootBundle` ile JSON yükleme, simüle gecikmeler. | `rootBundle.loadString`, `json.decode`, `SharedPreferences`. | `BuildContext`, doğrudan widget çizimi. |
| **Providers** (`lib/providers/`) | Durum değişiklikleri, iş akışı mantığı, teklif kuralları. | `ChangeNotifier`, `notifyListeners()`. | UI widget'ları, doğrudan layout kodları. |
| **Views** (`lib/views/`) | Sayfa düzenleri, `Scaffold`, `Consumer` / `Provider.of`. | `StatelessWidget`, hafif `StatefulWidget` (yalnızca local UI state). | Ağır iş hesaplamaları, JSON dosyalarını doğrudan okumak. |
| **Widgets** (`lib/views/shared/widgets/`) | Atomik ve yeniden kullanılabilir UI bileşenleri. | Parametre alma, `Theme.of(context)` kullanma, callbackler. | Global provider durumunu doğrudan kirletmek. |

---

## 2. Randevu ve Karşı Teklif Durum Makinesi (Offer Lifecycle)

Platformun kalbi olan çift taraflı teklif usulü akış şeması:

```mermaid
stateDiagram-v2
    [*] --> Beklemede_Musteri: Müşteri İlk Teklifi Verir (Fiyat + Saat + Adres)
    
    Beklemede_Musteri --> Onaylandi: Hizmet Veren Kabul Eder
    Beklemede_Musteri --> Iptal: Hizmet Veren Reddeder
    Beklemede_Musteri --> Beklemede_HizmetVeren: Hizmet Veren Karşı Teklif Atar (Fiyat/Saat Revizesi)
    
    Beklemede_HizmetVeren --> Onaylandi: Müşteri Kabul Eder
    Beklemede_HizmetVeren --> Iptal: Müşteri Reddeder
    Beklemede_HizmetVeren --> Beklemede_Musteri: Müşteri Tekrar Teklif Verir
    
    Onaylandi --> Bitti: Hizmet Tamamlandı (Hizmet Veren veya Müşteri)
    Onaylandi --> Iptal: Karşılıklı İptal
    
    Iptal --> [*]
    Bitti --> [*]
```

### Durum Alanları (`AppointmentModel`)
- `status`: `'beklemede'` | `'onaylandi'` | `'iptal'` | `'bitti'`
- `lastOfferBy`: `'customer'` | `'provider'`
  - Eğer `status == 'beklemede'` ve `lastOfferBy == 'customer'` ise: Hizmet Verenin onaylama veya karşı teklif verme sırasıdır.
  - Eğer `status == 'beklemede'` ve `lastOfferBy == 'provider'` ise: Müşterinin onaylama veya tekrar teklif verme sırasıdır.

---

## 3. Akıllı Konum ve Adres Yönetimi Akışı

Ulaşım tercihine göre adresin belirlenme mantığı:

```mermaid
flowchart TD
    Start["Kullanıcı Teklif Ekranına Girer"] --> CheckLocationType{"İlanın Ulaşım Seçeneği Nedir?"}
    
    CheckLocationType -->|Yalnızca Sen Gel| SenGelOnly["Adrese Hizmet Zorunlu"]
    CheckLocationType -->|Yalnızca Ben Geleyim| BenGeleyimOnly["Dükkanda Hizmet Zorunlu"]
    CheckLocationType -->|Her İkisi| UserChoice["Kullanıcı Seçer: 'Sen Gel' mi 'Ben Geleyim' mi?"]
    
    UserChoice -->|Sen Gel Seçildi| SenGelFlow
    SenGelOnly --> SenGelFlow["'Sen Gel' (Adrese Servis) Akışı"]
    
    UserChoice -->|Ben Geleyim Seçildi| BenGeleyimFlow
    BenGeleyimOnly --> BenGeleyimFlow["'Ben Geleyim' (Dükkanda) Akışı"]
    
    SenGelFlow --> UseSavedAddress{"Profildeki Kayıtlı Adres Kullanılsın mı?"}
    UseSavedAddress -->|Evet| FillProfileAddress["Müşteri Profil Adresi Otomatik Doldurulur"]
    UseSavedAddress -->|Hayır| ManualAddressInput["Kullanıcı Yeni Açık Adres Yazar"]
    
    BenGeleyimFlow --> LockShopAddress["Hizmet Verenin Dükkan Adresi Sabitlenir (Salt-Okunur)"]
    
    FillProfileAddress --> SubmitOffer["Teklif Veritabanına/State'e Eklenir"]
    ManualAddressInput --> SubmitOffer
    LockShopAddress --> SubmitOffer
```

---

## 4. Dolu ve Boş Saat Dilimi Yönetimi

Randevu çakışmalarını önlemek için:

1. Hizmet verenin `ListingModel` içerisinde tanımlı günlük çalışma saatleri vardır (örn: `["09:00", "10:30", "13:00", "14:30", "16:00"]`).
2. `AppointmentProvider` içindeki aktif randevulardan ilgili gün için `status == 'onaylandi'` olanlar bulunur.
3. Ekranda `TimeSlotChip` çizilirken:
   - Eğer saat dilimi onaylı bir randevuda kullanılıyorsa `isBooked: true` yapılır. Tıklanamaz ve üzeri çizgili gösterilir.
   - Boş saat dilimleri seçilebilir durumdadır (`isSelected: selectedTime == time`).

---

## 5. Offline-First JSON Senkronizasyon Yaşam Döngüsü

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Kullanıcı / Ajan
    participant App as Flutter Uygulaması (main.dart)
    participant Svc as JsonDataService
    participant Assets as assets/data/*.json
    participant State as Provider Modülleri

    App->>Svc: init()
    Svc->>Assets: rootBundle.loadString('assets/data/listings.json')
    Assets-->>Svc: JSON String
    Svc->>Svc: json.decode() ve ListingModel.fromJson() listesi üret
    Svc-->>State: İlk verileri Provider'lara ilet
    State-->>App: UI çizilir (Hazır Durum)

    Note over App,State: Kullanıcı yeni bir teklif veya randevu oluşturduğunda:
    App->>State: appointmentProvider.createOffer(newAppointment)
    State->>State: In-Memory listeyi güncelle + notifyListeners()
    State->>Svc: (İsteğe bağlı) SharedPreferences'e kaydet
    State-->>App: UI anında reaktif olarak güncellenir
```

---

## 6. Anti-Pattern Rehberi (Yapılmaması Gerekenler)

- ❌ **Yanlış:** Teklif formunda doğrudan `setState` ile tüm ekranı baştan çizdirmek.
  - ✅ **Doğru:** Form alanlarını `Form` / `TextEditingController` ile yönetmek, liste ve seçimleri `Consumer` ile izole dinlemek.
- ❌ **Yanlış:** `sen_gel` konum tipinde hizmet verenin dükkan adresini müşteri adresi olarak kaydetmek.
  - ✅ **Doğru:** `sen_gel` seçildiğinde açıkça müşterinin girdiği veya profilinden çektiği ikamet/iş adresi kaydedilmelidir.
- ❌ **Yanlış:** İptal edilen (`iptal`) randevuların saat dilimini takvimde kilitli (`isBooked: true`) bırakmak.
  - ✅ **Doğru:** Yalnızca `onaylandi` statüsündeki randevular saat bloklar; iptal edilen veya reddedilen randevuların saati tekrar boşa çıkar.
- ❌ **Yanlış:** 500 satırlık devasa tek bir dosya yazmak.
  - ✅ **Doğru:** Kartlar, çipler ve diyaloglar `views/shared/widgets/` altında parçalanmalıdır.
