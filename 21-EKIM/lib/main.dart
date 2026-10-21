import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/json_data_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/listing_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/chat_provider.dart';
import 'views/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final jsonDataService = JsonDataService();
  final authProvider = AuthProvider(dataService: jsonDataService);
  final listingProvider = ListingProvider(dataService: jsonDataService);
  final appointmentProvider = AppointmentProvider(dataService: jsonDataService);
  final chatProvider = ChatProvider(dataService: jsonDataService);

  // JSON verilerini başlangıçta belleğe yükle
  await Future.wait([
    authProvider.init(),
    listingProvider.init(),
    appointmentProvider.init(),
    chatProvider.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: listingProvider),
        ChangeNotifierProvider.value(value: appointmentProvider),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: const RandevuApp(),
    ),
  );
}

class RandevuApp extends StatelessWidget {
  const RandevuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Randevu ve Hizmet Platformu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
