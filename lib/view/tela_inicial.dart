import 'package:flutter/material.dart';
import '../apis/imoveis.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class CardAnuncio extends StatefulWidget {
  final Map<String, dynamic> imovel;
  final bool isHorizontal;

  const CardAnuncio({
    super.key,
    required this.imovel,
    this.isHorizontal = false,
  });

  @override
  State<CardAnuncio> createState() => _CardAnuncioState();
}

class _CardAnuncioState extends State<CardAnuncio> {
  int imagemAtual = 0;
  late List<dynamic> imagens;

  @override
  void initState() {
    super.initState();
    imagens = (widget.imovel['anuncio']?['imagens'] ?? []) as List;
  }

  @override
  Widget build(BuildContext context) {
    final anuncio = widget.imovel['anuncio'] ?? {};
    final endereco = widget.imovel['endereco'] ?? {};
    debugPrint("Imagens do anúncio: $imagens");

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/dados_imovel',
          arguments: widget.imovel,
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagens.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        imagens[imagemAtual],
                        width: double.infinity,
                        height: widget.isHorizontal ? 150 : 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: widget.isHorizontal ? 150 : 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    if (imagens.length > 1) ...[
                      if (imagemAtual > 0)
                        Positioned(
                          left: 8,
                          top: 50 + (widget.isHorizontal ? 75 : 100),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => imagemAtual--);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      if (imagemAtual < imagens.length - 1)
                        Positioned(
                          right: 8,
                          top: 50 + (widget.isHorizontal ? 75 : 100),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => imagemAtual++);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      anuncio['titulo'] ?? 'Sem título',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.hoverColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.imovel['categoria'] ?? 'N/A',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.hoverColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${endereco['rua'] ?? ''}, ${endereco['bairro'] ?? ''} - ${endereco['cidade'] ?? ''}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.imovel['valor_aluguel'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aluguel',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              Text(
                                'R\$ ${widget.imovel['valor_aluguel']}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.precoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        if (widget.imovel['valor_venda'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Venda',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              Text(
                                'R\$ ${widget.imovel['valor_venda']}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.precoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  late Future<List<dynamic>?> imoveisMaisClicados;
  late Future<List<dynamic>?> imoveisFiltrados;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imoveis = listarImoveisDisponiveis();
    // imoveisMaisClicados = listarImoveisMaisClicados();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imóveis'), elevation: 0),
      body: CustomScrollView(
        slivers: [
          // Barra de pesquisa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: filtrar,
                decoration: InputDecoration(
                  hintText: 'Pesquise por título, rua, bairro ou cidade',
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
          ),
          // Destaques
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Destaques',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: FutureBuilder(
                future: imoveis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum imóvel em destaque',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final imoveisDestaque = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: imoveisDestaque.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 250,
                          child: CardAnuncio(
                            imovel: imoveisDestaque[index],
                            isHorizontal: true,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Espaçamento
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          // Título "Todos os imóveis"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Todos os imóveis',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          // Grade de imóveis filtrados
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: imoveisFiltrados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Nenhum imóvel encontrado',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final imoveis = snapshot.data!;
                debugPrint("Imóveis filtrados: ${imoveis.length}");
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: imoveis.length,
                    itemBuilder: (context, index) {
                      return CardAnuncio(
                        imovel: imoveis[index],
                        isHorizontal: false,
                      );
                    },
                  ),
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
