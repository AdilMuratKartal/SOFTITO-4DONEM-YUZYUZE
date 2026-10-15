//Soyutlama Abstraction Kavramı
/*
//1. Adım (sözleşmeler) Contract
abstract class AutReposity{
  Future<String> login(String email, String password);
  Future<void> logout();
  bool get isAuth;
}

class FirebaseauthReposity implements AutReposity{
  @override
  Future<String> login(String email,String password) async{
    //Gerçek Firebase SDK Çarpısı
    return "firebase_token_xyz_123";
  }
  
  @override
  Future<void> logout() async{
    //Firebase logout
  }
  
  @override
  bool get isAuth => true;

}

//Test ve Offline Simülasyon
class MockAuthReposity implements AutReposity{
  @override
  Future<String> login(String email,String password) async{
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_789";
  }

  @override
  Future<void> logout() async{}

  @override
  bool get isAuth => false;

}

*/

/*
mixin Logger {
  void log(String msg) => print("LOG:$msg");
}

mixin Analytics{
  void log(String msg) => print("ANALİZ: $msg");
}

class PaymentServide with Logger, Analytics{//AsenkronYapmadığımız için işlemler senkron yani sırasyıla çalışır ve diğerini ezer
  void pay(){
    log("Ödeme Yapıldı");
  }
}

abstract class BaseWidget {
  
}

// Sadece BaseWidget ve alt sınıflarda kullanılabilir
mixin LifeLogger on BaseWidget{
  void logInit() => print("Widget Başlatıldı");
}


extension StringValidator on String{
  bool get isValidEmail{
    final emailRegex= RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String toCapitalize(){
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

void main(){
  String email ="selahaddin@kodvance.com";
  if(email.isValidEmail){
    print("Geçerli Eposta");
  }else{
    print("Geçersiz Eposta");
  }
}

*/

/*

abstract class Identifiable{
  String get id;
}

//T tipi Mutlaka Identifiable arayüzünü uygulamak ZORUNDADIR.
class GenericCache<T extends Identifiable>{
  final Map<String,T> _storage = {};

  void save (T item){
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id];

}

*/

import 'dart:async';

void main(){
  print("1.Senkron başladı");
  scheduleMicrotask((){
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  Future((){
    print("3.Standart Event Kuyruğu");
  });
  Future.microtask((){
    print("4.Future microtask çalıştı");
  });
  print("5.Senkron kod tamamlandı");//1.5.2.4.3.
}