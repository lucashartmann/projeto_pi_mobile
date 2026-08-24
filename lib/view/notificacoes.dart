import 'package:flutter/material.dart';
import '../apis/notificacoes.dart';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  List<dynamic> _notificacoes = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      setState(() {
        _carregando = true;
        _erro = null;
      });

      final dados = await carregarNotificacoes();

      setState(() {
        // Garante que seja uma lista
        if (dados is Map) {
          // Se for um mapa, tenta extrair uma lista dele
          _notificacoes = dados != null && dados.isNotEmpty ? [dados] : [];
        } else if (dados is List) {
          _notificacoes = dados;
        } else {
          _notificacoes = [];
        }
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar notificações: $e';
        _carregando = false;
      });
      debugPrint(_erro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações'), elevation: 0),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _erro!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: carregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            )
          : _notificacoes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: carregar,
              child: ListView.builder(
                itemCount: _notificacoes.length,
                itemBuilder: (context, index) {
                  final notificacao = _notificacoes[index];

                  // Extrai os dados com segurança
                  final titulo = notificacao is Map
                      ? notificacao['titulo'] ?? 'Sem título'
                      : 'Notificação $index';
                  final mensagem = notificacao is Map
                      ? notificacao['mensagem'] ?? 'Sem mensagem'
                      : notificacao.toString();
                  final data = notificacao is Map
                      ? notificacao['data_criacao'] ?? ''
                      : '';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.hoverColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: AppColors.hoverColor,
                        ),
                      ),
                      title: Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            mensagem,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (data.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              data,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }
}
