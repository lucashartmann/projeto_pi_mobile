import 'dart:convert';
import 'package:http/http.dart' as http;
import '.././apis/api.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_theme.dart';

class AtendimentosCliente extends StatefulWidget {
  const AtendimentosCliente({super.key});

  @override
  State<AtendimentosCliente> createState() => _AtendimentosClienteState();
}

class _AtendimentosClienteState extends State<AtendimentosCliente> {
  late Future<List<dynamic>?> _atendimentos;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() {
      _atendimentos = listarAtendimentos();
    });
  }

  Future<List<dynamic>?> listarAtendimentos() async {
    try {
      final uri = Uri.parse(
        "${dotenv.get('ADDRESS')}login.php?acao=get_atendimentos",
      );

      final resposta = await http.get(
        uri,
        headers: {"Cookie": sessionCookie ?? ""},
      );

      if (resposta.statusCode != 200) {
        debugPrint("Erro HTTP: ${resposta.statusCode}");
        return null;
      }

      final contentType = resposta.headers["content-type"];

      if (contentType == null || !contentType.contains("application/json")) {
        debugPrint("Resposta não é JSON");
        debugPrint(resposta.body);
        return null;
      }

      final data = jsonDecode(resposta.body);

      for (final imovel in data) {
        final anuncio = imovel["anuncio"];

        if (anuncio != null && anuncio["imagens"] != null) {
          final imagens = anuncio["imagens"] as List<dynamic>;

          for (int i = 0; i < imagens.length; i++) {
            imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
          }
        }
      }

      return data as List<dynamic>;
    } catch (e) {
      debugPrint("ERRO: atendimentos_cliente.dart - listarAtendimentos: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Atendimentos'), elevation: 0),
      body: FutureBuilder(
        future: _atendimentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Erro: ${snapshot.error}"),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nenhum atendimento no momento",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final atendimentos = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: carregar,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: atendimentos.length,
              itemBuilder: (context, index) {
                final atendimento = atendimentos[index];

                if (atendimento is! Map<String, dynamic>) {
                  return const SizedBox.shrink();
                }

                final imovel = atendimento['imovel'] ?? {};
                final anuncio = imovel['anuncio'] ?? {};
                final imagens = anuncio['imagens'] ?? [];
                final imagem = imagens.isNotEmpty ? imagens[0] : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imagem != null
                          ? Image.network(
                              imagem,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                    title: Text(
                      anuncio['titulo'] ?? 'Sem título',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${anuncio['status'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              anuncio['status'],
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            anuncio['status'] ?? 'Pendente',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getStatusColor(anuncio['status']),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/dados_imovel',
                        arguments: imovel,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'ativo':
      case 'aprovado':
        return AppColors.precoColor;
      case 'pendente':
        return Colors.orange;
      case 'inativo':
      case 'rejeitado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
