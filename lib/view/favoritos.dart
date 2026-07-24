import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widgets/bottom-nav.dart';
import 'dart:async';
import 'dados_imovel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

void abrirTelaImovel(BuildContext context, Map<String, dynamic> imovel) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DadosImovel(imovel: imovel)),
  );
}

class ContainerAnuncio extends StatefulWidget {
  final Map<String, dynamic> imovel;

  const ContainerAnuncio({super.key, required this.imovel});

  @override
  State<ContainerAnuncio> createState() => _ContainerAnuncioState();
}

class _ContainerAnuncioState extends State<ContainerAnuncio> {
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

    // @Preview(

    // )

    return GestureDetector(
      onTap: () {
        abrirTelaImovel(context, widget.imovel);
      },

      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(203, 199, 199, 0.6),
        child: Column(
          children: [
            // Icon(icons.heart,)
            if (imagens.isNotEmpty)
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Image.network(
                      imagens[imagemAtual],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),

                    const Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.favorite),
                        color: Colors.white,
                      ),
                    ),

                    if (imagemAtual > 0)
                      Positioned(
                        left: 8,
                        top: 75,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              imagemAtual--;
                            });
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                    if (imagemAtual < imagens.length - 1)
                      Positioned(
                        right: 8,
                        top: 75,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              imagemAtual++;
                            });
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            Text("${widget.imovel["anuncio"]["titulo"]}"),

            Text(
              "${widget.imovel["endereco"]["rua"]}, ${widget.imovel["endereco"]["numero"]}, ${widget.imovel['endereco']['cep']}, ${widget.imovel["endereco"]["bairro"]}, ${widget.imovel["endereco"]["cidade"]} - ${widget.imovel["endereco"]["uf"]}",
            ),

            Text("Categoria: ${widget.imovel["categoria"]}"),

            if (widget.imovel["valor_aluguel"] != null)
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    const TextSpan(text: "Aluguel: "),
                    TextSpan(
                      text: "R\$ ${widget.imovel["valor_aluguel"]}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (widget.imovel["valor_venda"] != null)
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    const TextSpan(text: "Venda: "),
                    TextSpan(
                      text: "R\$ ${widget.imovel["valor_venda"]}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoritosState extends State<Favoritos> {
  List<dynamic> imoveis = [];

  Future<void> carregar() async {
    final dados = await listarImoveisFavoritados();

    setState(() {
      imoveis = dados ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Center(
        child: imoveis.isNotEmpty
            ? MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                itemCount: imoveis.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (context, index) {
                  return ContainerAnuncio(imovel: imoveis[index]);
                },
              )
            : CircularProgressIndicator(),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
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
    debugPrint("Erro: $e");
    return null;
  }
}
