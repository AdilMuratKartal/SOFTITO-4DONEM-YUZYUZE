import 'package:flutter/material.dart';

import '../models/urun_model.dart';

class UrunKarti extends StatelessWidget {
  final UrunModel urun;
  const UrunKarti({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      elevation: 2, //cartın arkasına gölge veriyor. z koordi natı
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {////EĞER ONTAP VERİRSEN INKWWELL SU DALGASI VE TIKLANILABİLİR EFEKTLERİNİ VERİYOR. VARSAYILAN YOK
          print("${urun.baslik} Kart Tıklanıldı");
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                urun.resimUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: 15),
              Expanded(
                //metinler taşıp patlamasın diye
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      urun.kategori,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      urun.baslik,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      '${urun.fiyat.toString()} ₺', // as String dönüşümü covariant gibi alt sınıfa dönüştürme durumlarında kullanılıyormuş tip ancak bu kadar değişiyor
                      style: TextStyle(
                        color: Colors.blueAccent.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
