import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import 'package:fyp_project/features/booking/booking_state_provider.dart';

class OwnerBookingsTab extends ConsumerWidget {
  const OwnerBookingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final pendingRequests = appointments.where((app) => app.status == 'pending').toList();

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: pendingRequests.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: pendingRequests.length,
        separatorBuilder: (context, index) => AppSpacing.gapMD,
        itemBuilder: (context, index) {
          final request = pendingRequests[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.borderLG,
              border: Border.all(color: AppColors.border, width: 0.5),
              boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      radius: 20,
                      child: Text(
                        request.customerInitial ?? 'C',
                        style: AppTextStyles.titleSmall(color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.customerName,
                            style: AppTextStyles.titleMedium(),
                          ),
                          Text(
                            'Requested today',
                            style: AppTextStyles.bodySmall(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${request.price.toStringAsFixed(0)}',
                      style: AppTextStyles.titleLarge(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.border),
                Text(
                  request.serviceName,
                  style: AppTextStyles.titleMedium(color: AppColors.textDark),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textMedium),
                    const SizedBox(width: 6),
                    Text(
                      '${request.durationMinutes} minutes',
                      style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
                    ),
                    const SizedBox(width: 24),
                    const Icon(Icons.calendar_month, size: 14, color: AppColors.textMedium),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, hh:mm a').format(request.dateTime),
                      style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(appointmentsProvider.notifier).declineAppointment(request.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment declined')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorText,
                          side: const BorderSide(color: AppColors.errorText),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(appointmentsProvider.notifier).acceptAppointment(request.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment approved!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: AppColors.surface,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
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
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.done_all,
                size: 64,
                color: AppColors.primaryDark,
              ),
            ),
            AppSpacing.gapLG,
            Text(
              'All Caught Up!',
              style: AppTextStyles.h3(),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no pending treatment booking requests left to review.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
            ),
          ],
        ),
      ),
    );
  }
}