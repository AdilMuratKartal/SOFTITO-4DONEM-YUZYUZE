// Flutter materyal kütüphanesini (DateTimeRange için) içe aktarıyoruz
import 'package:flutter/material.dart';

/// DateTime Nesneleri için TakeGO Tarih Format Uzantıları (DateExtensions)
///
/// Araç kiralama başlangıç ve bitiş tarihlerini Türkçe ve kompakt
/// formatlarda göstermek için yardımcı uzantılar sunar.
extension DateExtensions on DateTime {
  // ---------------------------------------------------------------------------
  // TARİH FORMATLAMA YÖNTEMLERİ
  // ---------------------------------------------------------------------------

  /// 'GG.AA.YYYY' formatında standart tarih döndürür (Örn: 20.10.2024)
  String get toFormattedString {
    // 1. Değişken: Günü iki haneli formata getiriyoruz (Örn: 5 -> "05")
    final d = day.toString().padLeft(2, '0');
    // 2. Değişken: Ayı iki haneli formata getiriyoruz (Örn: 9 -> "09")
    final m = month.toString().padLeft(2, '0');
    // Birleştirilmiş standart tarih metnini döndürüyoruz
    return '$d.$m.$year';
  }

  /// 'GG.AA' formatında kompakt gün-ay tarihi döndürür (Örn: 20.10)
  String get toShortString {
    // 1. Değişken: Günü iki haneli metin yapıyoruz
    final d = day.toString().padLeft(2, '0');
    // 2. Değişken: Ayı iki haneli metin yapıyoruz
    final m = month.toString().padLeft(2, '0');
    // Gün ve ay metnini birleştirip döndürüyoruz
    return '$d.$m';
  }

  /// Ay numarasını Türkçe kısa ismine çevirir (Örn: Eki, Kas)
  String get turkishShortMonth {
    // Türkçe kısa ay isimleri dizisi (1. ay Ocak'tan 12. ay Aralık'a)
    const months = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    // Ay 1 ile 12 arasında geçerli bir değerse Türkçe kısaltmasını döndür
    if (month >= 1 && month <= 12) {
      return months[month];
    }
    // Geçersiz durumda boş metin döndür
    return '';
  }
}

/// DateTimeRange Nesneleri için TakeGO Tarih Aralığı Uzantıları
extension DateRangeExtensions on DateTimeRange {
  /// '20.10 - 25.10' formatında kompakt kiralama aralığı döndürür
  String get toShortRangeString {
    // Başlangıç ve bitiş tarihlerini kısa string formatında birleştiriyoruz
    return '${start.toShortString} - ${end.toShortString}';
  }

  /// İki tarih arasındaki toplam gün sayısını hesaplar
  int get totalDays {
    // Bitiş ve başlangıç arasındaki farkın gün cinsinden mutlak değerini döndürüyoruz
    return end.difference(start).inDays.abs();
  }
}
