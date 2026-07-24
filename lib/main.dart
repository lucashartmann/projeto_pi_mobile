import 'package:flutter/material.dart';
import 'view/tela_inicial.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  try {
    await dotenv.load(fileName: ".env"); 
  } catch (e) {
    throw Exception('Error loading .env file: $e'); 
  }
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imóveis',
      home: const TelaInicial(),
      debugShowCheckedModeBanner: false,
    );
  }
}
