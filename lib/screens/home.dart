import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apiKey = 'e00fd1162c57450e8e6122323241810';
  String city = 'Barueri'; // Cidade para buscar o clima
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeather() async {
    String url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&lang=pt';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final data = json.decode(response.body);
        setState(() {
          weatherData = data;
        });

        print('🟩 GET WEATHER SUCCESS');
      } else {
        print('🟥 GET WEATHER ERROR: ${response.statusCode}');
      }
    } catch (e) {
      print('🟥 GET WEATHER ERROR:: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(); // Faz a requisição quando a tela é inicializada
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Define a cor da barra de status
        statusBarIconBrightness:
            Brightness.dark, // Define a cor dos ícones da barra (ícones claros)
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.orange,
                        size: 32,
                      ),
                      Text(
                        '${weatherData!['location']['name']}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  weatherData == null
                      ? const CircularProgressIndicator() // Mostra indicador de carregamento enquanto espera a API
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https:${weatherData!['current']['condition']['icon']}', // URL do ícone
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '${weatherData!['current']['temp_c']} °C',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                              ],
                            )
                          ],
                        ),
                ],
              )),
        ),
      ),
    );
  }
}
