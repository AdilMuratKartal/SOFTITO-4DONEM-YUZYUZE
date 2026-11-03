import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/asset_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/transaction_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class MarketsGridListScreen extends StatelessWidget { // MarketsGridListScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const MarketsGridListScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  static const List<Asset> assets = [
    Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 67420.00,
      change24h: 4.20,
      balance: 0.4,
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500,
      change24h: -1.80,
      balance: 4.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 200.00,
      change24h: 0.5,
      balance: 85.00,
    ),
  ];

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactions = [
      TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: DateTime(today.year, today.month, today.day, 14, 20),
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac,
      ),
      TransactionItem(
        id: 'tx_2',
        title: 'Kodusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: DateTime(yesterday.year, yesterday.month, yesterday.day, 9),
        amount: 125000.00,
        isExpense: false,
        icon: Icons.account_balance,
      ),
      TransactionItem(
        id: 'tx_3',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: DateTime(today.year, today.month, today.day, 14, 20),
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac,
      ),
      TransactionItem(
        id: 'tx_4',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: DateTime(today.year, today.month, today.day, 14, 20),
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac,
      ),
    ]..sort((a, b) => b.date.compareTo(a.date));

    final headingStyle = Theme.of(context).textTheme.titleLarge;

    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Text('Piyasalar', style: headingStyle),
          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          const Text('Örnek veriler; canlı piyasa fiyatları değildir.'),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 560
                      ? 2
                      : 1;
              final cardWidth =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;

              return Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                spacing: 12,
                runSpacing: 12,
                children: assets
                    .map((asset) => SizedBox(
                          width: cardWidth,
                          child: _buildAssetCard(context, asset), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text('Son İşlemler', style: headingStyle),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          ListView.separated(
            shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
            physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
            padding: EdgeInsets.zero,
            itemCount: transactions.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
            separatorBuilder: (context, index) => const Divider(height: 1), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
            itemBuilder: (context, index) => // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                _buildTransactionTile(transactions[index], today),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    final isPositive = asset.change24h >= 0;
    final changeColor =
        isPositive ? Colors.green.shade700 : Colors.red.shade700;

    return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
      margin: EdgeInsets.zero,
      child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
        padding: const EdgeInsets.all(16),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            Text(asset.symbol, style: Theme.of(context).textTheme.titleMedium),
            Text(asset.name),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              '\$${asset.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: changeColor,
                  size: 20,
                ),
                const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Flexible(
                  child: Text(
                    '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}% (24s)',
                    style: TextStyle(color: changeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text('Bakiye: ${asset.balance} ${asset.symbol}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionItem transaction, DateTime today) {
    final color =
        transaction.isExpense ? Colors.red.shade700 : Colors.green.shade700;

    return ListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        child: Icon(transaction.icon),
      ),
      title: Text(transaction.title), // Sayfa başlığını ekrana yazdırıyoruz
      subtitle: Text( // Sayfa başlığını ekrana yazdırıyoruz
        '${transaction.category}\n${_formatDate(transaction.date, today)}',
      ),
      isThreeLine: true,
      trailing: Text(
        '${transaction.isExpense ? '-' : '+'}₺${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(DateTime date, DateTime today) {
    final day = DateTime(date.year, date.month, date.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final String label; // String türünden label adlı değişkenimiz
    if (day == today) {
      label = 'Bugün';
    } else if (day == yesterday) {
      label = 'Dün';
    } else {
      label = '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$label $hour:$minute';
  }
}
