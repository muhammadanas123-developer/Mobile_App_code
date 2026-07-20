// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonModel _$SalonModelFromJson(Map<String, dynamic> json) {
  return _SalonModel.fromJson(json);
}

/// @nodoc
mixin _$SalonModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError; // e.g. LUXURY SPA
  String get city => throw _privateConstructorUsedError; // e.g. PARIS
  String get address => throw _privateConstructorUsedError;
  List<ServiceModel> get services => throw _privateConstructorUsedError;

  /// Serializes this SalonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonModelCopyWith<SalonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonModelCopyWith<$Res> {
  factory $SalonModelCopyWith(
      SalonModel value,
      $Res Function(SalonModel) then,
      ) = _$SalonModelCopyWithImpl<$Res, SalonModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String imageUrl,
    double rating,
    int reviewsCount,
    String description,
    String category,
    String city,
    String address,
    List<ServiceModel> services,
  });
}

/// @nodoc
class _$SalonModelCopyWithImpl<$Res, $Val extends SalonModel>
    implements $SalonModelCopyWith<$Res> {
  _$SalonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? description = null,
    Object? category = null,
    Object? city = null,
    Object? address = null,
    Object? services = null,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
        as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
        as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
        as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
        as double,
        reviewsCount: null == reviewsCount
            ? _value.reviewsCount
            : reviewsCount // ignore: cast_nullable_to_non_nullable
        as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
        as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
        as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
        as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
        as String,
        services: null == services
            ? _value.services
            : services // ignore: cast_nullable_to_non_nullable
        as List<ServiceModel>,
      )
      as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonModelImplCopyWith<$Res>
    implements $SalonModelCopyWith<$Res> {
  factory _$$SalonModelImplCopyWith(
      _$SalonModelImpl value,
      $Res Function(_$SalonModelImpl) then,
      ) = __$$SalonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String imageUrl,
    double rating,
    int reviewsCount,
    String description,
    String category,
    String city,
    String address,
    List<ServiceModel> services,
  });
}

/// @nodoc
class __$$SalonModelImplCopyWithImpl<$Res>
    extends _$SalonModelCopyWithImpl<$Res, _$SalonModelImpl>
    implements _$$SalonModelImplCopyWith<$Res> {
  __$$SalonModelImplCopyWithImpl(
      _$SalonModelImpl _value,
      $Res Function(_$SalonModelImpl) _then,
      ) : super(_value, _then);

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? description = null,
    Object? category = null,
    Object? city = null,
    Object? address = null,
    Object? services = null,
  }) {
    return _then(
      _$SalonModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
        as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
        as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
        as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
        as double,
        reviewsCount: null == reviewsCount
            ? _value.reviewsCount
            : reviewsCount // ignore: cast_nullable_to_non_nullable
        as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
        as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
        as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
        as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
        as String,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
        as List<ServiceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonModelImpl implements _SalonModel {
  const _$SalonModelImpl({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.category,
    required this.city,
    required this.address,
    final List<ServiceModel> services = const [],
  }) : _services = services;

  factory _$SalonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String imageUrl;
  @override
  final double rating;
  @override
  final int reviewsCount;
  @override
  final String description;
  @override
  final String category;
  // e.g. LUXURY SPA
  @override
  final String city;
  // e.g. PARIS
  @override
  final String address;
  final List<ServiceModel> _services;
  @override
  @JsonKey()
  List<ServiceModel> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'SalonModel(id: $id, name: $name, imageUrl: $imageUrl, rating: $rating, reviewsCount: $reviewsCount, description: $description, category: $category, city: $city, address: $address, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    imageUrl,
    rating,
    reviewsCount,
    description,
    category,
    city,
    address,
    const DeepCollectionEquality().hash(_services),
  );

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonModelImplCopyWith<_$SalonModelImpl> get copyWith =>
      __$$SalonModelImplCopyWithImpl<_$SalonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonModelImplToJson(this);
  }
}

abstract class _SalonModel implements SalonModel {
  const factory _SalonModel({
    required final String id,
    required final String name,
    required final String imageUrl,
    required final double rating,
    required final int reviewsCount,
    required final String description,
    required final String category,
    required final String city,
    required final String address,
    final List<ServiceModel> services,
  }) = _$SalonModelImpl;

  factory _SalonModel.fromJson(Map<String, dynamic> json) =
  _$SalonModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imageUrl;
  @override
  double get rating;
  @override
  int get reviewsCount;
  @override
  String get description;
  @override
  String get category; // e.g. LUXURY SPA
  @override
  String get city; // e.g. PARIS
  @override
  String get address;
  @override
  List<ServiceModel> get services;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonModelImplCopyWith<_$SalonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}