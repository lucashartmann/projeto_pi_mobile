import 'package:flutter/material.dart';
import 'package:projeto_pi_mobile/view/tela_inicial.dart';
import 'package:projeto_pi_mobile/view/cadastro_imovel.dart';
import 'package:projeto_pi_mobile/view/cadastro_cliente.dart';
import 'package:projeto_pi_mobile/view/login.dart';
import 'package:projeto_pi_mobile/view/opcoes.dart';
import 'package:projeto_pi_mobile/view/atendimentos.dart';
import 'package:projeto_pi_mobile/view/atendimentos_cliente.dart';
import 'package:projeto_pi_mobile/view/favoritos.dart';
import 'package:projeto_pi_mobile/view/dados_cliente.dart';
import 'package:projeto_pi_mobile/view/dados_imovel.dart';
import 'package:projeto_pi_mobile/view/notificacoes.dart';
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
      debugShowCheckedModeBanner: false,
      routes: {
        '/tela_inicial': (context) => const CadastroCliente(),
        '/login': (context) => const TelaLogin(),
        '/cadastro_imovel': (context) => const CadastroImovel(),
        '/opcoes': (context) => const Opcoes(),
        '/atendimentos': (context) => const Atendimento(),
        '/atendimentos_cliente': (context) => const AtendimentosCliente(),
        '/favoritos': (context) => const Favoritos(),
        '/dados_cliente': (context) => const DadosCliente(),
        '/cadastro_cliente': (context) => const CadastroCliente(),
        '/dados_imovel': (context) => const DadosImovel(),
        '/notificacoes': (context) => const Notificacoes(),
      },
      initialRoute: '/tela_inicial',
    );
  }
}
