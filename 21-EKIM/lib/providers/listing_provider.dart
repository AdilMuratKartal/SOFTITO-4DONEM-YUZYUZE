import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/listing_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../core/services/json_data_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

class ListingProvider extends ChangeNotifier { // ListingProvider sınıfı, dinleyicilere değişiklik haberini yayan ChangeNotifier yapımızdır
  final JsonDataService dataService; // JsonDataService türünden dataService adlı değişkenimiz
  List<ListingModel> _listings = [];
  bool _isLoading = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_isLoading)

  String _selectedSector = 'Tümü'; // String türünden _selectedSector değişkenimiz
  String _selectedLocationFilter = 'Tümü'; // String türünden _selectedLocationFilter değişkenimiz
  String _selectedTimeFilter = 'Tümü'; // String türünden _selectedTimeFilter değişkenimiz

  ListingProvider({required this.dataService}); // dataService parametresinin verilmesinin zorunlu olduğunu söylüyoruz

  List<ListingModel> get allListings => List.unmodifiable(_listings);
  bool get isLoading => _isLoading;
  String get selectedSector => _selectedSector;
  String get selectedLocationFilter => _selectedLocationFilter;
  String get selectedTimeFilter => _selectedTimeFilter;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _listings = await dataService.loadListings();
    _isLoading = false;
    notifyListeners();
  }

  void setSectorFilter(String sector) {
    _selectedSector = sector;
    notifyListeners();
  }

  void setLocationFilter(String locationFilter) {
    _selectedLocationFilter = locationFilter;
    notifyListeners();
  }

  void setTimeFilter(String timeFilter) {
    _selectedTimeFilter = timeFilter;
    notifyListeners();
  }

  /// Filtrelenmiş ilan listesi
  List<ListingModel> get filteredListings {
    return _listings.where((listing) {
      // Sektör filtresi
      if (_selectedSector != 'Tümü' && listing.sector != _selectedSector) {
        return false;
      }

      // Ulaşım / Konum filtresi
      if (_selectedLocationFilter == 'Ben Geleyim (Dükkanda)') {
        if (listing.locationType != 'ben_geleyim' && listing.locationType != 'her_ikisi') {
          return false;
        }
      } else if (_selectedLocationFilter == 'Sen Gel (Adrese)') {
        if (listing.locationType != 'sen_gel' && listing.locationType != 'her_ikisi') {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Hizmet verenin kendi açtığı ilanları getir
  List<ListingModel> getByProvider(String providerId) { // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    return _listings.where((l) => l.providerId == providerId).toList(); // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
  }

  /// Yeni ilan ekleme
  void addListing(ListingModel listing) {
    _listings = [listing, ..._listings];
    notifyListeners();
  }
}
