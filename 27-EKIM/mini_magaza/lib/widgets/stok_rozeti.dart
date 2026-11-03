import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

class StokRozeti extends StatelessWidget{ // StokRozeti sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    final int stok; // int türünden stok adlı değişkenimiz

    const StokRozeti({super.key, required this.stok}); // Sabit constructor, üst sınıfa key parametresini gönderir

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        final tukendiMi = stok == 0;
        
        return Container(//sorulacak sınavda
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration:BoxDecoration(//kutu tasarımı kutu şeklinde olsun 
                color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),//px olarak % olarak veririz. Eğer hiçbir şey yazılmazsa % olarak yuvarlar.
                border:Border.all(
                    color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
                    width:0.8,
                )
            ),
            child: Text(
                tukendiMi ? "Tükendi" : "Stok:$stok",
                style:TextStyle(
                    color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
                    fontSize:11,
                    fontWeight: FontWeight.bold,
                )
            )
        );
    }    
}