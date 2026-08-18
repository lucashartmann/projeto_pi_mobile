import 'package:flutter/material.dart';
import 'package:projeto_pi_mobile/view/tela_inicial.dart';
import 'package:projeto_pi_mobile/view/cadastro_imovel.dart';
import 'package:projeto_pi_mobile/view/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
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
