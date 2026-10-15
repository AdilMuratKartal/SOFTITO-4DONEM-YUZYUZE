3 AGAC YAPISI VARDIR . BUNLAR FLUTTER DA 120 FPS OLARAK CALISMASINI SAGLAR
saniyede 60-120 kez üretilir, eksiler çöpe atılır

1. Widget Tree
#Ikselet
#Immutable(degismez)
#Cok ucuz (hafif)
#saniyede 60-120 kez COPE atilip yeniden uretilir
#Ekranda Cizim Yapmaz
#Sadece Sablon sunar
//her seferinde kendini yeniler , öncekiler silinir yerine yenileri geçer

2.Element Tree
#Yonetici & Yasayan Omurga
#Mutable (durumu ve refaransli hafizada canli tutar degisir)
#Widget ile renderobject arasindaki koordinatordur(organizasyonu sunar)
//yenilendiğinde elementler silinmezz güncel tutar
//Buton örneği verirsek: buton widgettır , içinde yazan yazılar element tir, içindeki güncellerler


//canUpdate
//HER BIR WIDGET ICIN KEY OLUSTURMALISIN,eğer içeriyi değişirse direk yeni bir widget oluşturup ona yazılıyor.
static bool canUpdate(Widget oldWidget,Widget newWidget){
    return oldWidget.runtimeType = newWidget.runtimeType && oldWidget.key == newWidget.key
}

State Yasam Dongusu

#StatefulWidget immutable {olarak degismez her rebuild'de yeniden olusturulur}
#State mutable (durumu saklar) rebuild sirasinda cope atilmaz element tarafinda devam eder.

Eger iki sinif birlesik olsaydi her rebuild esnasinda kullanici girdiler yayaclar controllerlar vb.