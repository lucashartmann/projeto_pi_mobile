import 'package:flutter/material.dart';
import '../apis/imoveis.dart';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class Estoque extends StatefulWidget {
  const Estoque({super.key});

  @override
  State<Estoque> createState() => _EstoqueState();
}

class _EstoqueState extends State<Estoque> {
  late Future<List<dynamic>?> _imoveis;
  late Future<List<dynamic>?> _imoveisFiltrados;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imoveis = listarImoveis();
    _imoveisFiltrados = _imoveis;
  }

  void filtrar(String valor) {
    final termo = valor.trim().toLowerCase();

    setState(() {
      _imoveisFiltrados = _imoveis.then((lista) {
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estoque de Imóveis'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: filtrar,
              decoration: InputDecoration(
                hintText: 'Pesquisar imóvel...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          filtrar('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.hoverColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _imoveisFiltrados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
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
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Nenhum imóvel encontrado",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final imovel = snapshot.data![index];
                    final endereco = imovel["endereco"] ?? {};
                    final anuncio = imovel["anuncio"] ?? {};
                    final imagens = anuncio["imagens"] ?? [];

                    String? imagem;
                    if (imagens.isNotEmpty) {
                      imagem = imagens.first;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/cadastro_imovel',
                            arguments: imovel,
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imagem != null
                              ? Image.network(
                                  imagem,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ),
                        title: Text(
                          anuncio["titulo"] ?? "Sem título",
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Ref: ${anuncio["referencia"] ?? "N/A"}",
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${endereco["rua"] ?? ""}, ${endereco["bairro"] ?? ""} - ${endereco["cidade"] ?? ""}",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (anuncio["aluguel"] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.precoColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Aluguel: R\$ ${anuncio["aluguel"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.precoColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                if (anuncio["venda"] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.precoColor.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "Venda: R\$ ${anuncio["venda"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.precoColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
