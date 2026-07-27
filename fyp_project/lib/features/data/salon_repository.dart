import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/salon_model.dart';
import '../../../shared/service_model.dart';

final salonRepositoryProvider = Provider<SalonRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SalonRepository(dioClient);
});

class SalonRepository {
  final DioClient _dioClient;

  SalonRepository(this._dioClient);

  /// Helper to convert backend JSON to SalonModel safely
  SalonModel _mapToSalonModel(Map<String, dynamic> json) {
    List<ServiceModel> services = [];
    if (json['services'] != null && json['services'] is List) {
      services = (json['services'] as List).map((s) => _mapToServiceModel(s as Map<String, dynamic>)).toList();
    }

    return SalonModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Salon',
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString() ?? 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500',
      rating: (json['average_rating'] ?? json['rating'] ?? 4.5).toDouble(),
      reviewsCount: (json['review_count'] ?? json['reviewsCount'] ?? 0).toInt(),
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'LUXURY SPA',
      city: json['city']?.toString() ?? json['location']?.toString() ?? 'PARIS',
      address: json['address']?.toString() ?? json['location']?.toString() ?? '',
      services: services,
    );
  }

  /// Helper to convert backend JSON to ServiceModel safely
  ServiceModel _mapToServiceModel(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Service',
      description: json['description']?.toString() ?? '',
      durationMinutes: (json['duration'] ?? json['durationMinutes'] ?? 30).toInt(),
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category']?.toString(),
    );
  }

  /// Fetch list of salons with optional search/category filters
  Future<List<SalonModel>> fetchSalons({
    String? location,
    String? q,
    String? category,
    double? minRating,
    double? priceMax,
  }) async {
    final queryParams = <String, dynamic>{};
    if (location != null && location.isNotEmpty) queryParams['location'] = location;
    if (q != null && q.isNotEmpty) queryParams['q'] = q;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (minRating != null) queryParams['min_rating'] = minRating;
    if (priceMax != null) queryParams['price_max'] = priceMax;

    final response = await _dioClient.get(
      ApiConstants.salons,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final list = response.data as List;
    return list.map((item) => _mapToSalonModel(item as Map<String, dynamic>)).toList();
  }

  /// Fetch detailed salon by ID
  Future<SalonModel> fetchSalonDetails(String salonId) async {
    final response = await _dioClient.get(ApiConstants.salonDetails(salonId));
    return _mapToSalonModel(response.data as Map<String, dynamic>);
  }

  /// Fetch services for a specific salon
  Future<List<ServiceModel>> fetchSalonServices(String salonId) async {
    final response = await _dioClient.get(ApiConstants.salonServices(salonId));
    final list = response.data as List;
    return list.map((item) => _mapToServiceModel(item as Map<String, dynamic>)).toList();
  }

  /// Fetch available booking slots for a salon on a given date (YYYY-MM-DD)
  Future<List<String>> fetchAvailableSlots(String salonId, String date) async {
    final response = await _dioClient.get(
      ApiConstants.salonSlots(salonId),
      queryParameters: {'date': date},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['available_slots'] != null) {
      return List<String>.from(data['available_slots']);
    }
    return [];
  }
}
