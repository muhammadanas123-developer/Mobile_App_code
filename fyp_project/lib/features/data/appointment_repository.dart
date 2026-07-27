import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/appointment_model.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AppointmentRepository(dioClient);
});

class AppointmentRepository {
  final DioClient _dioClient;

  AppointmentRepository(this._dioClient);

  /// Helper to convert backend JSON to AppointmentModel safely
  AppointmentModel _mapToAppointmentModel(Map<String, dynamic> json) {
    String dateStr = json['date']?.toString() ?? DateTime.now().toString().split(' ')[0];
    String timeStr = json['time']?.toString() ?? '12:00:00';
    if (timeStr.length == 5) timeStr += ':00';

    DateTime dateTime;
    try {
      dateTime = DateTime.parse('${dateStr}T$timeStr');
    } catch (_) {
      dateTime = DateTime.now();
    }

    String custName = json['customerName']?.toString() ?? json['customer_name']?.toString() ?? 'Customer';
    String initial = custName.isNotEmpty ? custName[0].toUpperCase() : 'C';

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      salonName: json['businessName']?.toString() ?? json['salonName']?.toString() ?? 'Salon',
      salonAddress: json['salonAddress']?.toString() ?? 'Salon Location',
      serviceName: json['serviceName']?.toString() ?? 'Beauty Treatment',
      durationMinutes: (json['duration'] ?? json['durationMinutes'] ?? 30).toInt(),
      price: (json['price'] ?? 0.0).toDouble(),
      dateTime: dateTime,
      providerName: json['staffName']?.toString() ?? json['providerName']?.toString() ?? 'Specialist',
      status: json['status']?.toString() ?? 'pending',
      customerName: custName,
      customerInitial: initial,
    );
  }

  /// Create a new booking
  Future<AppointmentModel> bookAppointment({
    required String salonId,
    required String serviceId,
    required String date,
    required String time,
    String paymentMethod = 'cash',
    String? notes,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.appointments,
      data: {
        'salon_id': salonId,
        'service_id': serviceId,
        'date': date,
        'time': time,
        'booking_type': 'online',
        'payment_method': paymentMethod,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );

    final data = response.data['appointment'] ?? response.data;
    return _mapToAppointmentModel(data as Map<String, dynamic>);
  }

  /// Fetch all user/owner appointments from backend
  Future<List<AppointmentModel>> fetchAppointments() async {
    final response = await _dioClient.get(ApiConstants.appointments);
    final list = response.data as List;
    return list.map((item) => _mapToAppointmentModel(item as Map<String, dynamic>)).toList();
  }

  /// Update status (e.g., 'cancelled', 'confirmed', 'completed')
  Future<AppointmentModel> updateStatus(String appointmentId, String newStatus) async {
    final response = await _dioClient.put(
      ApiConstants.appointmentStatus(appointmentId),
      data: {'status': newStatus},
    );

    final data = response.data['appointment'] ?? response.data;
    return _mapToAppointmentModel(data as Map<String, dynamic>);
  }

  /// Reschedule appointment to a new date and time
  Future<AppointmentModel> reschedule(String appointmentId, String date, String time) async {
    final response = await _dioClient.put(
      ApiConstants.appointmentReschedule(appointmentId),
      data: {
        'date': date,
        'time': time,
      },
    );

    final data = response.data['appointment'] ?? response.data;
    return _mapToAppointmentModel(data as Map<String, dynamic>);
  }
}
