extension DateFormatterExtension on DateTime {
  /// Tarihi "20 Ekim 2026, Salı" formatında döndürür.
  String toJournalDate() {
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];

    final monthName = months[month - 1];
    final dayName = days[weekday - 1];
    return '$day $monthName $year, $dayName';
  }

  /// Tarihi "14:30" formatında döndürür.
  String toJournalTime() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Aynı gün mü kontrolü.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
