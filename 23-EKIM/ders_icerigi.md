## Sözleşmeler, SOLID prensipleri & OOP mimarisi
### 1.1 'interface' (arayüz/sözleşme)
**Sözlük anlamı:** İki bağımsız sistemin veya sınıfın birbirleriyle nasıl konuşacağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünü.
**Neden Kullanılır:** Bir sınıfa göbekten bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadan sahte/mock şarj servisiyle testi çalıştırabilmek için.)

```dart
abstract interface class StationContract{
    Future<void> startCharging(String socketId);
    Stream<double> watchLivePower();
}
```

---

### 1.2 `implements` vs `extends` vs `with` 

### 1.2.1 `implements` (Arayüz sözleşmesi)
**Sözlük anlamı:** Bir sınıfın, bir şablonun belirlediği kuralları kabul edip **içini sıfırdan kendisinin doldurulması** zorunluluğudur.

**Neden Kullanılır:** Farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve kodda bağımlılıkları azaltmak için.

### 1.2.2 `extends` (kalıtım/miras) 
**Sözlük anlamı:** Bir sınfın, başka bir sınıfın özelliklerini ve metodlarını doğrudan devralması.

**Neden Kullanılır:** Kod tekrarını önlemek(DRY), mantıksal bir sınıf hiyerarşisi oluşturmak için.

### 1.2.3 `with` (mixin/yetenek aşılama) 
**Sözlük Anlamı:** Sınıf hiyerarşisni bozmadan, bağımsız bir sınıfa hazır kod blokları (metotlar ve değişkenler) enjekte etme mekanizmasıdır.

**Neden Kullanılır:** Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım kimliğini önlemek ve modülerliği artırmak için.

---
### 1.3. SOLID Prensipleri (Mobil & Dart Odaklı)
#### 1. S - Single Responsibility Principle (Tek Sorumluluk Prensibi)
***Kural:*** Bir sınıfın veya dosyanın değişmesi için **yalnızca 1 sebebi olabilir** olmalıdır.(bir sınıfa binen fazla yük)(Her sınıfın sadece bir sorumluluğu olmalıdır.)
### 2. 0 - Open / Closed Principle (Açık / Kapalı Prensibi) 
***Kural*** yazılım varlıkları(sınıflar, modüller) **genişletilmeye AÇIK, ancak değiştirilmeye KAPALI** olmalıdır.
### 3. L - Liskov Substitution Principle (Liskov Yerine Geçme Prensibi) 
***Kural:*** Bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve hata fırlatmamalıdır.
### 4. I - Interface Segregation Principle (Arayüz Ayrıştırma Prensibi)
***Kural:*** İstemciler(sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman(fat) interface'ler yerine küçük, amaca yönelik arayüzler kurulmalıdır.
### 5. D - Dependency Inversion Principle (Bağımlılıkların Tersine Çevrilmesi)
***Kural:*** Yüksek seviyeli modüller (UI, iş mantığı) düşük seviyeli modüllere (veritabanı, HTTP istemcisi) doğrudan bağlı olmamalıdır. Her ikisi de soyutlamalara (`interface`) bağlı olmalıdır.(Üst sınıf alt sınıfa interface ile bağlanır)

---

### 1.4. `Coupling` (Bağlaşıklık) & `Cohension` (Uyum)
***Tightly Coupled(sıkı bağımlı):*** Sınıfların birbirinin her detayını bilmesi. Birinde yapılan bir harf değişikliği diğer 5 dosyayı bozuyorsa sistem sıkı bağımlıdır.

***Loosely Coupled(gevşek bağımlı):*** Sınıfların sadece interface üzerinden konuşması. Biri değiştiğinde diğeri etkilenmez.

***High Cohesion(Yüksek Uyum):*** Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması.

---

## STREAM TEMELLERİ, CUBİT & ENTERPRISE BLOC
### 2.1 `Stream` Nedir? (BLoC'un Kalbindeki Motor)
***Sözlük Anlamı:*** Zaman içinde parça parça gelen, akıp giden asenkron veri dizisi.

***BLOC Sırrı:*** BLOC kütüphanesi sihirli bir şey yapmaz! BLoC un içinde gizli bir `StreamController` vardır. Event'ler borunun bir ucundan girer(`sink.add`), BLoC onları işler ve diğer ucundan ekrana state akıtır(`stream.listen`).

---

### 2.3 BLoC'un 3 Temel Elemanı: `Event`, `State`, `Emitter`
***`Event`:*** Kullanıcının veya sistemin BLoC'a attığı emir fişi.
*Mini Sözdizimi:* `class StartChargingRequested extends ChargingEvent { final String socketId; }`

***State(Durum)** Ekranın o milisaniyedeki dondurulmuş fotoğrafı(snapshot).
*Mini Sözdizimi:* `class ChargingActiveState extends ChargingState{ final double kwh; }`
*Özel Durumlar:* `Initial`, `Loading`, `Error`, `Loaded`
***Emitter:*** BLoC'un ürettiği yeni state'i ekrana fırlattığı megafon borusu.
*Kural:* Senkron çalışır; `emit(NewState())` dendiği anda UI'daki builder'lar tetiklenir.

---

### 3.1. `Side Effect` (Yan Etki) Neden `BlocBuilder` İçine Yazılamaz?
* `BlocBuilder`'ın tek görevi **Widget döndürmektedir**.
* Flutter motoru ekranı saniyede 60 kez çizebilir(Rebuild). Eğer siz `BlocBuilder` içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır!**
* **Kural:** Yan etkiler SADECE `BlocListener` içine yazılır; çünkü `listener` sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir!
### 3.2. `BlocSelector` (Mikro Performans & Pil Tasarrufu)
* **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**.

---

### 4. EŞİTLİK, DEĞİŞMEZLİK & BLOCOBSERVER
### 4.1. `Referential Equality` vs `Value Equality` 
* **Dart Varsayılanı (Referans Eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mı? `Soket('A') == Soket('A')` -> **FALSE çıkar!** İçerikleri aynı olsa da RAM'deki evleri farklıdır.
* **Değer Eşitliği (Value Equality):** Nesnelerin içindeki veriler aynı mı:?
`Equatable` paketi tam olarak bunu çözer: Nesneleri RAM adresine göre değil, `props` listesindeki alanların değerine göre karşılaştırır.

### 4.2. `props` Listesi Yazılmazsa Ne Olur?
* BLoC ekran kartını yormamak için şu denetimi yapar: `if (yeniState == eskiState) ekraniCizme();`.
* Eğer siz `StationLoaded` state'ine yeni bir `filterType` alanı eklerseniz ama `props` içine yazmayı unutursanız; BLoC iki state'şi eşit zanneder ve **ekranı güncellemez, arayüz donuk kalır!**


### 4.3. `Immutabilitty`


### 4.4 `BlocObserver` (Tüm uygulamayaı Röntgenleme)
* **Kavram:** Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir kara kutu/ telemetri kaydedici.
* **Ne İşe Yarar?:** Hangi ekranda hangi Event fırlatıldı, State nereden nereye geçti (`onTransition`) ve nerede hata fırlatıldı (`onError`) tek merkezden konsola loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur.

## 5 CLEAN ARCHITECTURE KATMANLARI & SORUMLULUK DUVARLARI
### 5.1. `Entity` vs `Model / DTO`
* **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini(`id`,`kw`,`durum`) tutar. `fromJson` veya `toJson` İÇERMEZ.
* **`Model / DTO` (Data Transfer Object):** API'den gelen hem JSON verisini karşılayan taşıyıcıdır.`Entity`'den türer; `fromJson` ve `toJson` metotlarını barındırır.
* *"Neden Entity içine `fromJson` yazmıyoruz"?* 

*(Cevap: Yarın backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, sadece DATA katmanındaki Model etkilensin diye!)*

### 5.2

## 5.3 `Repository Contract` vs `Repository Implementation`
* **Contract (Domain Katmanında):** Sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
* **Implementation (Data Katmanında):** Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.

## 6. BAĞIMLILIK YÖNETİMİ (DEPENDENCY INJECTION) & `get_it`

### 6.1. Neden `new Dio()` Yazmak Yasaktır

### 6.2. 'GetIt' Kayit Tipleri: Singleton vs LazySingleton vs Factory
* **Singleton:** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
* **LazySingleton:** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi `sl<Dio>()` derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).
* **Factory:** Her çağrıldığında yepyeni, sıfır bir kopya üretir.

## 7. KURUMSAL AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STATUS KODLARI
* **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi
inceleyen/değiştiren güvenlik noktası.

### 7.2. "Bearer Token" & "Payload"
* **Bearer Token:** 'Bu anahtari taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen Şifrelenmiş kimlik kartı metni (`Authorization:Bearer eyjhbGci...`).
* **Payload:** Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body).

### 7.3. HTTP Durum Kodları Sözlüğü (Sınıfa Tahtada Sorulacak)
* **'200 OK' :** İstek başarılı, veri gövdede.
* **'201 Created:** Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
* **'400 Bad Request' :** İstemci hatasi; eksik veya hatalı parametre gönderdin.
* **'401 Unauthorized' :** Token yok veya süresi dolmuş; hemen Login'e yönlendir!
* **'403 Forbidden':** Giriş yaptin ama bu veriyi görmeye yetkin yok (Admin değilsin).
* **'404 Not Fund' :** Aradiğin soket veya istasyon sunucuda bulunamadı.
* **'500 Internal Server Error':** Backend sunucusu patladı; istemcilik bir hata yok.

## 8. VERİ DAYANIKLILIĞI: CACHE-FIRST & SAVUNMACI KODLAMA
### 8.1. 'Cache-First' (Önce Önbellek) Stratejisi
* **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi **0.01 milisaniyede** ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2. 'Defensive Programming (Savunmacı Programlama)
* **Mantik:** Sunucudan gelen veriye asla %100 güvenmeme prensibi.









