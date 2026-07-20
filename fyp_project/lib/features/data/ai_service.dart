import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  // Backend URL
  static const String baseUrl = "http://192.168.1.5:8000";

  // ======================
  // AI CHAT
  // ======================
  Future<String> chat(String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? '';
    }

    throw Exception('Failed to get AI response');
  }

  // ======================
  // SKIN ANALYSIS
  // ======================
  Future<Map<String, dynamic>> analyzeSkin(
      File image,
      String token,
      ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/skin-analysis'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body);
    }

    throw Exception(body);
  }

  // ======================
  // HAIR ANALYSIS
  // ======================
  Future<Map<String, dynamic>> analyzeHair(
      File image,
      String token,
      ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/hair-analysis'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body);
    }

    throw Exception(body);
  }

  // ======================
  // FACE ANALYSIS
  // ======================
  Future<Map<String, dynamic>> analyzeFace(
      File image,
      String token,
      ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze-face'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body);
    }

    throw Exception(body);
  }
}