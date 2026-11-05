import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/storage_ve_fcm_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //initState'lerden emin ol diyor onlardada servisler çalıştığı için servisler çalışmadan widgetlar gelmiyor.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  runApp(const SoftitoDemoApp());
}

class SoftitoDemoApp extends StatelessWidget {
  const SoftitoDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sofito Storage & FCM Demo App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0, 0, 0, 0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: StorageVeFcmEkrani(),
    );
  }
}
