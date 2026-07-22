import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';

class DadosImovel extends StatefulWidget {
  final Map<String, dynamic> imovel;

  const DadosImovel({super.key, required this.imovel});

  @override
  State<DadosImovel> createState() => _DadosImovelState();
}

class _DadosImovelState extends State<DadosImovel> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              if (widget.imovel['anuncio']['imagens'] != null &&
                  widget.imovel['anuncio']['imagens'].isNotEmpty)
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

                      Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 0.0,
                          children: List.generate(imagens.length, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  imagemAtual = index;
                                });
                              },
                              icon: Icon(
                                Icons.circle,
                                size: 7,
                                color: imagemAtual == index
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            );
                          }),
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
              const SizedBox(height: 50),
              Text(
                '${widget.imovel['anuncio']['titulo']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Text(
                '${widget.imovel['endereco']['rua']}, ${widget.imovel['endereco']['numero']}, ${widget.imovel['endereco']['bairro']}, ${widget.imovel['endereco']['cidade']} - ${widget.imovel['endereco']['uf']}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if (widget.imovel['quantidade_quartos'] != null &&
                          widget.imovel['quantidade_quartos'] > 0)
                        Row(
                          children: [
                            Text("Quartos: ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.bed, size: 30),
                            Text(
                              '${widget.imovel['quantidade_quartos']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      if (widget.imovel['quantidade_salas'] != null &&
                          widget.imovel['quantidade_salas'] > 0)
                        Row(
                          children: [
                            Text("Salas: ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.living, size: 30),
                            Text(
                              '${widget.imovel['quantidade_salas']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      if (widget.imovel['quantidade_suites'] != null &&
                          widget.imovel['quantidade_suites'] > 0)
                        Row(
                          children: [
                            Text("Suítes: ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.bed, size: 30),
                            Text(
                              '${widget.imovel['quantidade_suites']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      if (widget.imovel['quantidade_banheiros'] != null &&
                          widget.imovel['quantidade_banheiros'] > 0)
                        Row(
                          children: [
                            Text("Banheiros: ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.bathtub, size: 30),
                            Text(
                              '${widget.imovel['quantidade_banheiros']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      if (widget.imovel['quantidade_vagas'] != null &&
                          widget.imovel['quantidade_vagas'] > 0)
                        Row(
                          children: [
                            Text("Vagas: ", style: TextStyle(fontSize: 20)),
                            Icon(Icons.directions_car, size: 30),
                            Text(
                              '${widget.imovel['quantidade_vagas']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attach_money),
                          Column(
                            children: [
                              if (widget.imovel["valor_venda"] != null)
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                    children: [
                                      TextSpan(text: "Venda: "),
                                      TextSpan(
                                        text:
                                            "R\$ ${widget.imovel["valor_venda"]}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.imovel["valor_aluguel"] != null)
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                    children: [
                                      TextSpan(text: "Aluguel: "),
                                      TextSpan(
                                        text:
                                            "R\$ ${widget.imovel["valor_aluguel"]}",
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
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 50),
              Text(
                '${widget.imovel['anuncio']['descricao']}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              if (widget.imovel['filtros'] != null &&
                  widget.imovel['filtros'].isNotEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(widget.imovel['filtros'][index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              if (widget.imovel['condominio'] != null &&
                  widget.imovel['condominio']['filtros'] != null &&
                  widget.imovel['condominio']['filtros'].isNotEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              widget.imovel['condominio']['filtros'][index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
