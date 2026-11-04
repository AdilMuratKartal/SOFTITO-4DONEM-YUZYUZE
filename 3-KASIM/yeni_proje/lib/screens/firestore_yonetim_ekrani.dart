import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeni_proje/models/ogrenci_model.dart';
import 'package:yeni_proje/services/firestore_ogrenci_servisi.dart';
import 'package:yeni_proje/widgets/ogrenci_karti.dart';
import 'package:yeni_proje/widgets/ogrenci_formu.dart';

class FirestoreYonetimEkrani extends StatefulWidget {
  const FirestoreYonetimEkrani({super.key});

  @override
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  final FirestoreOgrenciServisi _servis = FirestoreOgrenciServisi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Firestore ekranı"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    OgrenciFormu(ogrenciServisi: _servis),
                    const Divider(thickness: 2), //araya çizgi atıyor
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        //anlık veri silme eklemeyi canlı olarak ekranda görebşlmek için bir akış olması ve bunun dinlenmesi lazım ondan streambuilder yapıp anlık olarak ekranda gğncellencek
                        stream: FirebaseFirestore.instance
                            .collection('ogrenciler')
                            .orderBy('notu', descending: true)
                            .snapshots(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              //orderBy sorgusu query sorgusu attığımız için QuerySnapshot tipinde yazıyor. verilerimiz çekilirken programı kitlemesin diye AsyncSnapshot kullanıyoruz.
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Bulut Hatası:${snapshot.error}"),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Henüz bulutta kayıtlı öğrenci yoktur.",
                                  ),
                                );
                              }
                              final List<DocumentSnapshot> dokumanlar =
                                  snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: dokumanlar.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final doc = dokumanlar[index];
                                  final ogrenci = OgrenciModel.fromFireStore(
                                    doc,
                                  );

                                  return OgrenciKarti(
                                    ogrenci: ogrenci,
                                    ogrenciSil: () =>
                                        _servis.ogrenciSil(ogrenci.id),
                                    notGuncelle: () =>
                                        _notGuncelleDialog(ogrenci),
                                  );
                                },
                              );
                            },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _notGuncelleDialog(OgrenciModel ogrenci) {
    final TextEditingController _yeniNotKontrolcusu = TextEditingController(
      text: ogrenci.notu.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            icon: Icon(Icons.edit),
            title: Text("Yeni Not Değerini Giriniz"),
            content: TextField(
              controller: _yeniNotKontrolcusu,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "0-100 Arası Değer Giriniz",
                prefixIcon: Icon(Icons.grade),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final yeniNot = int.tryParse(_yeniNotKontrolcusu.text.trim());
                  if (yeniNot != null && yeniNot >= 0 && yeniNot <= 100) {
                    _servis.ogrenciNotuGuncelle(ogrenci.id, yeniNot);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${yeniNot} Değeriniz Başarıyla Kaydedildi',
                        ),
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Lütfen 0-100 arası tam sayı bir değer giriniz',
                      ),
                    ),
                  );
                },
                child: Text(
                  "Onayla",
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "İptal",
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ),
            ], //children
          ),
        );
      }, //builder
    ); //showDialog
  }
}

//*
//Notlar
//Controller çalışma zamanında derliyoruz final gibi. o yüzden onu sormalayan const Padding gibi constlar bunu derlemede sabitler o yüzden hata verir const kalkmalı.
//
// */

/*
YAPILACAKLAR
1 expanded içinde projeadi ınputu açılacak
2 _notGuncelleDialog fonksiyonu yazılacak
3 sayfalar parse edilecek ve sistem çalışır hale getirilecek
4 yarın rastgele biri seçilip ekranında sınıfa gösterecek
5. _projeKontrolcusu eklencek
*/
