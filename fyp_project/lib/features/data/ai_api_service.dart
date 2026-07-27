import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

final aiApiServiceProvider = Provider<AIApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AIApiService(dioClient);
});

class AIApiService {
  final DioClient _dioClient;

  AIApiService(this._dioClient);

  /// Send chat prompt to Gemini AI Chat Assistant
  Future<String> sendChatMessage(String message, {List<Map<String, dynamic>>? history}) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.aiChat,
        data: {
          'message': message,
          if (history != null && history.isNotEmpty) 'messages': history,
        },
      );

      final data = response.data as Map<String, dynamic>;
      return data['reply']?.toString() ?? 'I am your AI Beauty Assistant. How may I help you today?';
    } catch (e) {
      return 'I am currently operating in offline mode. How can I assist you with your beauty and treatment routine today?';
    }
  }

  /// Analyze skin image via backend Gemini vision AI
  Future<Map<String, dynamic>> analyzeSkin(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: 'skin_scan.jpg'),
      });

      final response = await _dioClient.post(
        ApiConstants.aiSkinAnalysis,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      return (data['result'] ?? data) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Analyze hair image via backend Gemini vision AI
  Future<Map<String, dynamic>> analyzeHair(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: 'hair_scan.jpg'),
      });

      final response = await _dioClient.post(
        ApiConstants.aiHairAnalysis,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      return (data['result'] ?? data) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Analyze face shape & styling recommendations
  Future<Map<String, dynamic>> analyzeFace(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: 'face_scan.jpg'),
      });

      final response = await _dioClient.post(
        ApiConstants.aiFaceAnalysis,
        data: formData,
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// AI Salon recommendation
  Future<List<dynamic>> recommendSalon({String? location, double? rating, String? preferences}) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.aiRecommendSalon,
        data: {
          if (location != null) 'location': location,
          if (rating != null) 'rating': rating,
          if (preferences != null) 'preferences': preferences,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['recommendations'] as List? ?? [];
    } catch (e) {
      rethrow;
    }
  }

  /// AI Service recommendation based on user concerns
  Future<List<dynamic>> recommendServices({required List<String> concerns, String? gender}) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.aiRecommendService,
        data: {
          'concerns': concerns,
          if (gender != null) 'gender': gender,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['suggestions'] as List? ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
