import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/json_data_service.dart';

class AuthProvider extends ChangeNotifier {
  final JsonDataService dataService;
  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider({required this.dataService});

  List<UserModel> get users => List.unmodifiable(_users);
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isCustomer => _currentUser?.isCustomer ?? true;
  bool get isProvider => _currentUser?.isProvider ?? false;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _users = await dataService.loadUsers();
    // Varsayılan olarak ilk kullanıcıyı (Müşteri - Ahmet Yılmaz) seç
    if (_users.isNotEmpty) {
      _currentUser = _users.first;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Aktif kullanıcıyı değiştir (Müşteri veya Hizmet Veren seçimi)
  void switchUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Kullanıcı ID'sine göre kullanıcı seç
  void selectUserById(String id) {
    final found = _users.firstWhere((u) => u.id == id, orElse: () => _users.first);
    _currentUser = found;
    notifyListeners();
  }

  /// Müşteri profil adresini güncelle
  void updateSavedAddress(String newAddress) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(savedAddress: newAddress);
    _users = _users.map((u) => u.id == _currentUser!.id ? _currentUser! : u).toList();
    notifyListeners();
  }

  /// Hizmet veren dükkan adresini güncelle
  void updateShopAddress(String newShopAddress) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(shopAddress: newShopAddress);
    _users = _users.map((u) => u.id == _currentUser!.id ? _currentUser! : u).toList();
    notifyListeners();
  }
}
