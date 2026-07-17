import 'package:flutter/material.dart';
import '../apis/imoveis.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dados_imovel.dart';

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

class ContainerAnuncio extends StatelessWidget {
  final Map<String, dynamic> imovel;

  const ContainerAnuncio({super.key, required this.imovel});

  @override
  Widget build(BuildContext context) {
    final imagens = imovel["anuncio"]["imagens"] ?? [];

    String? imagem;

    if (imagens.isNotEmpty) {
      imagem = imagens.first;
    }

    return GestureDetector(
      onTap: () {
        abrirTelaImovel(context, imovel);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(203, 199, 199, 0.6),
        child: Column(
          children: [
            if (imagem != null)
              Image.network(
                imagem,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),

            Text("${imovel["anuncio"]["titulo"]}"),

            Text(
              "${imovel["endereco"]["rua"]}, ${imovel["endereco"]["numero"]}, ${imovel['endereco']['cep']}, ${imovel["endereco"]["bairro"]}, ${imovel["endereco"]["cidade"]} - ${imovel["endereco"]["uf"]}",
            ),

            Text("Categoria: ${imovel["categoria"]}"),

            if (imovel["valor_aluguel"] != null)
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    const TextSpan(text: "Aluguel: "),
                    TextSpan(
                      text: "R\$ ${imovel["valor_aluguel"]}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (imovel["valor_venda"] != null)
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    const TextSpan(text: "Venda: "),
                    TextSpan(
                      text: "R\$ ${imovel["valor_venda"]}",
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
  List<dynamic> imoveis = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await listarImoveisDisponiveis();

    setState(() {
      imoveis = dados ?? [];
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : MasonryGridView.builder(
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
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(36, 30, 30, 0.92),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
