import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which salon IDs are favorited by the current user.
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String salonId) {
    if (state.contains(salonId)) {
      state = state.where((id) => id != salonId).toSet();
    } else {
      state = {...state, salonId};
    }
  }

  bool isFavorited(String salonId) => state.contains(salonId);
}