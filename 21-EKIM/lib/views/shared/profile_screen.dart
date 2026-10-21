import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTab;

  const ProfileScreen({super.key, this.isTab = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    final initialAddr = user?.isCustomer == true
        ? (user?.savedAddress ?? '')
        : (user?.shopAddress ?? '');
    _addressController = TextEditingController(text: initialAddr);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user == null) return;

    final newAddr = _addressController.text.trim();
    if (user.isCustomer) {
      authProvider.updateSavedAddress(newAddr);
    } else {
      authProvider.updateShopAddress(newAddr);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adres bilgisi güncellendi!'),
        backgroundColor: AppColors.approvedText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Kullanıcı bulunamadı')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil ve Hesap Ayarları'),
        automaticallyImplyLeading: !widget.isTab,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı Bilgi Kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: user.isCustomer
                          ? AppColors.primary.withAlpha(25)
                          : AppColors.secondary.withAlpha(25),
                      child: Icon(
                        user.isCustomer ? Icons.person : Icons.handyman,
                        size: 32,
                        color: user.isCustomer ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.phone,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Adres Düzenleme Kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          user.isCustomer ? Icons.home_outlined : Icons.storefront_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.isCustomer
                              ? 'Varsayılan Kayıtlı Adresim'
                              : 'Dükkan / Ofis Açık Adresi',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: user.isCustomer
                            ? 'Örn: Kadıköy Moda Cad. No:18...'
                            : 'Örn: Üsküdar Selimiye Mah...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        child: const Text('Adresi Güncelle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kullanıcı / Rol Değiştirme
            const Text(
              'Hesap ve Mod Değiştir',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: authProvider.users.map<Widget>((u) {
                  final isCurrent = u.id == user.id;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: u.isCustomer
                          ? AppColors.primary.withAlpha(25)
                          : AppColors.secondary.withAlpha(25),
                      child: Icon(
                        u.isCustomer ? Icons.person_outline : Icons.handyman_outlined,
                        color: u.isCustomer ? AppColors.primary : AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    title: Text(u.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      u.isCustomer ? 'Müşteri Modu' : 'Hizmet Veren Modu',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle, color: AppColors.approvedText)
                        : TextButton(
                            onPressed: () {
                              authProvider.switchUser(u);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Geçiş Yap'),
                          ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Giriş Ekranına Dönüş / Çıkış Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.cancelledText),
                label: const Text('Rol / Kullanıcı Seçim Ekranına Dön', style: TextStyle(color: AppColors.cancelledText)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.cancelledText),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
