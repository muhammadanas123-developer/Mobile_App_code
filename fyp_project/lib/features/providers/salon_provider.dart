import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/salon_model.dart';
import '../data/salon_repository.dart';

/// Provider to fetch all salons with optional search/filter parameters
final salonsProvider = FutureProvider.family<List<SalonModel>, Map<String, dynamic>?>((ref, filters) async {
  final repo = ref.watch(salonRepositoryProvider);
  try {
    return await repo.fetchSalons(
      location: filters?['location'],
      q: filters?['q'],
      category: filters?['category'],
      minRating: filters?['min_rating'],
      priceMax: filters?['price_max'],
    );
  } catch (e) {
    // Return empty list or rethrow depending on UI requirements
    return [];
  }
});

/// Provider for detailed salon info by salon ID
final salonDetailProvider = FutureProvider.family<SalonModel?, String>((ref, salonId) async {
  if (salonId.isEmpty) return null;
  final repo = ref.watch(salonRepositoryProvider);
  try {
    return await repo.fetchSalonDetails(salonId);
  } catch (e) {
    return null;
  }
});

/// Provider for salon available slots on a specific date
final availableSlotsProvider = FutureProvider.family<List<String>, Map<String, String>>((ref, params) async {
  final salonId = params['salonId'] ?? '';
  final date = params['date'] ?? '';
  if (salonId.isEmpty || date.isEmpty) return [];

  final repo = ref.watch(salonRepositoryProvider);
  try {
    return await repo.fetchAvailableSlots(salonId, date);
  } catch (e) {
    return ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'];
  }
});
