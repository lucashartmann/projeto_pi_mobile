import 'package:flutter/material.dart';
import '../apis/usuario.dart';
import 'login.dart';

class DadosCliente extends StatefulWidget {
  const DadosCliente({super.key});

  @override
  State<DadosCliente> createState() => _DadosClienteState();
}

class _DadosClienteState extends State<DadosCliente> {
  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _verificarUsuario() async {
    final usuario = usuarioLogado ?? await carregarUser();
    // debugPrint(JsonDecode(usuario));
    if (usuario == null) {
      if (!context.mounted) {
        debugPrint("Context não montado");
        return;
      }
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const TelaLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do Cliente')),
      body: const Center(child: Text('Tela de dados do cliente')),
    );
  }
}
