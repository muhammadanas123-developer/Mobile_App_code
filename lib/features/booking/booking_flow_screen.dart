import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/appointment_model.dart';
import 'booking_state_provider.dart';

class BookingFlowScreen extends ConsumerWidget {
  const BookingFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final selectedService = ref.watch(selectedServiceProvider);
    final selectedDate = ref.watch(selectedBookingDateProvider);
    final selectedTime = ref.watch(selectedTimeSlotProvider);
    final selectedSpecialist = ref.watch(selectedSpecialistProvider);

    final serviceName = selectedService?.name ?? 'Botanical Glow Facial';
    final servicePrice = selectedService?.price ?? 145.00;
    final serviceDuration = selectedService?.durationMinutes ?? 90;
    final currentMonthYearStr = DateFormat('MMMM yyyy').format(selectedDate);

    final timeSlots = ['10:00 AM', '11:30 AM', '1:00 PM', '2:30 PM', '4:00 PM'];
    final today = DateTime.now();
    final daysList = List.generate(10, (index) => today.add(Duration(days: index)));

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Beauty Personalized by ai'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(AppAssets.avatarSarah),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Top White Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
                boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.borderMD,
                    child: Image.asset(AppAssets.salonInterior, width: 140, height: 100, fit: BoxFit.cover),
                  ),
                  AppSpacing.gapSM,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.borderSM),
                        child: Text(serviceName, style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: AppRadius.borderSM),
                        child: Text('$serviceDuration Mins', style: AppTextStyles.label(color: AppColors.textMedium)),
                      ),
                    ],
                  ),
                  AppSpacing.gapSM,
                  Text('Select your date & time', style: AppTextStyles.h2(color: AppColors.primaryDark)),
                  AppSpacing.gapXS,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: AppColors.textMedium),
                      const SizedBox(width: 6),
                      Text('With $selectedSpecialist', style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
                    ],
                  ),
                  AppSpacing.gapSM,
                  Text('\$${servicePrice.toStringAsFixed(2)}', style: AppTextStyles.metric(color: AppColors.primaryDark)),
                  Text('Due after service', style: AppTextStyles.bodySmall(color: AppColors.textLight)),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Date picker container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentMonthYearStr, style: AppTextStyles.titleLarge(color: AppColors.primaryDark)),
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: AppColors.textMedium),
                        onPressed: () => ref.read(selectedBookingDateProvider.notifier).state = selectedDate.subtract(const Duration(days: 30)),
                      ),
                    ],
                  ),
                  AppSpacing.gapSM,
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: daysList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = daysList[index];
                        final isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;
                        return GestureDetector(
                          onTap: () => ref.read(selectedBookingDateProvider.notifier).state = date,
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryLight : cs.surface,
                              borderRadius: AppRadius.borderMD,
                              border: Border.all(color: isSelected ? AppColors.primaryAccent : AppColors.border, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('E').format(date).toUpperCase(), style: AppTextStyles.label(color: isSelected ? AppColors.primaryDark : AppColors.textLight).copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                                const SizedBox(height: 6),
                                Text(date.day.toString(), style: AppTextStyles.titleLarge(color: isSelected ? AppColors.primaryDark : AppColors.textDark)),
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
            AppSpacing.gapLG,

            // Specialist Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Specialist', style: AppTextStyles.titleMedium(color: AppColors.primaryDark)),
                  AppSpacing.gapSM,
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSpecialistTile(ref, 'Sarah Jenkins', 'Esthetician', selectedSpecialist),
                        const SizedBox(width: 12),
                        _buildSpecialistTile(ref, 'Marc Laurent', 'Masseur', selectedSpecialist),
                        const SizedBox(width: 12),
                        _buildSpecialistTile(ref, 'Elana Morel', 'Nails Artist', selectedSpecialist),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Time Slots selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Time Slots', style: AppTextStyles.titleMedium(color: AppColors.primaryDark)),
                  AppSpacing.gapSM,
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: timeSlots.map((time) {
                      final isSelected = selectedTime == time;
                      return ChoiceChip(
                        label: Text(time),
                        selected: isSelected,
                        selectedColor: AppColors.primaryLight,
                        backgroundColor: cs.surface,
                        labelStyle: AppTextStyles.titleSmall(color: isSelected ? AppColors.primaryDark : AppColors.textMedium),
                        checkmarkColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderMD,
                          side: BorderSide(color: isSelected ? AppColors.primaryAccent : AppColors.border),
                        ),
                        onSelected: (val) {
                          if (val) ref.read(selectedTimeSlotProvider.notifier).state = time;
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Payment Method Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Payment Method', style: AppTextStyles.titleMedium(color: AppColors.primaryDark)),
                  AppSpacing.gapSM,
                  const Row(
                    children: [
                      Expanded(child: ChoiceChip(label: Text('Pay at Salon'), selected: true, selectedColor: AppColors.primaryLight)),
                      SizedBox(width: 8),
                      Expanded(child: ChoiceChip(label: Text('Visa *4242'), selected: false)),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapXL,

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTime == null
                    ? null
                    : () {
                  final appointment = AppointmentModel(
                    id: 'a_user_${DateTime.now().millisecondsSinceEpoch}',
                    salonName: 'Maison de Beauté',
                    salonAddress: '22 Rue de la Paix, Paris',
                    serviceName: serviceName,
                    durationMinutes: serviceDuration,
                    price: servicePrice,
                    dateTime: DateTime(
                      selectedDate.year, selectedDate.month, selectedDate.day,
                      int.parse(selectedTime.split(':').first) + (selectedTime.contains('PM') && !selectedTime.startsWith('12') ? 12 : 0),
                    ),
                    providerName: selectedSpecialist,
                    status: 'confirmed',
                    customerName: 'Charlotte Dubois',
                    customerInitial: 'CD',
                  );
                  ref.read(appointmentsProvider.notifier).addAppointment(appointment);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: cs.surface,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                            child: const Icon(Icons.check, size: 40, color: AppColors.primaryDark),
                          ),
                          AppSpacing.gapLG,
                          Text('Appointment Confirmed!', style: AppTextStyles.h2()),
                          AppSpacing.gapSM,
                          Text('Your appointment for $serviceName is scheduled with $selectedSpecialist at $selectedTime.', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium()),
                          AppSpacing.gapLG,
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () { context.pop(); context.pop(); context.go(Routes.customerBookings); },
                              child: const Text('View Bookings'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: AppColors.surface,
                ),
                child: const Text('Confirm Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistTile(WidgetRef ref, String name, String role, String selectedName) {
    final isSelected = selectedName == name;
    return GestureDetector(
      onTap: () => ref.read(selectedSpecialistProvider.notifier).state = name,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: AppRadius.borderMD,
          border: Border.all(color: isSelected ? AppColors.primaryAccent : AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 16, backgroundColor: AppColors.cardBg, child: Icon(Icons.person, size: 16, color: AppColors.primaryDark)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name.split(' ').first, style: AppTextStyles.titleSmall().copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(role, style: AppTextStyles.bodySmall(color: AppColors.textMedium).copyWith(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}