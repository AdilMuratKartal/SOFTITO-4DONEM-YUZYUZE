// Mülakat İçin önemli: Sealed sınıflar dışarıdan extend edilmez switch içinde tüm alt sınıflar tüketilmek zorundadır.

sealed class OdemeDurumu {}

class OdemeBasarili extends OdemeDurumu{
    final ({String referansKodu,double tutar}) veri;
    OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu{
    final String hataNedeni;
    OdemeBasarisiz(this.hataNedeni);
}//durum classlarımız kendi durumlarını tutarlar. bunları döndürürüz. birden fazla kullanım durumlarında state'imizi diğer kısımlardada gösterebiliyoruz.

abstract class IBankaServisi{//interface implements
    Future<OdemeDurumu> odeme({required double miktar});//örnke bankada protokl durumlarında miktar gelmeden ödeme olmayacak gibi
}

//kalıtım yapmadan başka bir sınıfa yetenek kazandırma mixin with ile sınıf ilişkisi sağlanır
mixin GuvenlikDenetemiMixin{
    bool tokenGecerliMi(String token){
        return token.isNotEmpty && token.length >=32;
    }//şartlar sağlarsa true, sağlamazsa false
}

mixin AuditLogMixin{
    void islemKaydet(String mesaj){
        final zaman = DateTime.now().toIso8601String();
        print('Log - $zaman: $mesaj');
    }
}

class GarantiBankasiServisi with GuvenlikDenetemiMixin,AuditLogMixin implements IBankaServisi{
    final String apiAnahtari;

    GarantiBankasiServisi({required this.apiAnahtari});

    @override
    Future<OdemeDurumu> odeme({required double miktar}) async {
        if(!tokenGecerliMi(apiAnahtari)){
            islemKaydet('Ödeme Reddedildi.Geçersiz Api Anahtarı');
            return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token');
        }

        await Future.delayed(const Duration(milliseconds:1000));//gerçek dünya simülesi için 1 saniye bekle

        islemKaydet('$miktar tutarındaki ödeme Garanti Bankası Tarafından Onaylandı');

        return OdemeBasarili((referansKodu:'GRNT-${DateTime.now().millisecondsSinceEpoch}', tutar: miktar));//işlemin bir kaç mili saniye öncesinin bile alıyoruz. ({}) records tipinde 
    }

    void odemeSonucunuEkranaBas(OdemeDurumu durum){
        final mesaj = switch (durum){
            OdemeBasarili b => 'Ödeme Başarılı Ref:${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
            OdemeBasarisiz h => 'Ödeme Başarısız. Gerekçe: ${h.hataNedeni}',
        };
        print(mesaj);
    }
}

void main() async {
    const String apiKey = "kjassaflkasmndasjhdbaskjdnLKHASGFUWYEBFWQKDNQW891249812";
    const String apiKey2 = "hhavvwu";
    final GarantiBankasiServisi grbs = GarantiBankasiServisi(apiAnahtari: apiKey);
    final OdemeDurumu durum = await grbs.odeme(miktar:500);
    grbs.odemeSonucunuEkranaBas(durum);
    print("-----------------------------------------------------------------------------------------");
    final GarantiBankasiServisi grbs2 = GarantiBankasiServisi(apiAnahtari: apiKey2);
    final OdemeDurumu durum2 = await grbs2.odeme(miktar:2000);
    grbs2.odemeSonucunuEkranaBas(durum2);

}