import 'package:flutter/material.dart';
import 'package:yeni_proje/services/firestore_ogrenci_servisi.dart';

class OgrenciFormu extends StatefulWidget {
  final FirestoreOgrenciServisi _ogrenciServisi;
  const OgrenciFormu({super.key, required this._ogrenciServisi});

  @override
  State<OgrenciFormu> createState() => _OgrenciFormuState();
}

class _OgrenciFormuState extends State<OgrenciFormu> {
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  void _yeniOgrenciKaydet() {
    final adSoyad = _adSoyadKontrolcusu.text.trim();
    final proje = _projeKontrolcusu.text.trim();
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

    if (adSoyad.isEmpty || proje.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen ad soyad ve proje adını giriniz")),
      );
      return;
    }
    widget._ogrenciServisi.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);//widget.field 
    _adSoyadKontrolcusu.clear();
    _projeKontrolcusu.clear();
    _notKontrolcusu.clear();
  }

  @override
  void dispose() {
    _adSoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    super.dispose();
  }//firestore stream'ı burda değil burası ekrana yazma yeri başka yerde dispose yada clear diyeceğim

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _adSoyadKontrolcusu,
          decoration: const InputDecoration(
            labelText: 'Ad-Soyad',
            prefixIcon: Icon(Icons.person),
          ),
        ),

        const SizedBox(height: 8),
        TextField(
          controller: _projeKontrolcusu,
          decoration: const InputDecoration(
            labelText: 'Proje adı',
            prefixIcon: Icon(Icons.folder),
          ),
        ),

        const SizedBox(height: 8), //bunun altına proje textfield'ını eklicen taşma durumları için expanded'a sarıcan unutma
        SizedBox(
          width: 90,
          child: TextField(
            controller: _notKontrolcusu,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Not",
              prefixIcon: Icon(Icons.grade),
            ),
          ),
        ),

        const SizedBox(
          height: 12,
        ), //expanden gelince burası doğru sırada olacak
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.brown,
            minimumSize: const Size.fromHeight(44),
          ),
          onPressed: _yeniOgrenciKaydet,
          icon: const Icon(Icons.cloud_upload),
          label: const Text("Buluta Kaydet"),
        ),
      ],
    );
  }
}
