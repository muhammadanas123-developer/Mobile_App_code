import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FavoritesRepository(dioClient);
});

class FavoritesRepository {
  final DioClient _dioClient;

  FavoritesRepository(this._dioClient);

  /// Fetch favorite salon IDs for current user
  Future<Set<String>> fetchFavorites() async {
    try {
      final response = await _dioClient.get(ApiConstants.favorites);
      final list = response.data as List;
      final ids = <String>{};
      for (var item in list) {
        if (item is Map && item['salon_id'] != null) {
          ids.add(item['salon_id'].toString());
        } else if (item is Map && item['id'] != null) {
          ids.add(item['id'].toString());
        }
      }
      return ids;
    } catch (e) {
      return {};
    }
  }

  /// Add salon to favorites
  Future<void> addFavorite(String salonId) async {
    try {
      await _dioClient.post(ApiConstants.favoriteSalon(salonId));
    } catch (_) {}
  }

  /// Remove salon from favorites
  Future<void> removeFavorite(String salonId) async {
    try {
      await _dioClient.delete(ApiConstants.favoriteSalon(salonId));
    } catch (_) {}
  }
}
