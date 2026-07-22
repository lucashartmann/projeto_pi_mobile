import 'package:flutter/material.dart';
import '../tela_inicial.dart';
import '../favoritos.dart';
import '../opcoes.dart';
import '../atendimentos_cliente.dart';
import '../notificacaoes.dart';
import '../dados_cliente.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, this.currentIndex = 0});

  void _navigateTo(BuildContext context, int index) {
    if (index == currentIndex) {
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
      currentIndex: currentIndex,
      onTap: (index) => _navigateTo(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Opções'),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_comment),
          label: 'Atendimentos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.markunread_sharp),
          label: 'Mensagens',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
