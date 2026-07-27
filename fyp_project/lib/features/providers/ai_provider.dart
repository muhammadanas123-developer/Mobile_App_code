import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_api_service.dart';

/// Provider exposing AIApiService connected to FastAPI backend
final aiServiceProvider = Provider<AIApiService>((ref) {
  return ref.watch(aiApiServiceProvider);
});
