import 'package:flutter/material.dart';
import 'package:tekrar_proje_2/models/urun_model.dart';
import 'package:tekrar_proje_2/services/i_urun_servisi.dart';

class UrunListeEkrani extends StatefulWidget{
    const UrunListeEkrani({super.key});

    @override
    State<UrunListeEkrani> createState() => _UrunListesiEkraniState();ß
}

class _UrunListesiEkraniState extends State<UrunListeEkrani>{
    final IUrunServisi _urunServisi = CanliApiUrunServisi();
    final List<Urun> _tumUrunler = [];
    final yukleniyorMU =false;

    @override 
    void initState(){
        super.initState();
        _urunleriYukle();

    }

    Future<void> _urunleriYukle() async{
        setState({
            yukleniyorMU= true;
        })

        final urunler = await _urunServisi.urunleriGetir();

        if(mounted){
            setState({
                _tumUrunler = urunler;
                yukleniyorMU = false;
            })
        }
    } 

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                       children:[
                            Text(
                                "Merhaba"
                            )
                        ]
                    )
                )
            )
        )
    }

}