import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../core/services/json_data_service.dart';

class ListingProvider extends ChangeNotifier {
  final JsonDataService dataService;
  List<ListingModel> _listings = [];
  bool _isLoading = false;

  String _selectedSector = 'Tümü';
  String _selectedLocationFilter = 'Tümü';
  String _selectedTimeFilter = 'Tümü';

  ListingProvider({required this.dataService});

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
  List<ListingModel> getByProvider(String providerId) {
    return _listings.where((l) => l.providerId == providerId).toList();
  }

  /// Yeni ilan ekleme
  void addListing(ListingModel listing) {
    _listings = [listing, ..._listings];
    notifyListeners();
  }
}
