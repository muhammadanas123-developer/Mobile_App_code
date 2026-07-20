// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonModelImpl _$$SalonModelImplFromJson(Map<String, dynamic> json) =>
    _$SalonModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviewsCount'] as num).toInt(),
      description: json['description'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
    );

Map<String, dynamic> _$$SalonModelImplToJson(_$SalonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'description': instance.description,
      'category': instance.category,
      'city': instance.city,
      'address': instance.address,
      'services': instance.services,
    };