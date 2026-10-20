// Flutter temel sınıfları ve ValueNotifier için foundation paketini içe aktarıyoruz
import 'package:flutter/foundation.dart';
// Başlangıç mock araçlar listesini içe aktarıyoruz
import '../../../core/constants/mock_cars.dart';
// Araç veri modelini tip güvenliği için içe aktarıyoruz
import '../models/car_model.dart';
// Kiralama periyot tiplerini (günlük, haftalık, aylık) içe aktarıyoruz
import '../models/rental_period_type.dart';

/// TakeGO İlan Listeleme ve Arama Denetleyicisi (CarListingController)
///
/// Araç listesi, seçili kiralama periyodu (Günlük/Haftalık/Aylık),
/// arama sorguları ve elektrikli araç filtrelerini saf [ValueNotifier]
/// ile yöneten iş mantığı katmanıdır.
class CarListingController {
  // ---------------------------------------------------------------------------
  // REAKTİF DURUM DEĞİŞKENLERİ (ValueNotifier)
  // ---------------------------------------------------------------------------

  /// Kullanıcının seçtiği aktif kiralama periyodu (Varsayılan: Günlük)
  final ValueNotifier<RentalPeriodType> selectedPeriod =
      ValueNotifier<RentalPeriodType>(RentalPeriodType.daily);

  /// Bellekte tutulan tüm araçların ana listesi (filtresiz kaynak liste)
  final ValueNotifier<List<CarModel>> _allCarsNotifier =
      ValueNotifier<List<CarModel>>([]);

  /// Arama ve filtrelerden sonra ekranda gösterilecek aktif araçların listesi
  final ValueNotifier<List<CarModel>> displayedCarsNotifier =
      ValueNotifier<List<CarModel>>([]);

  /// Kullanıcının arama çubuğuna yazdığı arama metni bildiricisi
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');

  /// Yalnızca elektrikli araçları filtreleme anahtarı durumu
  final ValueNotifier<bool> electricOnlyNotifier = ValueNotifier<bool>(false);

  // ---------------------------------------------------------------------------
  // BAŞLATMA (Initialization)
  // ---------------------------------------------------------------------------

  /// Başlangıç mock verilerini listeye yükler ve ilk filtrelemeyi uygular
  void init() {
    // initialMockCars listesinin kopyasını ana araç listemize alıyoruz
    _allCarsNotifier.value = List.from(initialMockCars);

    // İlk açılışta filtreleri çalıştırarak vitrin listesini dolduruyoruz
    _applyFilters();
  }

  // ---------------------------------------------------------------------------
  // KULLANICI EYLEMLERİ VE FİLTRE YÖNETİMİ
  // ---------------------------------------------------------------------------

  /// Kiralama periyodunu değiştirir (Günlük / Haftalık / Aylık)
  void changePeriod(RentalPeriodType period) {
    // Eğer seçilen periyot mevcut olandan farklıysa güncelliyoruz
    if (selectedPeriod.value != period) {
      // Yeni periyodu atayarak dinleyicileri tetikliyoruz
      selectedPeriod.value = period;
    }
  }

  /// Arama kutusuna girilen metni günceller ve listeyi filtreler
  void updateSearchQuery(String query) {
    // Yeni arama sorgusunu ValueNotifier'a atıyoruz
    searchQueryNotifier.value = query;

    // Filtreleme motorunu çalıştırıyoruz
    _applyFilters();
  }

  /// Sadece elektrikli araç filtre durumunu tersine çevirir
  void toggleElectricFilter() {
    // Mevcut durumun tersini atıyoruz (true -> false veya false -> true)
    electricOnlyNotifier.value = !electricOnlyNotifier.value;

    // Filtreleri güncel duruma göre yeniden uyguluyoruz
    _applyFilters();
  }

  /// Yeni ilan verildiğinde listeye tip güvenli olarak en baştan ekler
  void addNewListing(CarModel newCar) {
    // 1. Yeni aracı listenin en başına ekleyerek yeni bir liste referansı oluşturuyoruz
    _allCarsNotifier.value = [newCar, ..._allCarsNotifier.value];

    // 2. Global mock listesine de kalıcı ekliyoruz
    initialMockCars.insert(0, newCar);

    // 3. Ekrana anında yansıtması için filtreleri yeniden çalıştırıyoruz
    _applyFilters();
  }

  /// Arama sorgusu ve elektrikli filtre kriterlerine göre listeyi süzer
  void _applyFilters() {
    // Arama metnini küçük harfe çevirip baş ve sondaki boşlukları temizliyoruz
    final query = searchQueryNotifier.value.trim().toLowerCase();

    // Sadece elektrikli filtresinin açık olup olmadığını alıyoruz
    final onlyElectric = electricOnlyNotifier.value;

    // Ana listedeki araçları kriterlere göre süzüyoruz
    final filtered = _allCarsNotifier.value.where((car) {
      // 1. Kriter: Eğer elektrikli filtresi açıksa ve araç elektrikli değilse elenir
      if (onlyElectric && !car.isElectric) {
        return false;
      }

      // 2. Kriter: Metin araması varsa marka, model veya lokasyonda aranır
      if (query.isNotEmpty) {
        // Marka eşleşmesi kontrolü
        final matchesBrand = car.brand.toLowerCase().contains(query);
        // Model eşleşmesi kontrolü
        final matchesModel = car.model.toLowerCase().contains(query);
        // Lokasyon şehir/ilçe eşleşmesi kontrolü
        final matchesLocation = car.location.toLowerCase().contains(query);

        // Herhangi biri eşleşiyorsa aracı listeye dahil et
        return matchesBrand || matchesModel || matchesLocation;
      }

      // Filtreleme kriterlerini geçtiyse aracı kabul et
      return true;
    }).toList();

    // Filtrelenmiş listeyi ekrana yansıtmak üzere bildiriciye atıyoruz
    displayedCarsNotifier.value = filtered;
  }

  // ---------------------------------------------------------------------------
  // BELLEK TEMİZLİĞİ
  // ---------------------------------------------------------------------------

  /// Sayfa kapatıldığında tüm dinleyicileri serbest bırakır (Memory leak önler)
  void dispose() {
    // Seçili periyot bildiricisini temizle
    selectedPeriod.dispose();
    // Ana araç listesi bildiricisini temizle
    _allCarsNotifier.dispose();
    // Görüntülenen araç listesi bildiricisini temizle
    displayedCarsNotifier.dispose();
    // Arama metni bildiricisini temizle
    searchQueryNotifier.dispose();
    // Elektrikli filtre bildiricisini temizle
    electricOnlyNotifier.dispose();
  }
}
