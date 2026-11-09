enum IslemTipi { gelir, gider }

class Islem {
  final String id;
  final String baslik;
  final double miktar;
  final IslemTipi tip;
  final DateTime tarih;

  const Islem({
    required this.id,
    required this.baslik,
    required this.miktar,
    required this.tip,
    required this.tarih,
  });
}

//bloc yapısında 3 farklı yapı olur standarttır . isim_event isim_state isim_bloc diye üç ayrı dosya açman gerekiyor.
