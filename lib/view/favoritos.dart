import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widgets/bottom-nav.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../apis/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_theme.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

void abrirTelaImovel(BuildContext context, Map<String, dynamic> imovel) {
  Navigator.pushReplacementNamed(context, '/dados_imovel', arguments: imovel);
}

class CardAnuncio extends StatefulWidget {
  final Map<String, dynamic> imovel;

  const CardAnuncio({super.key, required this.imovel});

  @override
  State<CardAnuncio> createState() => _CardAnuncioState();
}

class _CardAnuncioState extends State<CardAnuncio> {
  int imagemAtual = 0;

  List<String> _imagensDoAnuncio() {
    final anuncio = widget.imovel['anuncio'];
    if (anuncio is! Map<String, dynamic>) {
      return const [];
    }

    final imagens = anuncio['imagens'];
    if (imagens is List) {
      return imagens.whereType<String>().toList();
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final imagens = _imagensDoAnuncio();
    final anuncio = widget.imovel['anuncio'] ?? {};
    final endereco = widget.imovel['endereco'] ?? {};

    return GestureDetector(
      onTap: () {
        abrirTelaImovel(context, widget.imovel);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagens.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        imagens[imagemAtual],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    if (imagemAtual > 0)
                      Positioned(
                        left: 8,
                        top: 75,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => imagemAtual--);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    if (imagemAtual < imagens.length - 1)
                      Positioned(
                        right: 8,
                        top: 75,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => imagemAtual++);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio['titulo'] ?? 'Sem título',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.hoverColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              anuncio['categoria'] ?? 'N/A',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.hoverColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${endereco['rua'] ?? ''}, ${endereco['bairro'] ?? ''} - ${endereco['cidade'] ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (anuncio['aluguel'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aluguel',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                Text(
                                  'R\$ ${anuncio['aluguel']}',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppColors.precoColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          if (anuncio['venda'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Venda',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                Text(
                                  'R\$ ${anuncio['venda']}',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppColors.precoColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritosState extends State<Favoritos> {
  late Future<List<dynamic>?> _imoveis;

  @override
  void initState() {
    super.initState();
    _imoveis = listarImoveisFavoritados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos'), elevation: 0),
      body: FutureBuilder(
        future: _imoveis,
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
                    Icons.favorite_border_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nenhum favorito no momento",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final imoveis = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: imoveis.length,
              itemBuilder: (context, index) {
                return CardAnuncio(imovel: imoveis[index]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

Future<List<dynamic>?> listarImoveisFavoritados() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}login.php?acao=get_favoritos",
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
    debugPrint("ERRO: favoritos.dart - listarImoveisFavoritados: $e");
    return null;
  }
}
