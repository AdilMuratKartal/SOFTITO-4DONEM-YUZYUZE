import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

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
