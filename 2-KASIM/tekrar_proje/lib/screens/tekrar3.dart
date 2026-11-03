import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:go_router/go_router.dart';
import 'profil_ekrani.dart';
import 'vitrin_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../controllers/sepet_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

final GoRouter uygulamaRotalari = GoRouter(
    initialLocation:'/anasayfa',
    routes:[
        ShellRoute(
            builder:(BuildContext context, GoRouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi: child);
            },
            routes:[
                GoRoute(
                    path:'/anasayfa',
                    builder:(context,state)=> const AnaKasaEkrani(ekranGovdesi:Text("Ana Sayfa")),
                ),
                GoRoute(
                    path:'/vitrin',
                    builder:(context,state)=> const VitrinEkrani(),
                ),
                GoRoute(
                    path:'/profil',
                    builder:(context,state)=> const ProfilEkrani(),
                ),
                
            ],
        ),
    ],
);

//widget'i tamamen boyamadan sadece bir kısmı bir veriyi değiştirmek için stateful gerekmez. Widget'in tamamen değişmez sadece içindeki veriler değişebiliyor(sayfalarda genellikle olur sayfa değişir widget değişmez gibi. yada ağaç değişmez meyvesi değişir gibi).
class AnaKasaEkrani extends StatelessWidget{ // AnaKasaEkrani sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    final Widget ekranGovdesi; // Widget türünden ekranGovdesi adlı değişkenimiz
    const AnaKasaEkrani({super.key,required this.ekranGovdesi}); // Sabit constructor, üst sınıfa key parametresini gönderir

    @override  // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
            body:ekranGovdesi,
            bottomNavigationBar: NavigationBar(
                selectedIndex: _aktifIndexiBul(context),
                onDestinationSelected: (yeniIndeks){
                    if(yeniIndeks == 0)context.go('/vitrin');//iki rota var diye ifelse yapıyoz yoksa switch
                    if(yeniIndeks == 1)context.go('/profil');//1000 yol var diyelim veri tabanınından çekip map'ile o(1) ile bulabilirsin.
                },
                destinations:[
                    const NavigationDestination(icon:Icon(Icons.store),label:'Vitrin'),
                    NavigationDestination(
                        icon: ValueListenableBuilder<int>(
                            valueListenable: SepetKontrolu.ornek.urunSayisi,
                            builder:(context,sayi,child){
                                return Badge(
                                    label: Text('$sayi'),
                                    isLabelVisible: sayi > 0 ,//burda 0'dan büyükse görünür yap diyoruz.
                                    child: const Icon(Icons.person),
                                );
                            },
                        ),
                        label: 'Profil',
                    ),
                ],
            ),
        );
    }

    int _aktifIndexiBul(BuildContext context){
        final String konum = GoRouterState.of(context).uri.toString();//bulunduğum konumdan al
        if(konum.startsWith('/profil')) return 1;
        return 0 ;
    }

}


