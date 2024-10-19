import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    String url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&lang=pt';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final data = json.decode(response.body);
        print('🟩 GET WEATHER SUCCESS');
        return data; // Retorna os dados decodificados
      } else {
        print('🟥 GET WEATHER ERROR: ${response.statusCode}');
        return null; // Em caso de erro, retorna null
      }
    } catch (e) {
      print('🟥 GET WEATHER ERROR: $e');
      return null; // Em caso de erro na requisição, retorna null
    }
  }
}
