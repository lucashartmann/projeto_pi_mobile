import 'package:flutter/material.dart';

class CadastroImovel extends StatefulWidget {
  const CadastroImovel({super.key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Imóvel'),
      ),
      body: const Center(
        child: Text('Tela de cadastro de imóvel'),
      ),
    );
  }
}