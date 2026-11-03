class Asset {//Assets sınfın açılışı uygulamada kullanılacak verinin model'i şemasıdır
  final String symbol;//string türünden symbol adlı değişken
  final String name;//string türünden name adlı değişken
  final double price;//double türünden price adlı değişken
  final double change24h;//double türünden change24h adlı değişken
  final double balance;//double türünden balance adlı değişken

  const Asset({//genel, sabit sınıf constructor'ı   
    required this.symbol,//symbol değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.name,//name değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.price,//price değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.change24h,//change24h değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.balance,//balance değişkenin girilmesi zorunlu olduğunu söylüyoruz
  });
}
