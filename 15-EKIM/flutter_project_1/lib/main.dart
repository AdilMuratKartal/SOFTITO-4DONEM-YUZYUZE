import 'package:flutter/material.dart';//flutter'ın hazır widgetları bulunduran tasarımlı, paketi
import 'screens/01_layout_screen.dart';//sayfanın düzenini belli eden dart'ı import ediyoruz
import 'screens/02_markets_list_screen.dart';//2. sayfaynı tasarımını import ediyoruz
import 'screens/03_transfer_form_screen.dart';//3. sayfaynı tasarımını import ediyoruz

void main() {//flutter'ın çalıştırıdığı ana fonkyion
  runApp(const DtmMasterApp());//runApp ile mobil uygulamanın ana widget'ını yüklüyoruz ve uygulamamızı çizim döngüsünü başlatıyoruz burda kök widget'ımız DtmMasterApp() widget'ı olarak belirliyoruz.
}

class DtmMasterApp extends StatelessWidget {//kök widget'ımızı statelesswidget olarak başlatıyoruz.
  const DtmMasterApp({//statelesswidget'an bir key alıp bu sabit constructor'ımıza atıyoruz
    super.key,//satetlesswidget'imizdan aldığımız key
  }); // super verdiğimiz Stateless'e key i gönderir.

  @override//build metodunun üzerine yazabilmek için override ediyoruz
  Widget build(BuildContext context) {//WİDGET'Imızın tasarımını yapacağımız build metodumuz ve ona girdi olarak context veriyoruz
    return MaterialApp( //flutter'ın material paketini uygulamak için ana widget olan MaterialApp ile return'luyoruzki tasarımlarımız çalışsın
      debugShowCheckedModeBanner: false,//uygulamanın sağında yazan debug yazısını kaldırır
      title: "DTM Flutter Sınıfı",//uygulama başlığı
      theme: ThemeData(//uygulamanın tema verilerini girdiğimiz ThemeData() sınıfımızı açıyoruz
        useMaterial3: true,//güncel tasarım dili material design 3 standartlarını aktifleştirmek için true yapıyoruz
        colorScheme: ColorScheme.fromSeed(//uygulama renk paletini ayarlıyoruz , diğer widgetlarda duruma göre burdan yararlanır.
          seedColor: const Color(0xFF6366F1),//renk paletimizde ana rengi belirliyoruz
          brightness: Brightness.light,//aydınlık modunu ise light olarak açık olarak belirliyoruz
        ),
      ),
      home: const LiveCanvasScreen(),//uygulama açıldığında çalışacak olan LiveCanvasScreen widget'ımız olduğunu belirtiyoruz
    );
  }
}

class LiveCanvasScreen extends StatefulWidget {
  const LiveCanvasScreen({super.key});

  @override
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState();
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FaFC),
      appBar: AppBar(
        title: const Text(
          "DTM Canlı Arayüz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {},
          ),
        ],
      ), // AppBar
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            LayoutStylingScreen(),
            MarketsGridListScreen(),
            TransferFormScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Piyasalar',
          ),
          NavigationDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send),
            label: 'Transfer',
          ),
        ],
      ),
    );
  }
}
