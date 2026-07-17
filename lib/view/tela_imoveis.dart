import 'package:flutter/material.dart';
import '../apis/imoveis.dart';

class TelaImoveis extends StatefulWidget {
  const TelaImoveis({super.key});

  @override
  State<TelaImoveis> createState() => _TelaImoveisState();
}

class ContainerImovel extends StatelessWidget {
  final Map<String, dynamic> imovel;

  const ContainerImovel({super.key, required this.imovel});

  @override
  Widget build(BuildContext context) {
    final endereco = imovel["endereco"] ?? {};
    final anuncio = imovel["anuncio"] ?? {};
    final imagens = anuncio["imagens"] ?? [];

    String? imagem;

    if (imagens.isNotEmpty) {
      imagem = imagens.first;
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: false, onChanged: (_) {}),

            if (imagem != null)
              Image.network(imagem, width: 120, height: 90, fit: BoxFit.cover)
            else
              Container(
                width: 120,
                height: 90,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image),
              ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ref: ${imovel["id"]}"),

                  Text("Rua: ${endereco["rua"]}, ${endereco["numero"]}"),

                  Text("Bairro: ${endereco["bairro"]}"),

                  Text("CEP: ${endereco["cep"]}"),

                  Text("Categoria: ${imovel["categoria"]}"),

                  Text("Status: ${imovel["status"]}"),

                  Text("Aluguel: R\$ ${imovel["valor_aluguel"]}"),

                  Text("Venda: R\$ ${imovel["valor_venda"]}"),
                ],
              ),
            ),

            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
      ),
    );
  }
}

class _TelaImoveisState extends State<TelaImoveis> {
  List<dynamic> imoveis = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await listarImoveis();

    setState(() {
      imoveis = dados ?? [];
      carregando = false;
    });
  }

  String dinheiro(dynamic valor) {
    if (valor == null) return "-";
    return "R\$ $valor";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Imóveis")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: imoveis.length,
              itemBuilder: (context, index) {
                final imovel = imoveis[index];
                return ContainerImovel(imovel: imovel);
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        // fazer a barra ficar sempre na tela sobre o conteúdo
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 251, 39, 39),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
