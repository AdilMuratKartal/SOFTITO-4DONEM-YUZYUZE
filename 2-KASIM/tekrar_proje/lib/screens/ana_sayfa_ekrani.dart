class AnaSayfa extends StatelessWidget{ // AnaSayfa sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    const AnaSayfa({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
            appBar: AppBar(), // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
            body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment : CrossAxisAlignment.center,
                children:[
                    Card(), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                    Card(), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                    Card(), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                ]
            )
        )
    }
}