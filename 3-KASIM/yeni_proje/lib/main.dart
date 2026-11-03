import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeni_proje/firestore_yonetim_ekrani.dart';

void main() async {
  //uygulama başlamadan önce firebase başlatılır. Yoksa hata alıyoruz bir motor kullanıyor diğer platformlardada çalışmasını sağlıyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const SoftItoFireStoreUygulamasi());
}

class SoftItoFireStoreUygulamasi extends StatelessWidget {
  const SoftItoFireStoreUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cloud FireStore",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const FirestoreYonetimEkrani(),
    );
  }
}
