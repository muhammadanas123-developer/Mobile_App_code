import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routing/routes.dart';
import 'package:fyp_project/features/booking/booking_state_provider.dart';

class OwnerDashboardTab extends ConsumerWidget {
  const OwnerDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);

    // Filter appointments for owner schedule views
    final pendingCount = appointments.where((app) => app.status == 'pending').length;
    final confirmedCount = appointments.where((app) => app.status == 'confirmed').length;
    final completedCount = appointments.where((app) => app.status == 'completed').length;
    final remainingCount = confirmedCount;

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('Beauty Personalized by ai'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AppAssets.avatarSarah),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bonjour Title & Info Banner
            Text(
              'Bonjour, Maison de Beauté',
              style: AppTextStyles.h2(),
            ),
            AppSpacing.gapXXS,
            Text(
              'Your salon is seeing 15% more traffic than last Tuesday.',
              style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
            ),
            AppSpacing.gapLG,

            // Today's Revenue card (Screen 5 style)
            _buildMetricCard(
              title: 'Today\'s Revenue',
              value: '€1,240.00',
              icon: Icons.trending_up,
              subtext: '+8.4% from yesterday',
              subtextColor: AppColors.success,
            ),
            AppSpacing.gapMD,

            // Appointments card (Screen 5 style)
            _buildMetricCard(
              title: 'Appointments',
              value: '${completedCount + remainingCount}',
              icon: Icons.calendar_today,
              subtext: '$completedCount completed · $remainingCount remaining',
              subtextColor: AppColors.textMedium,
            ),
            AppSpacing.gapMD,

            // Pending Requests card (Screen 5 style)
            _buildPendingRequestsCard(context, ref, pendingCount),
            AppSpacing.gapMD,

            // AI Business Insight card (Screen 5 style - dark green)
            _buildAIBusinessInsightCard(context),
            AppSpacing.gapLG,

            // Today's Schedule header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: AppTextStyles.titleLarge(color: AppColors.textDark),
                ),
                TextButton(
                  onPressed: () => context.go(Routes.ownerCalendar),
                  child: Text(
                    'View Calendar',
                    style: AppTextStyles.bodyMedium(color: AppColors.primaryDark).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSM,

            // Today's Schedule items (Juliette, Marc, Elana)
            _buildScheduleItem('JD', 'Juliette Dubois', 'Signature Balayage', '14:00', Colors.lightGreen.shade100),
            AppSpacing.gapSM,
            _buildScheduleItem('ML', 'Marc Laurent', 'Deep Tissue Massage', '15:30', Colors.blueGrey.shade100),
            AppSpacing.gapSM,
            _buildScheduleItem('EM', 'Elana Morel', 'Gel Manicure', '17:00', Colors.tealAccent.shade100),
            AppSpacing.gapLG,

            // Quick Actions Panel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.5),
                borderRadius: AppRadius.borderLG,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUICK ACTIONS',
                    style: AppTextStyles.label(color: AppColors.textMedium),
                  ),
                  AppSpacing.gapMD,

                  // Row of actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickActionButton(Icons.add, 'New Booking', () => context.go(Routes.ownerCalendar)),
                      _buildQuickActionButton(Icons.send, 'Blast Promotion', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Special promotion sent to local regular clients!')),
                        );
                      }),
                      _buildQuickActionButton(Icons.archive_outlined, 'Stock Order', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restock request for Serums & Oils submitted successfully.')),
                        );
                      }),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 32),

                  // Footer info text
                  Center(
                    child: Text(
                      'Next Shift Starts: 09:00 AM Tomorrow',
                      style: AppTextStyles.bodySmall(color: AppColors.textMedium).copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  AppSpacing.gapMD,

                  // Accept all pending bookings
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Confirm accepting all pending
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Accept All Bookings?'),
                            content: const Text(
                              'Do you want to confirm all pending treatment bookings for today?',
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  // confirm logic
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('All pending bookings accepted!')),
                                  );
                                },
                                child: const Text('Accept All'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Accept All Pending'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required String subtext,
    required Color subtextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLG,
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.label(color: AppColors.textLight),
              ),
              AppSpacing.gapXXS,
              Text(
                value,
                style: AppTextStyles.metric(),
              ),
              AppSpacing.gapXS,
              Text(
                subtext,
                style: AppTextStyles.bodySmall(color: subtextColor).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsCard(BuildContext context, WidgetRef ref, int pendingCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLG,
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pending Requests',
                style: AppTextStyles.label(color: AppColors.textLight),
              ),
              AppSpacing.gapXXS,
              Text(
                '$pendingCount',
                style: AppTextStyles.metric(),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.go(Routes.ownerBookings),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
            ),
            child: const Text('Review All'),
          ),
        ],
      ),
    );
  }

  Widget _buildAIBusinessInsightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.borderLG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 16),
              const SizedBox(width: 6),
              Text(
                'ai BUSINESS INSIGHT',
                style: AppTextStyles.label(color: AppColors.primaryAccent).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'High demand for facials this week',
            style: AppTextStyles.titleLarge(color: AppColors.surface),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on search trends and booking patterns in your area, consider opening 2 more evening slots for "HydraFacial Luxe" to maximize revenue.',
            style: AppTextStyles.bodyMedium(color: AppColors.surface).copyWith(height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Insight Applied'),
                    content: const Text(
                      'Successfully created 2 evening slots for "HydraFacial Luxe" on Thursday and Friday. Clients are being notified.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Okay')),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surface.withValues(alpha: 0.15),
                foregroundColor: AppColors.primaryAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderMD,
                  side: BorderSide(color: AppColors.primaryAccent.withValues(alpha: 0.3)),
                ),
              ),
              child: const Text('Apply Suggestion'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String initial, String name, String service, String time, Color avatarBg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMD,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarBg,
            child: Text(
              initial,
              style: AppTextStyles.titleSmall(color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMedium()),
                Text(
                  '$service • $time',
                  style: AppTextStyles.bodySmall(color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall(color: AppColors.textDark).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}