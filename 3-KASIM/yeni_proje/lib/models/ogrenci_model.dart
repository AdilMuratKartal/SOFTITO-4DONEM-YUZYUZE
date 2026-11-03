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

class FirestoreOgrenciServisi {
  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance
      .collection('ogrenciler');
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  }) async {
    try {
      await _ogrencilerKoleksiyonu.add({
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        'kayitTarihi': FieldValue.serverTimestamp(),
      }); //firestore bizim yerimize kendi string olarak id üretiyor en az 20 karakter
      print('Öğrenci başarıyla kaydedildi');
    } catch (e) {
      print('Öğrenci ekleme Başarısız: $e');
      rethrow; //silinmezse bellekteki hatayı atar.belleği şişirmesin diye
    }
  }

  Future<void> ogrenciIdIleKaydet({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  }) async {
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad': adSoyad,
      'projeAdi': projeAdi,
      'guncelleme': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<OgrenciModel>> tumOgrencileriGetir() async {
    try {
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu
          .orderBy('notu', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => OgrenciModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      print("Veri Çekme hatası: $e");
      return [];
    }
  }

  Future<void> ogrenciNotuGuncelle(String documenId, int yeniNot) async {
    await _ogrencilerKoleksiyonu.doc(documenId).update({
      'notu': yeniNot,
      'sonDuzenleme': FieldValue.serverTimestamp(),
    });
  }

  Future<void> ogrenciSil(String documanId) async {
    await _ogrencilerKoleksiyonu.doc(documanId).delete();
    print('$documanId referanslı veri tamamen silindi');
  }
}

//set olmasının nedeni id gibi benim istediğim şekilde kaydet diyerek kaydedilim. merge:true olmasının nedeni merge etmemiz gereken bir şey varsa onunla birleştirir. yoksa bir dökümanı baştan aşağı tekrar yazar. mesela sadece ad değişti merge yaptın tüm bilgiler silindi eskiler. put set gibi. kaydetmediyse biz bu şekilde kaydediyor, tcNo sunu id olarak atayacak.
//merge: true yapmamızın endeni . bir dökümanın bir kaç alanını değiştirmek istiyorum. eğer merge demez isek yazmadığımız diğer alanlar komple silinir. ÖRNK: adSoyad, projeAdi, notu, kayitTarihi var. sadece adSoyad 'yi değiştirdik. merge demedik. o zaman projeAdi, notu, kayitTarihi silinir sadece o dökümanda adSoyad kalır(alanda gidiyormu verilerimi siliniyor onlara bak). ama merge dersek sadece adSoyad değişir diğer alanlar yerinde durur.
//FİREBASE stream kullanıyor . çift taraflı sen bir veri değiştirdiğinde sana aynı veriyi döndürüyor sende bunu ui kısmında gösteriyorsun. veri değiştimi direk haberin oluyor.

//await sonsuz döngü içerisinde kalırsan bizde yukarıda oluyor . başka örnek await http.get(uri.parse)
