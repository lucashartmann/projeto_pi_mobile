import 'package:flutter/material.dart';
import 'view/tela_imoveis.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imóveis',
      home: const TelaImoveis(),
      debugShowCheckedModeBanner: false,
    );
  }
}