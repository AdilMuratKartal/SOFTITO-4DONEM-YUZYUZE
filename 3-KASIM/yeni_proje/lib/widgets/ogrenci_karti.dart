import 'package:flutter/material.dart';
import 'package:yeni_proje/models/ogrenci_model.dart';

class OgrenciKarti extends StatelessWidget{
  final OgrenciModel ogrenci;
  final VoidCallback ogrenciSil;
  final VoidCallback notGuncelle;


  const OgrenciKarti({
    super.key, 
    required this.ogrenci,
    required this.ogrenciSil,
   required this.notGuncelle 
  }); 

  @override 
  Widget build(BuildContext context){
     return Dismissible(
        key: Key(ogrenci.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          ogrenciSil();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${ogrenci.adSoyad} buluttan silindi',
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: ogrenci.notu >= 80
                ? Colors.green
                : (ogrenci.notu >= 50
                      ? Colors.orange
                      : Colors.red),
            child: Text(
              '${ogrenci.notu}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            ogrenci.adSoyad,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Proje ${ogrenci.projeAdi}'),
          trailing: IconButton(
            onPressed: () => notGuncelle(),
            icon: const Icon(
              Icons.edit,
              color: Colors.amberAccent,
            ),
          ),
        ),
      );
  }
}