Const

1. ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2. Neden kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widet'ı yeniden üretmez Cpu ve pil tasarrufu sağlar.

final

1. ne işe yarar: çalışma zamanında değeri bir kez ataanan ve sonrasında referansı asla değiştirilmeyen değişkenler
   \*\* const ve final farkı: const derlenirken bilinmek zorunda (const pi=3.14) final ise çalışma anında belirlenebilir . final saat=DateTime.now(); Model sınıflarında alanlar her zaman final olmalıdır.

late

1. ne işe yarar: değişen tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlaycağı zaman kullanılır.

required
1)ne işe yarar: isimlendirilmiş parametrelerde o parametrenin(değişkenin) zorunlu olduğunu belirtir.

@override
1)ne işe yarar: alt sınıfın , üst sınıftan devraldığı metodu ezdiğini belirtir.
2)faydası: eğer üst metod adını yanlış yazarsanız (örek builds yazarsanız) derleyici @override sayesinde bunu anında hata oalrak yakalar.

Null-aware operatörleri (? ?? !)
?. - place?.title -> eğer place null ise hata veremk direkt null olarak döner
?? - if null : final id = state.userID ?? 10; ->sol taraf null ise sağdaki (hardcode olan değer )otomatik olarak atanı
! (null /force): final id= state.userId ! -> Bu kod derleyiciye bana güven bu değer o anda kesinkikle nul değil verir. eğer null gelir ise uygulama nında çöker. (çok dikkatlı kullanulmalı)

Spread operatörü (...)

1. ne işe yarar: bir listenin elemanlarını tek tek çıkartııp bulundupu üst listenin içine ekler . column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
   ...listeAdi.map((p)=>\_buildCard(p))

initState()
Ne zaman çalışır : Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır
Ne yapar: ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: içinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.

didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek : Theme.of(context)) değiştiğinde otomatik tetikler.
Ne yapar : BuildContext güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.

build(BuildContext context)
Ne zaman çalışır : Sayfa ilk açıldığında, setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır. Sadece UI döndürülmelidir.

dispose()
Ne zaman çalışır: widget hafızadan atılmadan hemen önce son bir kez çalışır
ne yapılır \_controller.dispose() stream dinleyicilerin iptalleri burada yapılır. super.dispose() un mutlaka son satırda çalıştırılması gerekir.

setState((){})

1. arka planda ne yapar: State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali yollar.

2) nerede kullanılır: Sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderir.

ValueNotifier<T>

1. arkada planda ne iş yapar: ChangeNotifier sınıfından türer . Belleğinde tek bir nesne referansı tutar. (T \_value)
2. Tetikleme: Değer atandığında(set value (T value)), eğer yeni değer eski değere eşit değilse (\_value!=newValue), kayıtlı olan fonksioynu çağrılır.(addListener((){})

InheritedWidget
1)ne yapar: Widget ağacında alttaki childların, aradaki onlara widgeti bypas ederek, üst widgetin verisine (state'ine) doğrudan erişmesini sağlayan soyut bir widgettir.

Material 3 Tasarım dili renk algoritması ve temalar

primary:Ana marka rengi
onPrimary:Ana rengin üstüne yazılacak yazı rengi (okunulabilirlik açısından)
primaryContainer:Anarengin yumuşak pastel arkaplan tonu
onPrimaryContainer: Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılacak yazı (okunabilirlik açıısndan)
surface:Sayfa arka plan yuvali
onSurface: Sayfa üstündeki ana metin rengi
outLineVariant: İnce sınır ve ayrım çizgilerinin rengi.

ThemeMode.system
color: Colors.black.withOpacity(186)// kesinlikle 1 ila 255 sayıları arasında tam sayı olarak girilmelidir. **bu kullanım güncelde istemiyor**

color:Colors.black.withValues(alpha: 186/255)//double sayı oolarak girilmelidir **Güncel ve doğru yöntem**

Expanded ve flexible
Expanded: Kalan bol alanın TAMAMINI kaplamaya zorlar.
Flexible: Kalan bol alanı paylaştırır. (flex: 1, flex:2)
Flex:yan yana iki expanded varsa birine flex2 diperine flex1 verir bu sayede ekran boyutuna göre otomatik olarak ayarlar.

Stack ve positioned .
Ne yapar: Widget'ları z ekseninde üst üste bindirir
Positioned: Yanlızca bir stack içinde çalışır.
top: 10 , right: 10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar.

ListView.builder,
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yüklser ve doğal olarak telefon doonar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı mnatığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler. Kullanıcı aşağıya kaydıkça yukarda kalanlar bellekten düşürülüp altta kaalnlar belleğe taze olarak yeni üretilir.

shrinkWrap: true
Bir ListView başka bir dikey kaydırıcının (singleChildScrollview) içine konursa Vertical viewport hatası verir
shrinkWrap true verilerek bu çözülebilir ancak: ListView'ın sonsuza kayma (infinite scroll) özelliği devre dışı kalır.
** sadece 3 5 elemanınız varsa bunu kullanmalısınız**

Inkwell ve GestureDetector
GestureDetector: Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇ Bir tepki vermez.
Inkwell tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir.

Önemlki Kuralı: Inkwellin arkasında mutlaka bir material widget olmak zorundadır. AKsi taktirde su dalgas arkadaki tuvali görmediği için hiçbir şekilde görünmez.

Form mimarisi

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışarıdn erişilemiyor. Bu yüzden widgetin en üstüne koyduğumuz GlobalKey değişkeni sayesinde formun Validate(geçerli) durumunu ve içindeki değerleri (değişkenleri) dışarıdan okuyoruz.

\_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFromFiled validator bloklarını sırayla çalıştırır.

Validator: (String? value)
fonksiyonda bir hata bulursa geriye String olarak hata metni gönderir.
Bu metnin otomatik olarak kırmızı renkte ve inputun altında belirir.
Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir. Null gelmesi

Animasyon motoru
AnimateContainer: genişlik yükseklik padding margin border renk ve gölge oynatır
AnimatedOpacity: görünürlüğü 0.0 ile 1.0 arasında yumuşakça soldurur
AnimatedScale: Widget merkezinden dışarıya doğru büyütüp küçültür
AnimatedAlign: widget kutunun içinde sağdan sola yukardan aşağıya karşı konumunu değiştirir.

Curves
İvmelenme Karakterleri

Curves.linear:Sabit hız (robotik hareketler)
Curves.easeInout: Yavaş Başlar ortada hızlanır yavaşça durur
Curves.bounceOut: Hedefe çarptığında top gibi 2 3 kez yaylanarak seker
Curves.elasticOut:Lastik gibi ileri geri titreyerek yerine oturur.

Gorouter

context.go('/profil'); route yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder. Sayfayı temizleyebilir.

context.push('/profil/5'); Stack yönlendirmesidir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler.

context.pop() sayfanın en üstteki yığınını kapatır.

state.pathParameters["id"]: Gorouter içincde tanımladığımız /:id yapılarına erişmek için kullanılır.

/profil?user=berat
state.uri.queryParameters["user"]:Opsiyonel filtreleme ya da arama zamanlarında kullanılır.

Cihaz içi yerel depolama mimarileri

SharedPreferences:
Küçük kullanııc ayaarları
Düşük Güvenilrilik
Okuma yazma hızları: okuma hızı orta / yazma hızı yavaş

FlutterSecureStprage
Şİfre token vb saklama
En yüksek güvence
Orta

Hive/Isar:
Yüksek performanslı nsene depolama
Orta(isteğe bağlı şifreleme açılabilir.)
Aşırı hıızlı

---

### Alışkanlık Yönetimi ve Form Terimleri

Dismissible:
1. Ne işe yarar: Bir liste elemanını sağa veya sola kaydırarak ekrandan kaldırmayı (swipe to delete) sağlar.
2. confirmDismiss: Kullanıcı kartı kaydırdığında silme işlemini hemen yapmak yerine bir AlertDialog onay penceresi açıp `true` dönerse silme, `false` dönerse kartı eski yerine getirme garantisi verir.

TimeOfDay & showTimePicker:
1. Ne işe yarar: Saat ve dakika (örn: 09:45, 15:36) verisini tutar ve kullanıcıya şık bir saat seçim diyaloğu sunar.
2. Formatlama: `${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}` ile 24 saat formatında metne dönüştürülür.

SwitchListTile:
1. Ne işe yarar: Başlık, alt başlık ve sağ tarafta açılıp kapanan bir switch anahtarını tek satırda sunar.
2. Nerede kullanılır: "Hatırlatıcı Bildirim Gönderilsin mi?" gibi boolean (`true/false`) tercihlerinde.

ChoiceChip & FilterChip:
1. Ne işe yarar: Spor, Sağlık, Zihin, Müzik gibi kategorileri veya Pzt..Paz haftalık günlerini seçilebilir hap (pill) şeklinde sunar.
2. selected: `bool` değer alır, tıklandığında seçili durumu renklendirir.

showModalBottomSheet(isScrollControlled: true):
1. Ne işe yarar: Ekranın altından yukarı doğru açılan modal form penceresidir.
2. `isScrollControlled: true`: Modalın klavye açıldığında yukarı kaymasını ve formun ekranın yarısından fazlasını kaplayabilmesini sağlar.

AlertDialog & showDialog:
1. Ne işe yarar: Kullanıcıya kritik işlemlerde (örn: alışkanlık silme) geri dönüşü olmayan veri kaybını önlemek için onay soran pop-up kutusu.
