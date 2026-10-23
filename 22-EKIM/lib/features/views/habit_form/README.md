# Alışkanlık Formu (Habit Form View)

Yeni mikro-alışkanlık ekleme ve var olan alışkanlıkları düzenleme/silme modal bileşeni.

- **Konum:** `lib/features/views/habit_form/add_edit_habit_view.dart`
- **Sorumluluklar:**
  - Alışkanlık adı girişi ve mikro-adım hedefi belirleme (Örn: Su için 250 ml mikro adım).
  - İkon seçici (spor, su, kitap, müzik, zihin, besin, bisiklet vb.).
  - 4 temel kategori (Spor, Sağlık, Zihin, Müzik) ve dinamik `+ Yeni Kategori` ekleme entegrasyonu.
  - Haftalık çoklu gün seçimi (Pzt - Paz).
  - Başlangıç ve bitiş zaman aralığı seçimi (`09:45 - 15:36`).
  - Hatırlatıcı (Reminder) bildirimi açma/kapama anahtarı.
  - Alışkanlık silme onay diyaloğu.
