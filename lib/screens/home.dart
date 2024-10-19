import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apiKey = 'e00fd1162c57450e8e6122323241810';
  Map<String, dynamic>? weatherData;
  String city = 'Barueri';
  final TextEditingController _cityController = TextEditingController();

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

  Future<void> _showCityDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nome da cidade'),
          content: TextField(
            controller: _cityController,
            decoration: const InputDecoration(hintText: ''),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  city = _cityController.text;
                });
                Navigator.of(context).pop();
                fetchWeather();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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

    String formattedDate = weatherData == null
        ? '-'
        : DateFormat('dd MMMM, EEEE', 'pt_BR')
            .format(DateTime.parse(weatherData!['location']['localtime']));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: weatherData == null
              ? const CircularProgressIndicator() // Mostra indicador de carregamento enquanto espera a API
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap:
                                    _showCityDialog, // Abre o diálogo ao clicar no nome da cidade
                                child: Text(
                                  '${weatherData!['location']['name']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          IconButton(
                              color: Colors.orange,
                              onPressed: _showCityDialog,
                              icon: const Icon(Icons.search, size: 24))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weatherData!['current']['temp_c'].toInt()}°',
                                  style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  '${weatherData!['current']['condition']['text']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                            Image.network(
                              'https:${weatherData!['current']['condition']['icon']}', // URL do ícone
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Cor de fundo
                          borderRadius: BorderRadius.circular(
                              16), // Define o raio da borda
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              const Icon(
                                Icons.air,
                                size: 32,
                                color: Colors.black45,
                              ),
                              Text(
                                '${weatherData!['current']['wind_kph'].toInt()}km/h',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                              Text(
                                'Vento',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              )
                            ]),
                            Column(children: [
                              const Icon(
                                Icons.water_drop_outlined,
                                size: 32,
                                color: Colors.black45,
                              ),
                              Text(
                                '${weatherData!['current']['humidity'].toInt()}%',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                              Text(
                                'Umidade',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              )
                            ]),
                            Column(children: [
                              const Icon(
                                Icons.cloudy_snowing,
                                size: 32,
                                color: Colors.black45,
                              ),
                              Text(
                                '${weatherData!['current']['cloud'].toInt()}%',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                              Text(
                                'Precipitação',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              )
                            ])
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16)),
                                width:
                                    (MediaQuery.of(context).size.width - 64) *
                                        0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Índice UV',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '${weatherData!['current']['uv'].toInt()}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey[800]),
                                    ),
                                    Text(
                                      weatherData!['current']['uv'].toInt() > 10
                                          ? 'Extremo'
                                          : weatherData!['current']['uv']
                                                      .toInt() >
                                                  8
                                              ? 'Muito alto'
                                              : weatherData!['current']['uv']
                                                          .toInt() >
                                                      6
                                                  ? 'Alto'
                                                  : weatherData!['current']
                                                                  ['uv']
                                                              .toInt() >
                                                          3
                                                      ? 'Moderado'
                                                      : 'Baixo',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[800]),
                                    ),
                                  ],
                                )),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16)),
                                width:
                                    (MediaQuery.of(context).size.width - 64) *
                                        0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Visibilidade',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '${weatherData!['current']['vis_km'].toInt()}km',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey[800]),
                                    ),
                                    Text(
                                      weatherData!['current']['vis_km']
                                                  .toInt() >
                                              12
                                          ? 'Excelente'
                                          : weatherData!['current']['vis_km']
                                                      .toInt() >
                                                  9
                                              ? 'Boa'
                                              : 'Mediana',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[800]),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
