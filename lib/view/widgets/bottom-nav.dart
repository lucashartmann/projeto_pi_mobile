import 'package:flutter/material.dart';

import '../tela_inicial.dart';
import '../favoritos.dart';
import '../dados_cliente.dart';
import '../../../apis/notificacoes.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  const BottomNav({super.key, this.currentIndex = 0});

  @override
  State<BottomNav> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  List<dynamic> notificacoes = [];
  bool temNaoLidas = false;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await carregarNotificacoes();

    setState(() {
      notificacoes = dados ?? [];
      temNaoLidas = notificacoes.any((n) => n["lida"] == false);
    });
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == widget.currentIndex) {
      return;
    }

    Widget? destination;

    switch (index) {
      case 0:
        destination = const TelaInicial();
        break;
      case 1:
        destination = const Favoritos();
        break;
      case 5:
        destination = const DadosCliente();
        break;
    }

    if (destination == null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromRGBO(36, 30, 30, 0.92),
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white,
      currentIndex: widget.currentIndex,
      onTap: (index) => _navigateTo(context, index),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Opções'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.insert_comment),
          label: 'Atendimentos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            temNaoLidas ? Icons.notifications : Icons.notifications_none,
          ),
          label: 'Mensagens',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
