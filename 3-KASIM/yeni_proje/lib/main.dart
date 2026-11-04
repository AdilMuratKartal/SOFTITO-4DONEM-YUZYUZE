import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeni_proje/screens/firestore_yonetim_ekrani.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Paket import edildi bağlayam diye.


void main() async {
  //uygulama başlamadan önce firebase başlatılır. Yoksa hata alıyoruz bir motor kullanıyor diğer platformlardada çalışmasını sağlıyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '', // İhtiyaç duyulursa diye eklendi
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '', // İhtiyaç duyulursa diye eklendi
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '', // İhtiyaç duyulursa diye eklendi
    )
  );//BU ARKADAŞA FİREBASE APİ VS VEREREK YAPARSINIZ.
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
