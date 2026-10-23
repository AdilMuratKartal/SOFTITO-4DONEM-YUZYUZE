# Ana Navigasyon (Navigation View)

Uygulamanın alt navigasyon barını ve sayfa geçişlerini yöneten ana iskelet bileşeni.

- **Konum:** `lib/features/views/navigation/main_navigation_view.dart`
- **Sorumluluklar:**
  - `NavigationBar` ile 5 ana sekme (Bugün, Rota, Odak, Analiz, Profil) arasında geçiş sağlama.
  - `IndexedStack` ile sekmeler arası geçişte sayfa durumlarını (State) koruma.
  - Günün ilk açılışında tek seferlik `DailyMoodDialog` (Duygu Durumu Modalı) tetikleme mantığını yönetme.
