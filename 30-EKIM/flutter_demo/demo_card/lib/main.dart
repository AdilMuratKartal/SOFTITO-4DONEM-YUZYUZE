import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

/*
color: Colors.green,//Color X değil Colors s harfi varmış
              decoration: BoxDecoration( //decoration ile yazılıyor sonra altında padding border vs yapıyorsuın
 */

void main() { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  runApp(const MyApp()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}

class MyApp extends StatelessWidget { // MyApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const MyApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
      title: 'Demo Mağaza',
      debugShowCheckedModeBanner: false,//ai dan alındı
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget { // MyHomePage sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const MyHomePage({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir


  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  int _counter = 0; // int türünden _counter değişkenimiz

  void _incrementCounter() {
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _counter++;
    });
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar:AppBar(
        title: const Text("DenemeBar"), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body:Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisAlignment: MainAxisAlignment.center,//alignment isim yanlışı yapıldı ai'dan bakıldı. paddibg alındı row vs.
          children: [
            
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              color: Colors.grey,
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.all(40.0),
              child: 
                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                  children: [Text("Adil"),]
                ),
              ),
            ),
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              color: Colors.grey,
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.all(40.0),
              child: 
                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
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
