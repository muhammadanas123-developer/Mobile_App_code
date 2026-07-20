// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
    Map<String, dynamic> json,
    ) => _$AppointmentModelImpl(
  id: json['id'] as String,
  salonName: json['salonName'] as String,
  salonAddress: json['salonAddress'] as String,
  serviceName: json['serviceName'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  dateTime: DateTime.parse(json['dateTime'] as String),
  providerName: json['providerName'] as String,
  status: json['status'] as String,
  customerName: json['customerName'] as String,
  customerInitial: json['customerInitial'] as String?,
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
    _$AppointmentModelImpl instance,
    ) => <String, dynamic>{
  'id': instance.id,
  'salonName': instance.salonName,
  'salonAddress': instance.salonAddress,
  'serviceName': instance.serviceName,
  'durationMinutes': instance.durationMinutes,
  'price': instance.price,
  'dateTime': instance.dateTime.toIso8601String(),
  'providerName': instance.providerName,
  'status': instance.status,
  'customerName': instance.customerName,
  'customerInitial': instance.customerInitial,
};