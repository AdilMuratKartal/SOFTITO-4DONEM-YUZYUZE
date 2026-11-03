FLUTTER YASAM DONGUSU

1.createstate() //state oluşturmak için kullanılan state. StatefulWidget ekrana çizileceği zaman çalışan ilk metoddur.

2.mounted = true //widget 'in ağaçta olup olmadığını sotgulanan bool değer. createState'ten hemen sonra bu true olur.

3.initState() //state ağaca eklenmeye başladığı sıradır state'lerin başlatılmasını sağlayan metod

4.didChangeDependencies()(widget degisimlerinde tetiklenir (Thema.of.(context) bu adimda guvenli olarak calistirilir.)) //asenkron burda

5.build(BuildContext context) (UI burda dondurur (ASLA ICINDE ASENKRON ISLEM YAPILMAZ))

6.didUpdateWidget(oldWidget) (ust ebeveyn yeni bir parametre yollandiginda calisir)

7.deactive() (agactan gecici olarak kopma)

8.dispose() (kalici olarak kapatma (controller.dispose Stream.cancel) burda yapilir.)

9.mounted == false

//veriler icin kullanicaz, ekrana renk vermek attiribute vermek vs. icinde state kullanicaz

