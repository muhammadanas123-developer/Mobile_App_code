import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_model.dart';

part 'salon_model.freezed.dart';
part 'salon_model.g.dart';

@freezed
class SalonModel with _$SalonModel {
  const factory SalonModel({
    required String id,
    required String name,
    required String imageUrl,
    required double rating,
    required int reviewsCount,
    required String description,
    required String category, // e.g. LUXURY SPA
    required String city, // e.g. PARIS
    required String address,
    @Default([]) List<ServiceModel> services,
  }) = _SalonModel;

  factory SalonModel.fromJson(Map<String, dynamic> json) => _$SalonModelFromJson(json);
}