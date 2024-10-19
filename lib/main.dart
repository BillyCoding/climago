import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(const MyApp());

  await initializeDateFormatting('pt_BR', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(
          // Definindo Inter como a fonte padrão
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
