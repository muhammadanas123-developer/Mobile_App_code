import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import 'booking_state_provider.dart';
import '../../../shared/appointment_model.dart';

/// CustomerBookingsTab lists active and past beauty appointments.
class CustomerBookingsTab extends ConsumerWidget {
  const CustomerBookingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final cs = Theme.of(context).colorScheme;

    final upcoming = appointments.where((app) => app.status == 'confirmed' || app.status == 'pending').toList();
    final past = appointments.where((app) => app.status == 'completed' || app.status == 'cancelled').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: TabBar(
            indicatorColor: AppColors.primaryDark,
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.textLight,
            labelStyle: AppTextStyles.titleSmall(),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(context, ref, upcoming, isUpcoming: true),
            _buildBookingsList(context, ref, past, isUpcoming: false),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(
      BuildContext context,
      WidgetRef ref,
      List<AppointmentModel> list, {
        required bool isUpcoming,
      }) {
    final cs = Theme.of(context).colorScheme;

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month_outlined, size: 64, color: AppColors.textLight),
              AppSpacing.gapMD,
              Text(
                'No bookings found',
                style: AppTextStyles.titleLarge(color: AppColors.textMedium),
              ),
              AppSpacing.gapXS,
              Text(
                isUpcoming
                    ? 'Schedule a facial treatment or scan your skin with ai recommendations.'
                    : 'Your completed and cancelled services history will appear here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: list.length,
      separatorBuilder: (context, index) => AppSpacing.gapMD,
      itemBuilder: (context, index) {
        final appointment = list[index];
        final dateStr = DateFormat('EEEE, d MMMM yyyy').format(appointment.dateTime);
        final timeStr = DateFormat('h:mm a').format(appointment.dateTime);

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppRadius.borderLG,
            border: Border.all(color: AppColors.border, width: 0.5),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.salonName, style: AppTextStyles.label(color: AppColors.textLight)),
                      Text(appointment.serviceName, style: AppTextStyles.titleLarge()),
                    ],
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),
              const Divider(color: AppColors.border, height: 24),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.textMedium),
                  const SizedBox(width: 6),
                  Text('$dateStr • $timeStr', style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: AppColors.textMedium),
                  const SizedBox(width: 6),
                  Text(appointment.providerName, style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
                ],
              ),
              const Divider(color: AppColors.border, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Price', style: AppTextStyles.bodySmall(color: AppColors.textLight)),
                      Text('\$${appointment.price.toStringAsFixed(2)}', style: AppTextStyles.titleLarge(color: AppColors.primaryDark)),
                    ],
                  ),
                  if (isUpcoming && appointment.status != 'cancelled')
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => _showRescheduleDialog(context, ref, appointment),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryDark,
                            side: const BorderSide(color: AppColors.primaryDark),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                          ),
                          child: const Text('Reschedule'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancel Appointment?'),
                                content: const Text('Are you sure you want to cancel this booking? This action is irreversible.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                                  TextButton(
                                    onPressed: () {
                                      ref.read(appointmentsProvider.notifier).cancelAppointment(appointment.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel Appointment', style: TextStyle(color: AppColors.errorText)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorBg,
                            foregroundColor: AppColors.errorText,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context, WidgetRef ref, AppointmentModel appointment) {
    String selectedTime = '11:30 AM';
    final timeSlotsList = ['10:00 AM', '11:30 AM', '1:00 PM', '2:30 PM', '4:00 PM'];
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reschedule Appointment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current: ${DateFormat('MMM dd, hh:mm a').format(appointment.dateTime)}'),
                  const Divider(height: 24),
                  const Text('Select New Date'),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  ),
                  AppSpacing.gapMD,
                  const Text('Select New Time'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTime,
                    items: timeSlotsList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedTime = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final parts = selectedTime.split(':');
                    final rawHour = int.parse(parts.first);
                    final isPm = selectedTime.contains('PM');
                    final hour = isPm && rawHour != 12 ? rawHour + 12 : rawHour;
                    final newDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour);
                    ref.read(appointmentsProvider.notifier).rescheduleAppointment(appointment.id, newDateTime);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rescheduled to ${DateFormat('MMM dd, hh:mm a').format(newDateTime)}')),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color text;
    String label = status.toUpperCase();

    if (status == 'confirmed') {
      bg = AppColors.primaryLight;
      text = AppColors.primaryDark;
    } else if (status == 'pending') {
      bg = AppColors.warningBg;
      text = AppColors.warningText;
    } else if (status == 'completed') {
      bg = AppColors.cardBg;
      text = AppColors.textMedium;
    } else {
      bg = AppColors.errorBg;
      text = AppColors.errorText;
      label = 'CANCELLED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.borderSM),
      child: Text(label, style: AppTextStyles.label(color: text).copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}