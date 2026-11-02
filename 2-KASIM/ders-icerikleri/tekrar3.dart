import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SepetKontrolu{
    static final SepetKontrolu ornek = SepetKontrolu._dahili();
    SepetKontrolu._dahili();
    final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);
    void sepeteEkle(){
        urunSayisi.value++;
    }
    void sepetSifirla(){
        urunSayisi.value = 0;
    }
}

final GoRouter uygulamaRotalari = GoRouter(
    initialLocation:'/anasayfa',
    routes:[
        ShellRouter(
            builder(BuildContext context, GoRouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi: child,);
            },
            routes:[
                GoRoute(
                    path:'/vitrin',
                    builder:(context,state)=> const VitrinEkrani(),
                ),
                GoRoute(
                    path:'/profil',
                    builder:(context,state)=> const ProfilEkrani(),
                ),
                
            ]
        )
    ]
)

//widget'i tamamen boyamadan sadece bir kısmı bir veriyi değiştirmek için stateful gerekmez. Widget'in tamamen değişmez sadece içindeki veriler değişebiliyor(sayfalarda genellikle olur sayfa değişir widget değişmez gibi. yada ağaç değişmez meyvesi değişir gibi).
class AnaKasaEkrani extends StatelessWidget{
    final Widget ekranGovdesi;
    const AnaKasaEkrani({super.key,required this.ekranGovdesi});

    @override 
    Widget build(BuildContext context){
        return Scaffold(
            body:ekranGovdesi,
            bottomNavigationBar: NavigationBar(
                selectedIndeks: _aktifIndexiBul(context),
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
        final String konum = GoRouterState.of(context).uri.toString()//bulunduğum konumdan al
        if(konum.startWith('/profil')) return 1;
        return 0 ;
    }


}

  class VitrinEkrani extends StatelessWidget{
        const VitrinEkrani({super.key});
        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(title:const Text('Canlı Vitrin(ValueNotifier)')),
                body:Center(
                    child:ElevatedButton.icon(
                        onPressed:(){
                            SepetKontrolu.ornek.sepeteEkle();
                        }
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Sepete Ürün Ekle(+1)'),
                    ),
                ),
            );
        };
    };

    class ProfilEkrani extends StatelessWidget{
        const ProfilEkrani({super.key});
        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar:AppBar(title:const Text("Kullanıcı Profili")),
                body:Center(
                    child:TextButton(
                        onPressed:()=> SepetKontrolu.ornek.sepetSifirla();
                        child: const Text('Sepeti Temizle(0 yap)'),
                    ),
                ),
            );
        };
    }
