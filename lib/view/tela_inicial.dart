import 'package:flutter/material.dart';
import '../apis/imoveis.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'widgets/bottom-nav.dart';

class ContainerAnuncio extends StatefulWidget {
  final Map<String, dynamic> imovel;

  const ContainerAnuncio({super.key, required this.imovel});

  @override
  State<ContainerAnuncio> createState() => _ContainerAnuncioState();
}

class _ContainerAnuncioState extends State<ContainerAnuncio> {
  int imagemAtual = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/dados_imovel',
          arguments: widget.imovel,
        );
      },

      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(203, 199, 199, 0.6),
        child: Column(
          children: [
            // Icon(icons.heart,)
            if (widget.imovel['anuncio']?['imagens'] != null &&
                (widget.imovel['anuncio']?['imagens'] as List).isNotEmpty)
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Image.network(
                      widget.imovel['anuncio']?['imagens'][imagemAtual],
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

                    if (imagemAtual <
                        (widget.imovel['anuncio']?['imagens'] as List).length -
                            1)
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

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late Future<List<dynamic>?> imoveis;
  late Future<List<dynamic>?> imoveisFiltrados;

  @override
  void initState() {
    super.initState();
    imoveis = listarImoveisDisponiveis();
    imoveisFiltrados = imoveis;
  }

  void filtrar(String valor) {
    final termo = valor.trim().toLowerCase();

    setState(() {
      imoveisFiltrados = imoveis.then((lista) {
        if (lista == null || termo.isEmpty) {
          return lista ?? [];
        }

        return lista.where((imovel) {
          final anuncio = imovel["anuncio"] ?? {};
          final endereco = imovel["endereco"] ?? {};

          final titulo = anuncio["titulo"]?.toString().toLowerCase() ?? "";

          final rua = endereco["rua"]?.toString().toLowerCase() ?? "";

          final bairro = endereco["bairro"]?.toString().toLowerCase() ?? "";

          final cidade = endereco["cidade"]?.toString().toLowerCase() ?? "";

          return titulo.contains(termo) ||
              rua.contains(termo) ||
              bairro.contains(termo) ||
              cidade.contains(termo);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) {
                filtrar(valor);
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: FutureBuilder(
                future: imoveis,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar dados: ${snapshot.error}',
                          ),
                        );
                      }
                      final imoveis = snapshot.data ?? [];
                      if (imoveis.isEmpty) {
                        return const Center(
                          child: Text('Nenhum imóvel encontrado.'),
                        );
                      }
                      return SizedBox(
                        height: 60,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: imoveis
                                .take(5)
                                .map(
                                  (imovel) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SizedBox(
                                      width: 180,
                                      child: ContainerAnuncio(imovel: imovel),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    default:
                      return const Center(
                        child: Text('Erro ao carregar dados'),
                      );
                  }
                },
              ),
            ),

            SizedBox(height: 15),
            FutureBuilder(
              future: imoveisFiltrados,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                        ),
                      );
                    }
                    final imoveis = snapshot.data ?? [];
                    if (imoveis.isEmpty) {
                      return const Center(
                        child: Text('Nenhum imóvel encontrado.'),
                      );
                    }
                    return MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: imoveis.length,
                      itemBuilder: (context, index) {
                        return ContainerAnuncio(imovel: imoveis[index]);
                      },
                    );
                  default:
                    return const Center(child: Text('Erro ao carregar dados'));
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
