import 'package:flutter/material.dart';
import '../apis/usuario.dart';
import 'package:projeto_pi_mobile/view/login.dart';

class DadosCliente extends StatefulWidget {
  const DadosCliente({super.key});

  @override
  State<DadosCliente> createState() => _DadosClienteState();
}

class _DadosClienteState extends State<DadosCliente> {
  late Future<Map<String, dynamic>?> _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = carregarUser();
    if (_usuario == null) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const TelaLogin()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _usuario,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Nenhum dado encontrado.'));
                } else {
                  final usuario = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: ${usuario['nome']}'),
                      Text('Email: ${usuario['email']}'),
                      Text('Telefone: ${usuario['telefone']}'),
                    ],
                  );
                }
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
