import 'dart:convert';
import 'package:clothing_identifier/models/clothing.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<Map<String, dynamic>> getFeatures(String imageUrl) async {
    final response = await http.post(
      Uri.parse('YOUR_OPENAI_API_ENDPOINT'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'image': imageUrl}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get features');
    }
  }

  static Future<void> saveClothing(Clothing clothing) async {
    final client = http.Client();

    final response = await client.post(
      Uri.parse('YOUR_SUPABASE_API_ENDPOINT'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(clothing.toJson()),
    );

    if (response.statusCode == 200) {
      print('Clothing saved successfully');
    } else {
      throw Exception('Failed to save clothing');
    }
  }
}
