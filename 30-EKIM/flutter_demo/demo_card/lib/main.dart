import 'package:flutter/material.dart';

/*
color: Colors.green,//Color X değil Colors s harfi varmış
              decoration: BoxDecoration( //decoration ile yazılıyor sonra altında padding border vs yapıyorsuın
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Mağaza',
      debugShowCheckedModeBanner: false,//ai dan alındı
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: const Text("DenemeBar"),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,//alignment isim yanlışı yapıldı ai'dan bakıldı. paddibg alındı row vs.
          children: [
            
            Container(
              color: Colors.grey,
              child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Adil"),]
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Adil"),]
                ),
              ),
            ),

          ],
        ),
      ),
    );
  
  }
}
