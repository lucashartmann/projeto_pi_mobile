import 'package:flutter/material.dart';
import '../apis/notificacoes.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  List<dynamic> _notificacoes = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await carregarNotificacoes();

    setState(() {
      _notificacoes = dados ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: Center(
        child: _notificacoes.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _notificacoes.length,
                itemBuilder: (context, index) {
                  final notificacao = _notificacoes[index] ?? {};
                  return ListTile(
                    title: Text(notificacao['titulo'] ?? ''),
                    subtitle: Text(notificacao['mensagem'] ?? ''),
                  );
                },
              ),
      ),
    );
  }
}
