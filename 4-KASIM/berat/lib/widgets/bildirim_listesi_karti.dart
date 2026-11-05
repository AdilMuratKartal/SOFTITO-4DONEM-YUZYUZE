import 'package:flutter/material.dart';

import '../models/bildirim_modeli.dart';

class BildirimListesiKarti extends StatelessWidget {
  final List<BildirimModeli> bildirimler;
  final String? token;
  final bool konuyaAboneMi;
  final ValueChanged<bool> onAboneDegisti;

  const BildirimListesiKarti({
    super.key,
    required this.bildirimler,
    this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, //ortadan başlatıp her iki tarafa esniyor
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF006C4A),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'FCM Bildirim Merkezi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFF172A),
                    ),
                  ),
                ),
                Switch(
                  value: konuyaAboneMi,
                  onChanged: onAboneDegisti,
                  activeColor: const Color.fromARGB(15, 160, 40, 50),
                ),
              ],
            ),
            Text(
              konuyaAboneMi ? 'Tüm sınıf yanını aktif' : 'Yayın kapalı',
              style: TextStyle(
                fontSize: 12,
                color: konuyaAboneMi
                    ? const Color.fromARGB(15, 24, 59, 17)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Cihazın FCM tokeni",
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 40, 52),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    token ?? 'token alınıyor',
                    style: const TextStyle(
                      color: Color(0xFF38888),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Text(
              'Gelen Bildirimşer (${bildirimler.length}):',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(0, 5, 249, 253),
              ),
            ),
            const SizedBox(height: 8),
            bildirimler.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'Henüz Gelen Bildirim Yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bildirimler.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      final b = bildirimler[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(0, 123, 238, 238),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            color: Color.fromARGB(0, 113, 25, 25),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          b.baslik,
                          style: const TextStyle(
                            //const vermezsek hata verir yeni değişiken olarak görür syntax hatası verir.
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(b.icerik),
                        trailing: Text(
                          '${b.tarih.hour.toString().padLeft(2, '0')}:${b.tarih.minute.toString().padLeft(2, '0')}', //burda saat 10 dan küçükse mesela 9 ise 09 değil 9 geliyor bizde padLeft ile saat'in text uzunluğu 2 den az ise sola(başa) 0 ekle diyoruz.
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ), //burda neden const yok. material kütüphanesinde shade500 yok, kütüphanede bu değişkenler sabit olmadığı için, 2. tarih.hour Datetime çalıştırma zamanında hesaplandığı için.
                        ),
                      );
                    },
                  ), //builder'dan farkı her bir eleman arasına boşluk veriyor gap gibi
          ],
        ),
      ),
    );
  }
}
