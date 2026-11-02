import 'package:flutter/material.dart';

class HataliveDogruRow extends StatelessWidget{
    const HataliveDogruRow({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text("Row ve Layout"),
            ),
            body:Padding(
                padding: const EdgeInsets.all(10),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                        const Text( 
                            'Hatalı Yapı: A overflowed by *** pixels(sarı siyah şerit)',
                            style: TextStyle(fontWeight:FontWeight.bold,color:Colors.red),
                        ),
                        const SizedBox(height:8),//pixel vs giremeyez bunlar için ayrı style açman gerekiyor. şuan yüzdelik hesaplıyor

                        Container(//hatalı fonksişyon text uzayıp ekran dışına taşıyor. sarı çizgili hata
                            color:Colors.amber.shade100,
                            child:Row(
                                children:[
                                    const Icon(Icons.warning, color:Colors.red),
                                    const SizedBox(width:8),
                                    const Text('Kısa Metin (hata vermez ama uzarsa Render Patlar)')
                                ],
                            ),
                        ),

                        const SizedBox(height:32),
                        const Text('Doğru Yapı: Flexible ve expanded ile sınırlandırılmıştır.',
                        style:TextStyle(fontWeight:FontWeight.bold,color:Colors.green)),//burda text'i expandede flexible vs. ile esneterek hata vermesini engelliyoruz doğru gfonksiyon.

                        Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color:Colors.green.shade50,
                                borderRadius:BorderRadius.circular(8),
                                border:Border.all(color:Colors.green),
                            ),
                            child:Row(
                                children:[
                                    const CircleAvatar(
                                        backgroundColor:Colors.green,
                                        child:Icon(Icons.check,color:Colors.white),
                                    ),
                                    const SizedBox(width:12),

                                    Expanded(
                                        child:Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children:const [
                                                Text('Softito 4.Dönem Mobil Standartı',style:TextStyle(fontWeight:FontWeight.bold)),
                                                SizedBox(height:4),
                                                Text('Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez', 
                                                style:TextStyle(color:Colors.black87)),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        
                    ],
                ),


            )
        )
    }
}