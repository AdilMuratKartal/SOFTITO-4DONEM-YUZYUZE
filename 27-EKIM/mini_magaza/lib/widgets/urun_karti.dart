import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:mini_magaza/models/urun.dart';   // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import 'stok_rozeti.dart';

class UrunKarti extends StatelessWidget{  // UrunKarti sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    final Urun urun; // Urun türünden urun adlı değişkenimiz

    final VoidCallback onFavoriTiklandi; //callback fonksiyonu çalıştır diyoruz burda onFavoriTiklandi çalıştırmamızı sağlayacak VoidCallback. 
    final VoidCallback onDetayTiklandi; // VoidCallback türünden onDetayTiklandi adlı değişkenimiz

        const UrunKarti({ // Genel, sabit sınıf constructor'ı
            super.key,
            required this.urun, // urun parametresinin verilmesinin zorunlu olduğunu söylüyoruz
            required this.onFavoriTiklandi, // onFavoriTiklandi parametresinin verilmesinin zorunlu olduğunu söylüyoruz
            required this.onDetayTiklandi, // onDetayTiklandi parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        });

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
            margin: const EdgeInsets.symmetric(horizontal:16,vertical:8),//width için px yada yüzdemi söylemen lazım
            elevation: 2, // Kartın arkasına gölge veriyoruz (z koordinatı)
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            child:InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                onTap: onDetayTiklandi,
                child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.all(12.0),
                    child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                            ClipRRect(
                                borderRadius:BorderRadius.circular(10),
                                child: Image.network( // İnternet üzerinden URL ile resim çekip ekranda göstermek için
                                    urun.resimUrl,
                                    width:90,
                                    height:90,
                                    fit:BoxFit.cover,
                                    loadingBuilder:(context,child,progress){
                                        if(progress == null) return child;
                                        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                            width:90,
                                            height:90,
                                            color:Colors.grey.shade100,
                                            child: const Center(child:CircularProgressIndicator(strokeWidth:2)), // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                                        );
                                    },
                                ),
                            ),
                            const SizedBox(width:14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                child:Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                    crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                    children:[
                                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                                            children:[
                                                Text(
                                                    '${urun.kategori.ikon} ${urun.kategori.baslik}',
                                                    style:TextStyle(
                                                        color:Colors.grey.shade600,
                                                        fontSize:12,
                                                        fontWeight:FontWeight.w600,
                                                    ),
                                                ),
                                                StokRozeti(stok:urun.stokAdedi),
                                            ],
                                        ),
                                        const SizedBox(height:6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                                        Text(
                                            urun.baslik,
                                            maxLines:1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                            overflow:TextOverflow.ellipsis,
                                            style:const TextStyle(
                                                fontSize:15,
                                                fontWeight:FontWeight.bold,
                                            ),
                                        ),

                                        const SizedBox(height:4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                                        Text(
                                            urun.aciklama,
                                            maxLines:2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                            overflow:TextOverflow.ellipsis,
                                            style:TextStyle(
                                                fontSize:12,
                                                color:Colors.grey.shade700,
                                                height:1.2,
                                            ),
                                        ),
                                        const SizedBox(height:8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                                        Text(
                                            '${urun.fiyat.toStringAsFixed(2)} ₺',
                                            style:TextStyle(
                                                color:Theme.of(context).colorScheme.primary,
                                                fontSize:16,
                                                fontWeight:FontWeight.w900,
                                            ),
                                        ),
                                        
                                    ],
                                ),
                            ),
                            IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                                icon:Icon(
                                    urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                                    color:urun.favoriMi ? Colors.red : Colors.grey,
                                ),
                                onPressed:onFavoriTiklandi,
                            ),
                        ]
                    )
                )
            )
        );
    }
    
}