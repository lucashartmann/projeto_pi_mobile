import 'package:flutter/material.dart';
import '../apis/imoveis.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dados_imovel.dart';
import 'dart:async';
import 'widgets/bottom-nav.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
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

class _TelaInicialState extends State<TelaInicial> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int imagemAtual = 0;
  List<dynamic> imoveis = [];
  List<dynamic> imoveisFiltrados = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (imoveisFiltrados.isEmpty) return;

      imagemAtual++;

      if (imagemAtual >= imoveisFiltrados.length) {
        imagemAtual = 0;
      }

      _pageController.animateToPage(
        imagemAtual,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    carregar();
  }

  Future<void> carregar() async {
    final dados = await listarImoveisDisponiveis();

    setState(() {
      imoveis = dados ?? [];
      imoveisFiltrados = List<dynamic>.from(imoveis);
      carregando = false;
    });
  }

  void filtrar(String valor) {
    final termo = valor.trim().toLowerCase();

    setState(() {
      if (termo.isEmpty) {
        imoveisFiltrados = List<dynamic>.from(imoveis);
        imagemAtual = 0;
        return;
      }

      imoveisFiltrados = imoveis.where((imovel) {
        if (imovel is! Map<String, dynamic>) {
          return false;
        }

        final anuncio = imovel['anuncio'];
        final endereco = imovel['endereco'];

        final titulo = anuncio is Map<String, dynamic>
            ? (anuncio['titulo'] ?? '').toString().toLowerCase()
            : '';
        final descricao = anuncio is Map<String, dynamic>
            ? (anuncio['descricao'] ?? '').toString().toLowerCase()
            : '';
        final bairro = endereco is Map<String, dynamic>
            ? (endereco['bairro'] ?? '').toString().toLowerCase()
            : '';
        final cep = endereco is Map<String, dynamic>
            ? (endereco['cep'] ?? '').toString().toLowerCase()
            : '';
        final categoria = (imovel['categoria'] ?? '').toString().toLowerCase();
        final status = (imovel['status'] ?? '').toString().toLowerCase();

        return titulo.contains(termo) ||
            descricao.contains(termo) ||
            bairro.contains(termo) ||
            cep.contains(termo) ||
            categoria.contains(termo) ||
            status.contains(termo);
      }).toList();

      imagemAtual = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantidadeEmDestaque = imoveis.length < 5 ? imoveis.length : 5;
    final quantidadeFiltradaEmDestaque = imoveisFiltrados.length < 5
        ? imoveisFiltrados.length
        : 5;

    return Scaffold(
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        onChanged: (value) {
                          filtrar(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Pesquisar imóveis...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (quantidadeFiltradaEmDestaque > 0)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: imoveisFiltrados.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    imagemAtual = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    imoveisFiltrados[index]["anuncio"]["imagens"][0],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              Positioned(
                                left: 10,
                                top: 75,
                                child: IconButton(
                                  onPressed: () {
                                    if (imagemAtual > 0) {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      _pageController.animateToPage(
                                        imoveisFiltrados.length - 1,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 75,
                                child: IconButton(
                                  onPressed: () {
                                    if (imagemAtual <
                                        imoveisFiltrados.length - 1) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      _pageController.animateToPage(
                                        0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (quantidadeFiltradaEmDestaque > 0)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 450,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: quantidadeFiltradaEmDestaque,
                            itemBuilder: (context, index) {
                              final imovel = imoveisFiltrados[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 8,
                                ),
                                child: SizedBox(
                                  width: 260,
                                  child: ContainerAnuncio(imovel: imovel),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemCount: imoveisFiltrados.length,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      itemBuilder: (context, index) {
                        return ContainerAnuncio(
                          imovel: imoveisFiltrados[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
