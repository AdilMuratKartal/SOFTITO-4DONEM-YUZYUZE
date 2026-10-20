// Flutter temel materyal renk ve arayüz kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';

/// TakeGO Projesi Kurumsal Otomotiv Renk ve Boyut Sabitleri (Cyber Drive Paleti)
///
/// Bu sınıf; TakeGO'nun "Clean Mobility Light" ve "OLED Cockpit Dark"
/// renk şemalarının sabit kodlarını ve arayüzde taşmaları (overflow)
/// önleyen sabit görsel boyutlarını barındırır.
class AppColors {
  // Özel kurucu: Bu sınıf yalnızca statik sabitler barındırır, örneklenemez.
  AppColors._();

  // ---------------------------------------------------------------------------
  // GÜNDÜZ MODU: Clean Mobility Light Renkleri (Gündüz Sürüşü)
  // ---------------------------------------------------------------------------

  /// Temiz asfalt grisi / kırık beyaz - Gündüz modu Scaffold arka plan rengi
  static const Color lightBackground = Color(0xFFF6F8FA);

  /// Saf beyaz - Gündüz modu kart, panel ve modal yüzey dolgu rengi
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Elektrik mavisi - Gündüz modu birincil vurgu rengi (Güven ve teknoloji hissi)
  static const Color lightPrimary = Color(0xFF0066FF);

  /// Enerji yeşili - Gündüz modu onay, aktif kilit ve benzin göstergesi rengi
  static const Color lightSecondary = Color(0xFF00D084);

  /// Derin antrasit siyah - Gündüz modu birincil başlık ve araç modeli metin rengi
  static const Color lightTextPrimary = Color(0xFF111827);

  /// Orta ton nötr gri - Gündüz modu ikincil detaylar ve fiyat birimi metin rengi
  static const Color lightTextSecondary = Color(0xFF6B7280);

  /// İnce kart kenarlık ve ayırıcı çizgi rengi
  static const Color lightBorder = Color(0xFFE5E7EB);

  /// Açık metalik gri - Fotoğraf yokken veya yüklenirken gösterilen silüet dolgusu
  static const Color lightImagePlaceholder = Color(0xFFE2E8F0);

  /// Amber sarısı - Gündüz modu uyarı ve dikkat rozeti rengi
  static const Color lightWarning = Color(0xFFF59E0B);

  /// Kırmızı - Gündüz modu hata, kilitli durum ve kritik alarm rengi
  static const Color lightError = Color(0xFFEF4444);

  // ---------------------------------------------------------------------------
  // GECE MODU: OLED Cockpit Dark Renkleri (Gece Sürüşü)
  // ---------------------------------------------------------------------------

  /// Derin kabin siyahı - Gece sürüşünde gözü yormayan OLED zemin arka planı
  static const Color darkBackground = Color(0xFF0B0E14);

  /// Koyu kokpit antrasiti - Gece modu kart ve panel yüzey dolgu rengi
  static const Color darkSurface = Color(0xFF161B26);

  /// Neon elektrik mavisi - Karanlıkta yüksek kontrastla okunan birincil mavi
  static const Color darkPrimary = Color(0xFF2F80ED);

  /// Fosforlu yeşil - Gece modunda aktif kilit, şarj ve başarı göstergesi
  static const Color darkSecondary = Color(0xFF10B981);

  /// Yumuşak saf beyaz - Gece modu birincil başlık metin rengi
  static const Color darkTextPrimary = Color(0xFFF9FAFB);

  /// Metalik gümüş gri - Gece modu ikincil detay ve açıklama metin rengi
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  /// Loş kokpit çerçevesi - Gece modu ince kart ve ayırıcı kenarlık rengi
  static const Color darkBorder = Color(0xFF242C3D);

  /// Koyu antrasit - Gece modunda fotoğrafsız kart silüet dolgu rengi
  static const Color darkImagePlaceholder = Color(0xFF1F2937);

  /// Parlak kehribar - Gece modu uyarı ve canlı asistan bildirim rengi
  static const Color darkWarning = Color(0xFFFBBF24);

  /// Parlak kırmızı - Gece modu hata ve tehlike bildirim rengi
  static const Color darkError = Color(0xFFF87171);

  // ---------------------------------------------------------------------------
  // GÖRSEL VE KART BOYUT STANDARTLARI (RenderFlex Overflow Önleme)
  // ---------------------------------------------------------------------------

  /// İlan kartlarındaki araç resmi için sabit yükseklik (16:9 alternatifi)
  static const double listingImageHeight = 180.0;

  /// İlan detay sayfasındaki kapak resmi için sabit yükseklik
  static const double detailImageHeight = 260.0;

  /// Yeni ilan verme ekranındaki fotoğraf yükleme alanı sabit yüksekliği
  static const double uploadImageHeight = 140.0;

  /// Kartların ve görsel kutularının standart köşe yuvarlaklık yarıçapı
  static const double cardBorderRadius = 16.0;

  /// 16:9 sabit ekran ve ilan kartı görsel oranı
  static const double standardAspectRatio = 16.0 / 9.0;
}
