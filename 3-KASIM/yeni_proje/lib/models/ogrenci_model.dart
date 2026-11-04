import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciModel {
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModel({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    //snapshot anlık veri tabanını yedek alır kopayasını veiryor bize kendisini duruyor.
    final veri = doc.data() as Map<String, dynamic>? ?? {};
    return OgrenciModel(
      id: doc.id, //id'yi sistem otomatik atadığı için bir sonrakini otomatik ataması için doctan yapıyoruz.
      adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci Shad",
      projeAdi: veri['projeAdi'] as String? ?? "Henüz Shad'ın Projesi yok",
      notu: (veri["notu"] as num?)?.toInt() ?? 0,
      kayitTarihi:
          (veri['kayıtTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}


