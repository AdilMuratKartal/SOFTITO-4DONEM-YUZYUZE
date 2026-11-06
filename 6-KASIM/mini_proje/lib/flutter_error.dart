/*
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //init lerden emin oldupu için ordad servisimizi başlatıyoruz. ve servisimizin başladığından emin oluyoruz
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails); //flutterin iskeleti widgetların hatası durumunda çalışır widget ağacındaki
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    //uygulama kurulduğunda çalışma halindeyken herhangi bir hata oluşursa yakalar.api istekleri, mantık hataları var.
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  runApp(const SoftitoCrashApp());
}

*/

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class HataServisi {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> kullaniciTanit({
    required String uid,
    required String rol,
    required String paket,
  }) async {
    await _crashlytics.setUserIdentifier(uid);
    await _crashlytics.setCustomKey('kullanici_rolu', rol); //kullanici_rolu atamak zorunda değilsin, farklı kategoride belirlemek için yapabiliriz . örnek çoklu abonelik olan bir sistemde satıcı alıcı vs. giriş tipleri.
    await _crashlytics.setCustomKey('uyelik_tipi', paket);
  }

  void ayakIziBirak(String adim) {
    _crashlytics.log('kullanıcı işlemi: $adim'); //kullanıcıların hangi sayfada olduğunuda loglamayıda eklersek hata ayıklama esnasında işimizi kolaylaştırır. her bir yaptığı işlemi kaydediyoruz
  }

  Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async {
    await _crashlytics.recordError(
      hata,
      stack,
      fatal: true,
    ); //buda logları sessiz bir şekilde akışı etkilemeyecek şekilde yapıyor.
  }

  ElevatedButton(
    onPressed: (){
      FirebaseCrashlytics.instance.crash();
    },
    child:const Text('Çökme tESTİ göNDER'),
  ),
  

}



//Kullanıcının hangi sayfada olduğuna göre özel hata kaydı alabiliriz. uygulama içinde yaptığı her eylemi mesela butona tıklama vs. bunların kayıtlarını alıp crashlytics üzerinden görebiliriz.
