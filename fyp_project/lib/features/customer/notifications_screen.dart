import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/notification_model.dart';

final customerNotificationsProvider = StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>((ref) {
  return NotificationListNotifier();
});

class NotificationListNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationListNotifier()
      : super([
    NotificationModel(
      id: 'notif_1',
      title: 'Appointment Scheduled!',
      body: 'Your Botanical Glow Facial with Sarah Jenkins is confirmed for today at 2:30 PM.',
      dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
      category: 'appointment',
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'ai Analysis Report Ready',
      body: 'Your hair strength analysis is completed. View the dashboard to see recommendations.',
      dateTime: DateTime.now().subtract(const Duration(hours: 3)),
      category: 'ai_scan',
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Summer Skincare 20% Off',
      body: 'Get active discounts on all organic serums at Maison de Beauté this weekend.',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      category: 'promo',
      isRead: true,
    ),
  ]);

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void clearAll() {
    state = [];
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(customerNotificationsProvider);

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          if (notifications.isNotEmpty) ...[
            TextButton(
              onPressed: () => ref.read(customerNotificationsProvider.notifier).markAllAsRead(),
              child: Text(
                'Mark All Read',
                style: AppTextStyles.bodySmall(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: AppColors.errorText),
              onPressed: () => ref.read(customerNotificationsProvider.notifier).clearAll(),
            ),
          ]
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return GestureDetector(
            onTap: () => ref.read(customerNotificationsProvider.notifier).markAsRead(notif.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: notif.isRead ? AppColors.surface : AppColors.primaryLight.withValues(alpha: 0.2),
                borderRadius: AppRadius.borderMD,
                border: Border.all(
                  color: notif.isRead ? AppColors.border : AppColors.primaryAccent.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(notif.category),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(notif.category),
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notif.title,
                                style: AppTextStyles.titleSmall().copyWith(
                                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!notif.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif.body,
                          style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(notif.dateTime),
                          style: AppTextStyles.bodySmall(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 64,
                color: AppColors.textLight,
              ),
            ),
            AppSpacing.gapLG,
            Text(
              'No Notifications',
              style: AppTextStyles.h3(),
            ),
            AppSpacing.gapSM,
            Text(
              'You are all caught up! New updates regarding bookings and ai analysis reports will show up here.',
              style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'appointment':
        return AppColors.primaryLight;
      case 'ai_scan':
        return const Color(0xFFE0F2FE); // blue light
      case 'promo':
        return const Color(0xFFFEF3C7); // yellow light
      default:
        return AppColors.cardBg;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'appointment':
        return Icons.calendar_month;
      case 'ai_scan':
        return Icons.auto_awesome;
      case 'promo':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }
}