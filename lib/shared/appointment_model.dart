import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    required String salonName,
    required String salonAddress,
    required String serviceName,
    required int durationMinutes,
    required double price,
    required DateTime dateTime,
    required String providerName,
    required String status, // 'pending', 'confirmed', 'completed', 'cancelled'
    required String customerName,
    String? customerInitial,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);
}