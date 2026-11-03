///KATEGORİ DURUMLARINI EKLEMEDİK ŞİMDİLİK BEKLİYOR.
///BİRDE SAYFADA AŞAĞI İNDİKÇE TEKRAR BÜTÜN SAYFA YÜKLENİYOR ONADA BAKMAM LAZI .M BIRAKTIM SONRAYA
///BİRDE TIKLANMA DURUMLARINDA BİRŞEY YOKTUR SADE ZİYA, INKWELL BOŞA GİTTİ YANİ

import 'package:flutter/material.dart';
import 'package:tekrar_proje_2/models/urun_model.dart';
import 'package:tekrar_proje_2/services/i_urun_servisi.dart';

import '../widgets/urun_karti.dart';

class UrunListeEkrani extends StatefulWidget {
  const UrunListeEkrani({super.key});

  @override
  State<UrunListeEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListeEkrani> {
  final IUrunServisi _urunServisi = CanliApiUrunServisi();
  List<UrunModel> _tumUrunler = [];
  bool _yukleniyorMu = false;

  @override
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyorMu = true;
    });

    final urunler = await _urunServisi.urunleriGetir();

    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        _yukleniyorMu = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Test Api Sayfasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "Google Sans",
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())
                : _tumUrunler.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Urunler Bulunamadı',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tumUrunler.length,
                    itemBuilder: (BuildContext context, int index) {
                      final urun = _tumUrunler[index];
                      return UrunKarti(urun: urun);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
