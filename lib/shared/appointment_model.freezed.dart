// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) {
  return _AppointmentModel.fromJson(json);
}

/// @nodoc
mixin _$AppointmentModel {
  String get id => throw _privateConstructorUsedError;
  String get salonName => throw _privateConstructorUsedError;
  String get salonAddress => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  String get providerName => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'confirmed', 'completed', 'cancelled'
  String get customerName => throw _privateConstructorUsedError;
  String? get customerInitial => throw _privateConstructorUsedError;

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentModelCopyWith<AppointmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentModelCopyWith<$Res> {
  factory $AppointmentModelCopyWith(
      AppointmentModel value,
      $Res Function(AppointmentModel) then,
      ) = _$AppointmentModelCopyWithImpl<$Res, AppointmentModel>;
  @useResult
  $Res call({
    String id,
    String salonName,
    String salonAddress,
    String serviceName,
    int durationMinutes,
    double price,
    DateTime dateTime,
    String providerName,
    String status,
    String customerName,
    String? customerInitial,
  });
}

/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res, $Val extends AppointmentModel>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonName = null,
    Object? salonAddress = null,
    Object? serviceName = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? dateTime = null,
    Object? providerName = null,
    Object? status = null,
    Object? customerName = null,
    Object? customerInitial = freezed,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
        as String,
        salonName: null == salonName
            ? _value.salonName
            : salonName // ignore: cast_nullable_to_non_nullable
        as String,
        salonAddress: null == salonAddress
            ? _value.salonAddress
            : salonAddress // ignore: cast_nullable_to_non_nullable
        as String,
        serviceName: null == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
        as String,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
        as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
        as double,
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
        as DateTime,
        providerName: null == providerName
            ? _value.providerName
            : providerName // ignore: cast_nullable_to_non_nullable
        as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
        as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
        as String,
        customerInitial: freezed == customerInitial
            ? _value.customerInitial
            : customerInitial // ignore: cast_nullable_to_non_nullable
        as String?,
      )
      as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentModelImplCopyWith<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  factory _$$AppointmentModelImplCopyWith(
      _$AppointmentModelImpl value,
      $Res Function(_$AppointmentModelImpl) then,
      ) = __$$AppointmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonName,
    String salonAddress,
    String serviceName,
    int durationMinutes,
    double price,
    DateTime dateTime,
    String providerName,
    String status,
    String customerName,
    String? customerInitial,
  });
}

/// @nodoc
class __$$AppointmentModelImplCopyWithImpl<$Res>
    extends _$AppointmentModelCopyWithImpl<$Res, _$AppointmentModelImpl>
    implements _$$AppointmentModelImplCopyWith<$Res> {
  __$$AppointmentModelImplCopyWithImpl(
      _$AppointmentModelImpl _value,
      $Res Function(_$AppointmentModelImpl) _then,
      ) : super(_value, _then);

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonName = null,
    Object? salonAddress = null,
    Object? serviceName = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? dateTime = null,
    Object? providerName = null,
    Object? status = null,
    Object? customerName = null,
    Object? customerInitial = freezed,
  }) {
    return _then(
      _$AppointmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
        as String,
        salonName: null == salonName
            ? _value.salonName
            : salonName // ignore: cast_nullable_to_non_nullable
        as String,
        salonAddress: null == salonAddress
            ? _value.salonAddress
            : salonAddress // ignore: cast_nullable_to_non_nullable
        as String,
        serviceName: null == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
        as String,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
        as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
        as double,
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
        as DateTime,
        providerName: null == providerName
            ? _value.providerName
            : providerName // ignore: cast_nullable_to_non_nullable
        as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
        as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
        as String,
        customerInitial: freezed == customerInitial
            ? _value.customerInitial
            : customerInitial // ignore: cast_nullable_to_non_nullable
        as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentModelImpl implements _AppointmentModel {
  const _$AppointmentModelImpl({
    required this.id,
    required this.salonName,
    required this.salonAddress,
    required this.serviceName,
    required this.durationMinutes,
    required this.price,
    required this.dateTime,
    required this.providerName,
    required this.status,
    required this.customerName,
    this.customerInitial,
  });

  factory _$AppointmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String salonName;
  @override
  final String salonAddress;
  @override
  final String serviceName;
  @override
  final int durationMinutes;
  @override
  final double price;
  @override
  final DateTime dateTime;
  @override
  final String providerName;
  @override
  final String status;
  // 'pending', 'confirmed', 'completed', 'cancelled'
  @override
  final String customerName;
  @override
  final String? customerInitial;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, salonName: $salonName, salonAddress: $salonAddress, serviceName: $serviceName, durationMinutes: $durationMinutes, price: $price, dateTime: $dateTime, providerName: $providerName, status: $status, customerName: $customerName, customerInitial: $customerInitial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonName, salonName) ||
                other.salonName == salonName) &&
            (identical(other.salonAddress, salonAddress) ||
                other.salonAddress == salonAddress) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerInitial, customerInitial) ||
                other.customerInitial == customerInitial));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonName,
    salonAddress,
    serviceName,
    durationMinutes,
    price,
    dateTime,
    providerName,
    status,
    customerName,
    customerInitial,
  );

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      __$$AppointmentModelImplCopyWithImpl<_$AppointmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentModelImplToJson(this);
  }
}

abstract class _AppointmentModel implements AppointmentModel {
  const factory _AppointmentModel({
    required final String id,
    required final String salonName,
    required final String salonAddress,
    required final String serviceName,
    required final int durationMinutes,
    required final double price,
    required final DateTime dateTime,
    required final String providerName,
    required final String status,
    required final String customerName,
    final String? customerInitial,
  }) = _$AppointmentModelImpl;

  factory _AppointmentModel.fromJson(Map<String, dynamic> json) =
  _$AppointmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get salonName;
  @override
  String get salonAddress;
  @override
  String get serviceName;
  @override
  int get durationMinutes;
  @override
  double get price;
  @override
  DateTime get dateTime;
  @override
  String get providerName;
  @override
  String get status; // 'pending', 'confirmed', 'completed', 'cancelled'
  @override
  String get customerName;
  @override
  String? get customerInitial;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}