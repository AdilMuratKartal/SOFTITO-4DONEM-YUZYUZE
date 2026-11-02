import 'package:flutter/material.dart';
import '../controllers/sepet_controller.dart';

class ProfilEkrani extends StatelessWidget{
    const ProfilEkrani({super.key});
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(title:const Text("Kullanıcı Profili")),
            body:Center(
                child:TextButton(
                    onPressed:()=> SepetKontrolu.ornek.sepetSifirla(),
                    child: const Text('Sepeti Temizle(0 yap)'),
                ),
            ),
        );
    }
}