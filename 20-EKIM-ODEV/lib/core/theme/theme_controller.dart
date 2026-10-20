// Flutter Materyal kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';

/// TakeGO Tema Yönetim Denetleyicisi (ThemeController)
///
/// Harici ağır durum yönetimi paketleri (Bloc, Riverpod vb.) yerine
/// Flutter'ın hafif ve yerel [ValueNotifier] yapısını kullanarak
/// OLED Cockpit Dark ve Clean Mobility Light modları arasında
/// anlık, hafif ve reaktif geçiş sağlar.
class ThemeController {
  // ---------------------------------------------------------------------------
  // REAKTİF TEMA DURUMU
  // ---------------------------------------------------------------------------

  /// Aktif tema modunu (Light/Dark) dinleyen ValueNotifier
  /// Varsayılan değer: Gece sürüşüne uygun ThemeMode.dark (OLED Cockpit Dark)
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  // ---------------------------------------------------------------------------
  // YARDIMCI GETTER METOTLARI
  // ---------------------------------------------------------------------------

  /// Mevcut temanın koyu mod olup olmadığını kontrol eden pratik mantıksal (boolean) getter
  bool get isDarkMode {
    // ValueNotifier içindeki değer ThemeMode.dark ise true döner
    return themeModeNotifier.value == ThemeMode.dark;
  }

  /// Mevcut tema modunu doğrudan enum olarak döndürür
  ThemeMode get currentMode {
    // ValueNotifier içerisindeki aktif enum değerini döndürüyoruz
    return themeModeNotifier.value;
  }

  // ---------------------------------------------------------------------------
  // TEMA DEĞİŞTİRME EYLEMLERİ
  // ---------------------------------------------------------------------------

  /// Gece ve Gündüz modları arasında tek dokunuşla geçiş yapar
  void toggleTheme() {
    // Eğer karanlık moddaysa aydınlık moda, aydınlıktaysa karanlık moda alıyoruz
    themeModeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  /// İstenilen belirli bir tema modunu doğrudan atar
  void setThemeMode(ThemeMode mode) {
    // Yeni mod mevcut moddan farklıysa değeri güncelliyoruz
    if (themeModeNotifier.value != mode) {
      // Yeni modu ValueNotifier'a atıyoruz (tüm dinleyiciler tetiklenir)
      themeModeNotifier.value = mode;
    }
  }

  // ---------------------------------------------------------------------------
  // BELLEK TEMİZLİĞİ
  // ---------------------------------------------------------------------------

  /// Uygulama veya servis kapandığında dinleyici kaynaklarını serbest bırakır
  void dispose() {
    // Bellek sızıntılarını önlemek için ValueNotifier dinleyicisini serbest bırakıyoruz
    themeModeNotifier.dispose();
  }
}
