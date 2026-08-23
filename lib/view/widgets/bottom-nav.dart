import 'package:flutter/material.dart';
import '../../../apis/notificacoes.dart';
import '../../utils/app_theme.dart';

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
    try {
      final dados = await carregarNotificacoes();

      setState(() {
        if (dados is Map) {
          notificacoes = dados != null && dados.isNotEmpty ? [dados] : [];
        } else if (dados is List) {
          notificacoes = dados;
        } else {
          notificacoes = [];
        }
        temNaoLidas = notificacoes.any((n) => n is Map && n["lida"] == false);
      });
    } catch (e) {
      debugPrint("Erro ao carregar notificações: $e");
    }
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == widget.currentIndex) {
      return;
    }

    String rota = '';

    switch (index) {
      case 0:
        rota = '/tela_inicial';
        break;
      case 1:
        rota = '/favoritos';
        break;
      case 2:
        rota = '/opcoes';
        break;
      case 3:
        rota = '/atendimentos_cliente';
        break;
      case 4:
        rota = '/notificacoes';
        break;
      case 5:
        rota = '/dados_cliente';
        break;
    }

    Navigator.pushNamed(context, rota);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundNav,
      selectedItemColor: AppColors.hoverColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: widget.currentIndex,
      onTap: (index) => _navigateTo(context, index),
      elevation: 8,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.menu_outlined),
          activeIcon: Icon(Icons.menu),
          label: 'Opções',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Atendimentos',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (temNaoLidas)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          activeIcon: Stack(
            children: [
              const Icon(Icons.notifications),
              if (temNaoLidas)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Notificações',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
