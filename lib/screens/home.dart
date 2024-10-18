import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apiKey = 'e00fd1162c57450e8e6122323241810';
  String city = 'Carapicuiba'; // Cidade para buscar o clima
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeather() async {
    String url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Clima Go',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          // Adicione aqui a funcionalidade do botão
                        },
                      ),
                    ],
                  ),
                  weatherData == null
                      ? const CircularProgressIndicator() // Mostra indicador de carregamento enquanto espera a API
                      : Column(
                          children: [
                            Text(
                              'Cidade: ${weatherData!['location']['name']}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Temperatura: ${weatherData!['current']['temp_c']} °C',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                ],
              )),
        ),
      ),
    );
  }
}
