import 'package:flutter/material.dart';
import '../apis/imoveis.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
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

    return SizedBox(
      width: 120,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagem != null)
              Image.network(
                imagem,
                width: 220,
                height: 190,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            Text("${imovel["anuncio"]["titulo"]}"),
            Text(
              "${imovel["endereco"]["rua"]}, ${imovel["endereco"]["numero"]}, ${imovel['endereco']['cep']}, ${imovel["endereco"]["bairro"]}, ${imovel["endereco"]["cidade"]} - ${imovel["endereco"]["uf"]}",
            ),
            Text("Categoria: ${imovel["categoria"]}"),
            if (imovel["valor_aluguel"] != null)
              Text("Aluguel: R\$ ${imovel["valor_aluguel"]}"),
            if (imovel["valor_venda"] != null)
              Text("Venda: R\$ ${imovel["valor_venda"]}"),
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
      appBar: AppBar(title: const Text("Lista de Imóveis")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: imoveis.length,
              itemBuilder: (context, index) {
                final imovel = imoveis[index];
                return ContainerAnuncio(imovel: imovel);
              },
            ),
    );
  }
}
