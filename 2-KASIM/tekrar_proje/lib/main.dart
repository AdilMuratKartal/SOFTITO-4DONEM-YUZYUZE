import 'package:flutter/material.dart';
import 'screens/tekrar3.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: uygulamaRotalari,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
