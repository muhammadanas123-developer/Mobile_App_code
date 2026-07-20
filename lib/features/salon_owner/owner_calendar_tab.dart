import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/appointment_model.dart';
import 'package:fyp_project/features/booking/booking_state_provider.dart';

final selectedOwnerCalendarDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class OwnerCalendarTab extends ConsumerWidget {
  const OwnerCalendarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedOwnerCalendarDateProvider);
    final appointments = ref.watch(appointmentsProvider);

    // Filter appointments for that specific day
    final dayAppointments = appointments.where((app) {
      return app.dateTime.year == selectedDate.year &&
          app.dateTime.month == selectedDate.month &&
          app.dateTime.day == selectedDate.day;
    }).toList();

    // Sort by time
    dayAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final today = DateTime.now();
    final weekDays = List.generate(7, (index) => today.add(Duration(days: index - 2))); // covers 2 days past to 4 days future

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // Custom Header Date Selector
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: AppTextStyles.titleLarge(color: AppColors.primaryDark),
                ),
                AppSpacing.gapSM,
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: weekDays.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final dayDate = weekDays[index];
                      final isSelected = dayDate.day == selectedDate.day &&
                          dayDate.month == selectedDate.month &&
                          dayDate.year == selectedDate.year;

                      return GestureDetector(
                        onTap: () => ref.read(selectedOwnerCalendarDateProvider.notifier).state = dayDate,
                        child: Container(
                          width: 54,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : AppColors.surface,
                            borderRadius: AppRadius.borderMD,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryAccent : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(dayDate).toUpperCase(),
                                style: AppTextStyles.label(
                                  color: isSelected ? AppColors.primaryDark : AppColors.textLight,
                                ).copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dayDate.day.toString(),
                                style: AppTextStyles.titleMedium(
                                  color: isSelected ? AppColors.primaryDark : AppColors.textDark,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Agenda appointments
          Expanded(
            child: dayAppointments.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: dayAppointments.length,
              separatorBuilder: (context, index) => AppSpacing.gapMD,
              itemBuilder: (context, index) {
                final app = dayAppointments[index];
                return _buildOwnerAppointmentCard(context, app);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.surface,
        onPressed: () => _showAddBookingDialog(context, ref, selectedDate),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildOwnerAppointmentCard(BuildContext context, AppointmentModel app) {
    final isConfirmed = app.status == 'confirmed';
    final isCancelled = app.status == 'cancelled';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLG,
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            child: Text(
              app.customerInitial ?? 'C',
              style: AppTextStyles.titleSmall(color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.customerName,
                  style: AppTextStyles.titleMedium(),
                ),
                const SizedBox(height: 4),
                Text(
                  '${app.serviceName} • ${DateFormat('hh:mm a').format(app.dateTime)}',
                  style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConfirmed
                  ? AppColors.primaryLight
                  : isCancelled
                  ? AppColors.errorBg
                  : AppColors.cardBg,
              borderRadius: AppRadius.borderSM,
            ),
            child: Text(
              app.status.toUpperCase(),
              style: AppTextStyles.label(
                color: isConfirmed
                    ? AppColors.primaryDark
                    : isCancelled
                    ? AppColors.errorText
                    : AppColors.textMedium,
              ).copyWith(fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
            const Icon(Icons.event_note, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              'No Scheduled Appointments',
              style: AppTextStyles.h3(),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy a free slot! You can add walk-in bookings using the "+" button.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBookingDialog(BuildContext context, WidgetRef ref, DateTime currentDate) {
    final clientNameController = TextEditingController();
    String selectedService = 'Botanical Glow Facial';
    String selectedTime = '10:00 AM';

    final servicesList = ['Botanical Glow Facial', 'Forest Zen Massage', 'Signature Hair Balayage'];
    final timeSlotsList = ['10:00 AM', '11:30 AM', '1:00 PM', '2:30 PM', '4:00 PM'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Manual Booking'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Client Name'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: clientNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter client name',
                      ),
                    ),
                    AppSpacing.gapMD,
                    const Text('Service'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedService,
                      items: servicesList.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedService = val;
                          });
                        }
                      },
                    ),
                    AppSpacing.gapMD,
                    const Text('Time Slot'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedTime,
                      items: timeSlotsList.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedTime = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = clientNameController.text.trim();
                    if (name.isEmpty) return;

                    final initials = name.split(' ').map((e) => e[0]).join().toUpperCase();

                    // Create appt object
                    final appt = AppointmentModel(
                      id: 'a_manual_${DateTime.now().millisecondsSinceEpoch}',
                      salonName: 'Maison de Beauté',
                      salonAddress: '22 Rue de la Paix, Paris',
                      serviceName: selectedService,
                      durationMinutes: 90,
                      price: 145.0,
                      dateTime: DateTime(
                        currentDate.year,
                        currentDate.month,
                        currentDate.day,
                        int.parse(selectedTime.split(':').first) + (selectedTime.contains('PM') ? 12 : 0),
                      ),
                      providerName: 'Senior Esthetician Sarah Jenkins',
                      status: 'confirmed',
                      customerName: name,
                      customerInitial: initials.length > 2 ? initials.substring(0, 2) : initials,
                    );

                    ref.read(appointmentsProvider.notifier).addAppointment(appt);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Manual appointment added for $name')),
                    );
                  },
                  child: const Text('Add Booking'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}