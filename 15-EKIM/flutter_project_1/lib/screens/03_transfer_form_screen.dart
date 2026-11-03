import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

import '../models/transaction_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class TransferFormScreen extends StatefulWidget { // TransferFormScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const TransferFormScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  double _balance = 148950.00; // double türünden _balance değişkenimiz
  final List<TransactionItem> _history = [];

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    final now = DateTime.now();
    _history.addAll([
      TransactionItem(
        id: 'tx_init_1',
        title: 'Ahmet Yılmaz',
        category: 'Hızlı Transfer',
        date: DateTime(now.year, now.month, now.day, 11, 30),
        amount: 1500.00,
        isExpense: true,
        icon: Icons.send_rounded,
      ),
      TransactionItem(
        id: 'tx_init_2',
        title: 'Merve Demir',
        category: 'Hızlı Transfer',
        date: DateTime(now.year, now.month, now.day - 1, 15, 45),
        amount: 2400.00,
        isExpense: true,
        icon: Icons.send_rounded,
      ),
    ]);
  }

  Future<void> _openTransferModal() async {
    final transaction = await showModalBottomSheet<TransactionItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _TransferForm(balance: _balance),
    );

    if (!mounted || transaction == null) return;

    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _balance = ((_balance - transaction.amount) * 100).round() / 100;
      _history.add(transaction);
      _history.sort((a, b) => b.date.compareTo(a.date));
    });

    ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
      const SnackBar(content: Text('Örnek transfer geçmişe eklendi.')),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Text('Para Transferi',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
            margin: EdgeInsets.zero,
            child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.all(20),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  const Text('Kullanılabilir Bakiye'),
                  const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    '₺${_balance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  const Text('Örnek veridir; gerçek para transferi yapılmaz.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          FilledButton.icon(
            onPressed: _openTransferModal,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Yeni Transfer'),
          ),
          const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text('Transfer Geçmişi',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          for (final transaction in _history) ...[
            Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  CircleAvatar(child: Icon(transaction.icon)),
                  const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                      children: [
                        Text(
                          transaction.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(transaction.category),
                        Text(_formatDate(transaction.date)),
                        const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          '-₺${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final day = DateTime(date.year, date.month, date.day);
    final String label; // String türünden label adlı değişkenimiz
    if (day == today) {
      label = 'Bugün';
    } else if (day == yesterday) {
      label = 'Dün';
    } else {
      label = '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
    return '$label ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _TransferForm extends StatefulWidget { // _TransferForm sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const _TransferForm({required this.balance}); // Genel, sabit sınıf constructor'ı

  final double balance; // double türünden balance adlı değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<_TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<_TransferForm> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  final _amountController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  double? _parseAmount(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    Navigator.of(context).pop( // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
      TransactionItem(
        id: 'tx_${now.microsecondsSinceEpoch}',
        title: _recipientController.text.trim(),
        category: 'Hızlı Transfer',
        date: now,
        amount: _parseAmount(_amountController.text)!,
        isExpense: true,
        icon: Icons.send_rounded,
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        top: false,
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                Text('Yeni Transfer',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Text(
                    'Kullanılabilir bakiye: ₺${widget.balance.toStringAsFixed(2)}'),
                const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: _recipientController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Alıcı adı',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Alıcı adını girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Tutar',
                    prefixText: '₺ ',
                    hintText: '1500,00',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final text = (value ?? '').trim();
                    final amount = _parseAmount(text);
                    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(text) ||
                        amount == null ||
                        !amount.isFinite ||
                        amount <= 0) {
                      return 'En fazla iki ondalıklı, pozitif bir tutar girin.';
                    }
                    if (amount > widget.balance) {
                      return 'Yetersiz bakiye.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Örnek Transferi Onayla'),
                ),
                TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                  onPressed: () => Navigator.of(context).pop(), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                  child: const Text('Vazgeç'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
