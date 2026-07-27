import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/service_model.dart';
import '../../shared/appointment_model.dart';
import '../data/appointment_repository.dart';

/// Provider holding the service selected for booking.
final selectedServiceProvider = StateProvider<ServiceModel?>((ref) => null);

/// Provider holding the selected booking date.
final selectedBookingDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Provider holding the selected time slot.
final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);

/// Provider holding the selected specialist/staff.
final selectedSpecialistProvider = StateProvider<String>((ref) => 'Senior Esthetician Sarah Jenkins');

/// StateNotifier to manage user appointments with backend sync
class AppointmentsNotifier extends StateNotifier<List<AppointmentModel>> {
  final AppointmentRepository? _repository;

  AppointmentsNotifier([this._repository]) : super(_initialAppointments) {
    refreshAppointments();
  }

  static final List<AppointmentModel> _initialAppointments = [];

  Future<void> refreshAppointments() async {
    final repo = _repository;
    if (repo == null) return;
    try {
      final backendAppointments = await repo.fetchAppointments();
      state = backendAppointments;
    } catch (e) {
      // On error, we could set state to [] or keep existing, we keep existing for now.
    }
  }

  Future<bool> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime date,
    required String time,
    String paymentMethod = 'cash',
  }) async {
    final repo = _repository;
    if (repo == null) return false;
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      final newApt = await repo.bookAppointment(
        salonId: salonId,
        serviceId: serviceId,
        date: dateStr,
        time: time,
        paymentMethod: paymentMethod,
      );
      state = [newApt, ...state];
      return true;
    } catch (e) {
      return false;
    }
  }

  void addAppointment(AppointmentModel appointment) {
    state = [appointment, ...state];
  }

  Future<void> cancelAppointment(String id) async {
    state = state.map((app) => app.id == id ? app.copyWith(status: 'cancelled') : app).toList();
    final repo = _repository;
    if (repo == null) return;
    try {
      await repo.updateStatus(id, 'cancelled');
    } catch (_) {}
  }

  Future<void> acceptAppointment(String id) async {
    state = state.map((app) => app.id == id ? app.copyWith(status: 'confirmed') : app).toList();
    final repo = _repository;
    if (repo == null) return;
    try {
      await repo.updateStatus(id, 'confirmed');
    } catch (_) {}
  }

  Future<void> declineAppointment(String id) async {
    state = state.map((app) => app.id == id ? app.copyWith(status: 'cancelled') : app).toList();
    final repo = _repository;
    if (repo == null) return;
    try {
      await repo.updateStatus(id, 'cancelled');
    } catch (_) {}
  }

  Future<void> rescheduleAppointment(String id, DateTime newDateTime) async {
    state = state.map((app) => app.id == id ? app.copyWith(dateTime: newDateTime, status: 'pending') : app).toList();
    final repo = _repository;
    if (repo == null) return;
    try {
      final dateStr = '${newDateTime.year}-${newDateTime.month.toString().padLeft(2, '0')}-${newDateTime.day.toString().padLeft(2, '0')}';
      final timeStr = '${newDateTime.hour.toString().padLeft(2, '0')}:${newDateTime.minute.toString().padLeft(2, '0')}';
      await repo.reschedule(id, dateStr, timeStr);
    } catch (_) {}
  }
}

/// Provider for customer appointments connected to backend
final appointmentsProvider = StateNotifierProvider<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  final repo = ref.watch(appointmentRepositoryProvider);
  return AppointmentsNotifier(repo);
});
