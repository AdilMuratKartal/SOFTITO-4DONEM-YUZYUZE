import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'widgets/status_badge.dart';

class ConversationsScreen extends StatelessWidget {
  final bool isTab;

  const ConversationsScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final chatProvider = context.watch<ChatProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Kullanıcı oturumu bulunamadı')),
      );
    }

    final userAppointments = currentUser.isCustomer
        ? appointmentProvider.getByCustomer(currentUser.id)
        : appointmentProvider.getByProvider(currentUser.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mesajlar ve Sohbetler'),
        automaticallyImplyLeading: !isTab,
      ),
      body: userAppointments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Henüz Aktif Sohbetiniz Yok',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Randevu veya teklif oluşturduğunuzda taraflarla buradan doğrudan mesajlaşabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: userAppointments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final apt = userAppointments[index];
                final messages = chatProvider.getMessagesByAppointment(apt.id);
                final lastMsg = messages.isNotEmpty ? messages.last : null;

                final otherPartyName = currentUser.isCustomer ? apt.providerName : apt.customerName;

                return Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(appointment: apt),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: currentUser.isCustomer
                                ? AppColors.secondary.withAlpha(25)
                                : AppColors.primary.withAlpha(25),
                            child: Icon(
                              currentUser.isCustomer ? Icons.handyman_outlined : Icons.person_outline,
                              color: currentUser.isCustomer ? AppColors.secondary : AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        otherPartyName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (lastMsg != null)
                                      Text(
                                        lastMsg.timestamp,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  apt.serviceTitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  lastMsg?.message ?? 'Sohbeti başlatmak için dokunun...',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: lastMsg != null ? AppColors.textSecondary : AppColors.secondary,
                                    fontStyle: lastMsg != null ? FontStyle.normal : FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(status: apt.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
