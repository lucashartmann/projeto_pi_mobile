import 'package:flutter/material.dart';

class DadosImovel extends StatelessWidget {
  final Map<String, dynamic> imovel;

  const DadosImovel({super.key, required this.imovel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imovel['anuncio']['imagens'] != null &&
                imovel['anuncio']['imagens'].isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imovel['anuncio']['imagens'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        imovel['anuncio']['imagens'][index],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Descrição: ${imovel['anuncio']['descricao']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Preço: R\$ ${imovel['valor_aluguel'] ?? imovel['valor_venda']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Localização: ${imovel['endereco']['rua']}, ${imovel['endereco']['numero']}, ${imovel['endereco']['bairro']}, ${imovel['endereco']['cidade']} - ${imovel['endereco']['uf']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Descrição: ${imovel['anuncio']['descricao']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Preço: R\$ ${imovel['valor_aluguel'] ?? imovel['valor_venda']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Localização: ${imovel['endereco']['rua']}, ${imovel['endereco']['numero']}, ${imovel['endereco']['bairro']}, ${imovel['endereco']['cidade']} - ${imovel['endereco']['uf']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
