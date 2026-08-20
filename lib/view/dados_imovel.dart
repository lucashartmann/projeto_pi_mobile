import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';

class DadosImovel extends StatefulWidget {
  
  const DadosImovel({super.key});

  @override
  State<DadosImovel> createState() => _DadosImovelState();
}

class _DadosImovelState extends State<DadosImovel> {
  int imagemAtual = 0;
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> imovel = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            if (imovel['anuncio']?['imagens'] != null &&
                imovel['anuncio']['imagens'].isNotEmpty)
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Image.network(
                      imovel['anuncio']['imagens'][imagemAtual],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),

                    Positioned(
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 0.0,
                        children: List.generate(
                          imovel['anuncio']['imagens'].length,
                          (index) {
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
                          },
                        ),
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
                        imovel['anuncio']['imagens'].length - 1)
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
              '${imovel['anuncio']?['titulo']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Text(
              '${imovel['endereco']?['rua']}, ${imovel['endereco']?['numero']}, ${imovel['endereco']?['bairro']}, ${imovel['endereco']?['cidade']} - ${imovel['endereco']?['uf']}',
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
                    if (imovel['quantidade_quartos'] != null &&
                        imovel['quantidade_quartos'] > 0)
                      Row(
                        children: [
                          Text("Quartos: ", style: TextStyle(fontSize: 20)),
                          Icon(Icons.bed, size: 30),
                          Text(
                            '${imovel['quantidade_quartos']}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (imovel['quantidade_salas'] != null &&
                        imovel['quantidade_salas'] > 0)
                      Row(
                        children: [
                          Text("Salas: ", style: TextStyle(fontSize: 20)),
                          Icon(Icons.living, size: 30),
                          Text(
                            '${imovel['quantidade_salas']}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (imovel['quantidade_suites'] != null &&
                        imovel['quantidade_suites'] > 0)
                      Row(
                        children: [
                          Text("Suítes: ", style: TextStyle(fontSize: 20)),
                          Icon(Icons.bed, size: 30),
                          Text(
                            '${imovel['quantidade_suites']}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (imovel['quantidade_banheiros'] != null &&
                        imovel['quantidade_banheiros'] > 0)
                      Row(
                        children: [
                          Text("Banheiros: ", style: TextStyle(fontSize: 20)),
                          Icon(Icons.bathtub, size: 30),
                          Text(
                            '${imovel['quantidade_banheiros']}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (imovel['quantidade_vagas'] != null &&
                        imovel['quantidade_vagas'] > 0)
                      Row(
                        children: [
                          Text("Vagas: ", style: TextStyle(fontSize: 20)),
                          Icon(Icons.directions_car, size: 30),
                          Text(
                            '${imovel['quantidade_vagas']}',
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
                            if (imovel["valor_venda"] != null)
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
                                          "R\$ ${imovel["valor_venda"]}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (imovel["valor_aluguel"] != null)
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
                                          "R\$ ${imovel["valor_aluguel"]}",
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
              '${imovel['anuncio']?['descricao']}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (imovel['filtros'] != null &&
                imovel['filtros'].isNotEmpty)
              const SizedBox(height: 50),
            if (imovel['filtros'] != null &&
                imovel['filtros'].isNotEmpty)
              Text(
                "Características do imóvel:",
                style: TextStyle(fontSize: 20),
              ),
            if (imovel['filtros'] != null &&
                imovel['filtros'].isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: imovel['filtros'].length,
                itemBuilder: (context, index) {
                  return Text(imovel['filtros'][index]);
                },
              ),

            if (imovel['condominio'] != null &&
                imovel['condominio']['filtros'] != null &&
                imovel['condominio']['filtros'].isNotEmpty)
              const SizedBox(height: 50),

            if (imovel['condominio'] != null &&
                imovel['condominio']['filtros'] != null &&
                imovel['condominio']['filtros'].isNotEmpty)
              Text(
                "Características do condomínio:",
                style: TextStyle(fontSize: 20),
              ),

            if (imovel['condominio'] != null &&
                imovel['condominio']['filtros'] != null &&
                imovel['condominio']['filtros'].isNotEmpty)
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

                    itemCount: imovel['condominio']['filtros'].length,
                    itemBuilder: (context, index) {
                      return Text(
                        imovel['condominio']['filtros'][index],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
