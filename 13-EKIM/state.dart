FLUTTER YASAM DONGUSU

1.createstate()

2.mounted = true

3.initState()

4.didChangeDependencies()(widget degisimlerinde tetiklenir (Thema.of.(context) bu adimda guvenli olarak calistirilir.)) //asenkron burda

5.build(BuildContext context) (UI burda dondurur (ASLA ICINDE ASENKRON ISLEM YAPILMAZ))

6.didUpdateWidget(oldWidget) (ust ebeveyn yeni bir parametre yollandiginda calisir)

7.deactive() (agactan gecici olarak kopma)

8.dispose() (kalici olarak kapatma (controller.dispose Stream.cancel) burda yapilir.)

9.mounted == false

//veriler icin kullanicaz, ekrana renk vermek attiribute vermek vs. icinde state kullanicaz

