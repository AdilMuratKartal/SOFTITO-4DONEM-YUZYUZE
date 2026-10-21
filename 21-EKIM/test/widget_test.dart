import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:randevu_sistemi/core/theme/app_theme.dart';
import 'package:randevu_sistemi/core/services/json_data_service.dart';
import 'package:randevu_sistemi/providers/auth_provider.dart';
import 'package:randevu_sistemi/providers/listing_provider.dart';
import 'package:randevu_sistemi/providers/appointment_provider.dart';
import 'package:randevu_sistemi/providers/chat_provider.dart';
import 'package:randevu_sistemi/views/auth/login_screen.dart';
import 'package:randevu_sistemi/views/shared/widgets/status_badge.dart';
import 'package:randevu_sistemi/views/shared/widgets/location_badge.dart';

void main() {
  testWidgets('LoginScreen smoke test - Rol ve kullanıcı kartları çizilmeli', (WidgetTester tester) async {
    final jsonDataService = JsonDataService();
    final authProvider = AuthProvider(dataService: jsonDataService);
    final listingProvider = ListingProvider(dataService: jsonDataService);
    final appointmentProvider = AppointmentProvider(dataService: jsonDataService);
    final chatProvider = ChatProvider(dataService: jsonDataService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider.value(value: listingProvider),
          ChangeNotifierProvider.value(value: appointmentProvider),
          ChangeNotifierProvider.value(value: chatProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Randevu ve Hizmet Platformu'), findsOneWidget);
  });

  testWidgets('StatusBadge durum rozeti doğru etiket basmalı', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(status: 'onaylandi'),
        ),
      ),
    );

    expect(find.text('Onaylandı'), findsOneWidget);
  });

  testWidgets('LocationBadge doğru konum etiketini basmalı', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocationBadge(locationType: 'sen_gel'),
        ),
      ),
    );

    expect(find.text('Sen Gel (Adrese)'), findsOneWidget);
  });
}
