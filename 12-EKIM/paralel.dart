/*
Future<void> fetchDashboardData() async{
  try{
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ],eagerError: true);

    print("Tüm veriler geldi $result");
  }catch (e){
    print("İsteklerden Biri başarısız oldu");
  }
}
*/

//Future: Tek bir kere veri çekeceğimiz zaman kullanılır ya hata yada değer dönüp bititir.
//Stream: Bir boru hattı şeklinde çalışır (pipe) , Zaman içinde 1 10 100 yada sonsuz sayıda veri akılı sağlanabilir.
//(Borsa fiyatları GPS konum güncelleme,Firebase canlı dinleme)

import 'dart:async';

void main(){
  //controller oluşturma
  final controller = StreamController<int>();
  
  // dinleyici(listener) bağlama
  final subscription = controller.stream.listen(
    (data) => print("Yeni Veri: $data"),
    onError: (err) => print("Hata oluştu: $err"),
    onDone: () => print("Yayın Tamamlandı"),//Veri akışı sağlanmadığı sıra çalışır.
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();//asBroadcastStream çoklu listener kullanabilmemizi sağlar şuan hata veriyor çünkü controller da iki ayrı listener var biri tekli olan biri çoklu olan tekli olan diyorki birden fazla listener var.
  broadcastStream.listen((d)=> print("UI Ekranı: $d"));
  broadcastStream.listen((d)=> print("Analitik Servisi Ekranı: $d"));

  controller.close();

}