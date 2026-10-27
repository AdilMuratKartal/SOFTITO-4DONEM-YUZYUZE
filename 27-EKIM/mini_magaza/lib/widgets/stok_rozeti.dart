import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget{
    final int stok;

    const StokRozeti({super.key, required this.stok});

    @override
    Widget build(BuildContext context){
        final tükendiMi = stok == 0;
        
        return Container(//sorulacak sınavda
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration:BoxDecoration(//kutu tasarımı kutu şeklinde olsun 
                color: tükendiMi ? Colors.red.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),//px olarak % olarak veririz. Eğer hiçbir şey yazılmazsa % olarak yuvarlar.
                border:Border.all(
                    color: tükendiMi ? Colors.red.shade400 : Colors.greenshade400,
                    width:0.8,
                )
            ),
            child: Text(
                tükendiMi ? "Tükendi" : "Stok:$stok",
                style:TextStyle(
                    color: tükendiMi ? Colors.red.shade900 : Colors.green.shade900,
                    fontSize:11,
                    fontWeight: FontWeight.bold,
                )
            )
        )
    }    
}