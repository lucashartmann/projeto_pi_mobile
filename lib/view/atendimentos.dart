import 'package:flutter/material.dart';

class Atendimento extends StatefulWidget {
  const Atendimento({super.key});

  @override
  State<Atendimento> createState() => _AtendimentoState();
}

class _AtendimentoState extends State<Atendimento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atendimentos')),
      body: Center(
        child: Text('Tela de Atendimentos'),
      ),
    );
  }
} 