import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Yumurta Maskot Duygu Durumları
enum MaskotDuygu {
  mutlu,         // Kalp gözler, tebessüm, uçan kalp
  uzgun,         // Düşük kaşlar, gözyaşı, üzgün el duruşu
  kizgin,        // Çatık kaşlar, kırmızı yanaklar, sinirli duruş
  caniSikilmis,  // Düz gözler (- _ -), yana yaslanma
  depresif,      // Yere uzanmış yatış, yağmur bulutu
  yaratici,      // Parlayan gözler, fikir ampulü
}

/// Yumurta Maskot 3D Flutter Widget'ı
/// iOS, Android, macOS, Windows ve Web üzerinde sorunsuz çalışır.
class YumurtaMaskot3DView extends StatefulWidget {
  final MaskotDuygu initialDuygu;
  final double height;
  final bool autoRotate;

  const YumurtaMaskot3DView({
    Key? key,
    this.initialDuygu = MaskotDuygu.mutlu,
    this.height = 360,
    this.autoRotate = false,
  }) : super(key: key);

  @override
  State<YumurtaMaskot3DView> createState() => _YumurtaMaskot3DViewState();
}

class _YumurtaMaskot3DViewState extends State<YumurtaMaskot3DView> {
  late MaskotDuygu _seciliDuygu;

  @override
  void initState() {
    super.initState();
    _seciliDuygu = widget.initialDuygu;
  }

  // Her duygu durumu için uygun GLB modeli veya animasyon yolu
  String _getModelPath() {
    switch (_seciliDuygu) {
      case MaskotDuygu.mutlu:
        return 'assets/models/yumurta_maskot_mutlu.glb';
      case MaskotDuygu.uzgun:
        return 'assets/models/yumurta_maskot_uzgun.glb';
      case MaskotDuygu.kizgin:
        return 'assets/models/yumurta_maskot_kizgin.glb';
      case MaskotDuygu.caniSikilmis:
        return 'assets/models/yumurta_maskot_canisikilmis.glb';
      case MaskotDuygu.depresif:
        return 'assets/models/yumurta_maskot_depresif.glb';
      case MaskotDuygu.yaratici:
        return 'assets/models/yumurta_maskot_yaratici.glb';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 3D Model Görüntüleyici Alanı
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: ModelViewer(
            key: ValueKey(_seciliDuygu), // Duygu değişince modeli yeniler
            backgroundColor: const Color(0xFFF7E5DB),
            src: _getModelPath(),
            alt: "Yumurta Maskot 3D",
            autoRotate: widget.autoRotate,
            autoRotateDelay: 1500,
            cameraControls: true, // Kullanıcı parmağıyla/mouse ile 360 döndürebilir
            shadowIntensity: 0.7,
            exposure: 1.05,
            ar: false, // İsteğe bağlı AR (Artırılmış Gerçeklik)
          ),
        ),

        const SizedBox(height: 12),

        // Duygu Seçim Kartları (Resimdeki Tasarıma Uygun)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildMoodBtn(MaskotDuygu.mutlu, "❤️ Mutlu"),
              _buildMoodBtn(MaskotDuygu.uzgun, "💧 Üzgün"),
              _buildMoodBtn(MaskotDuygu.kizgin, "😡 Kızgın"),
              _buildMoodBtn(MaskotDuygu.caniSikilmis, "😑 Canı Sıkılmış"),
              _buildMoodBtn(MaskotDuygu.depresif, "🌧️ Depresif"),
              _buildMoodBtn(MaskotDuygu.yaratici, "💡 Yaratıcı"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodBtn(MaskotDuygu duygu, String label) {
    final bool isSelected = _seciliDuygu == duygu;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF2B211E),
          ),
        ),
        selectedColor: const Color(0xFFFF7B54),
        backgroundColor: Colors.white.withOpacity(0.9),
        onSelected: (_) {
          setState(() {
            _seciliDuygu = duygu;
          });
        },
      ),
    );
  }
}

