import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class AIApiService {
  static const String baseUrl =
      'http://YOUR_IP:8000/api/ai';

  Future<String> sendChatMessage(String message) async {
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

  Future<Map<String, dynamic>> analyzeSkin(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/skin-analysis'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Skin analysis failed');
  }

  Future<Map<String, dynamic>> analyzeHair(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/hair-analysis'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Hair analysis failed');
  }

  Future<Map<String, dynamic>> analyzeFace(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze-face'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Face analysis failed');
  }
}