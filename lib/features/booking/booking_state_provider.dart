import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/service_model.dart';
import '../../../shared/appointment_model.dart';

/// Provider holding the service selected for booking.
final selectedServiceProvider = StateProvider<ServiceModel?>((ref) => null);

/// Provider holding the selected booking date.
final selectedBookingDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Provider holding the selected time slot.
final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);

/// Provider holding the selected specialist/staff.
final selectedSpecialistProvider = StateProvider<String>((ref) => 'Senior Esthetician Sarah Jenkins');

/// StateNotifier to manage user appointments
class AppointmentsNotifier extends StateNotifier<List<AppointmentModel>> {
  AppointmentsNotifier() : super(_initialAppointments);

  static final List<AppointmentModel> _initialAppointments = [
    AppointmentModel(
      id: 'a_mock_1',
      salonName: 'Maison de Beauté',
      salonAddress: '22 Rue de la Paix, Paris',
      serviceName: 'Botanical Glow Facial',
      durationMinutes: 90,
      price: 145.00,
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 4)),
      providerName: 'Senior Esthetician Sarah Jenkins',
      status: 'confirmed',
      customerName: 'Charlotte Dubois',
      customerInitial: 'CD',
    ),
    AppointmentModel(
      id: 'a_mock_2',
      salonName: 'Maison de Beauté',
      salonAddress: '22 Rue de la Paix, Paris',
      serviceName: 'Deep Tissue Massage',
      durationMinutes: 60,
      price: 120.00,
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      providerName: 'Specialist Marc Laurent',
      status: 'completed',
      customerName: 'Charlotte Dubois',
      customerInitial: 'CD',
    ),
    AppointmentModel(
      id: 'a_pending_1',
      salonName: 'Maison de Beauté',
      salonAddress: '22 Rue de la Paix, Paris',
      serviceName: 'Forest Zen Massage',
      durationMinutes: 90,
      price: 180.00,
      dateTime: DateTime.now().add(const Duration(hours: 24)),
      providerName: 'Specialist Marc Laurent',
      status: 'pending',
      customerName: 'Lucas Martin',
      customerInitial: 'LM',
    ),
    AppointmentModel(
      id: 'a_pending_2',
      salonName: 'Maison de Beauté',
      salonAddress: '22 Rue de la Paix, Paris',
      serviceName: 'Signature Hair Balayage',
      durationMinutes: 120,
      price: 210.00,
      dateTime: DateTime.now().add(const Duration(hours: 48)),
      providerName: 'Senior Esthetician Sarah Jenkins',
      status: 'pending',
      customerName: 'Emma Bernard',
      customerInitial: 'EB',
    ),
  ];

  void addAppointment(AppointmentModel appointment) {
    state = [appointment, ...state];
  }

  void cancelAppointment(String id) {
    state = state.map((app) {
      if (app.id == id) {
        return app.copyWith(status: 'cancelled');
      }
      return app;
    }).toList();
  }

  void acceptAppointment(String id) {
    state = state.map((app) {
      if (app.id == id) {
        return app.copyWith(status: 'confirmed');
      }
      return app;
    }).toList();
  }

  void declineAppointment(String id) {
    state = state.map((app) {
      if (app.id == id) {
        return app.copyWith(status: 'declined');
      }
      return app;
    }).toList();
  }

  void rescheduleAppointment(String id, DateTime newDateTime) {
    state = state.map((app) {
      if (app.id == id) {
        return app.copyWith(dateTime: newDateTime, status: 'confirmed');
      }
      return app;
    }).toList();
  }
}

/// Provider for customer appointments
final appointmentsProvider = StateNotifierProvider<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  return AppointmentsNotifier();
});