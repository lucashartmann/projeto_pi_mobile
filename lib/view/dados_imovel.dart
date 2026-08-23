import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class DadosImovel extends StatefulWidget {
  const DadosImovel({super.key});

  @override
  State<DadosImovel> createState() => _DadosImovelState();
}

class _DadosImovelState extends State<DadosImovel> {
  int imagemAtual = 0;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> imovel =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final anuncio = imovel['anuncio'] ?? {};
    final endereco = imovel['endereco'] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Imóvel'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel de imagens
            if (anuncio['imagens'] != null &&
                (anuncio['imagens'] as List).isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    child: Image.network(
                      anuncio['imagens'][imagemAtual],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  // Pontos de navegação
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          (anuncio['imagens'] as List).length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => imagemAtual = index);
                              },
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: imagemAtual == index
                                      ? AppColors.hoverColor
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Botões de navegação
                  if (imagemAtual > 0)
                    Positioned(
                      left: 8,
                      top: 130,
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
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  if (imagemAtual < (anuncio['imagens'] as List).length - 1)
                    Positioned(
                      right: 8,
                      top: 130,
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
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e categoria
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anuncio['titulo'] ?? 'Sem título',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.hoverColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                imovel['categoria'] ?? 'N/A',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.hoverColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Endereço
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${endereco['rua'] ?? ''}, ${endereco['numero'] ?? ''}, ${endereco['bairro'] ?? ''}, ${endereco['cidade'] ?? ''} - ${endereco['uf'] ?? ''}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Preços
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (imovel['valor_aluguel'] != null)
                            Column(
                              children: [
                                Text(
                                  'Aluguel',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R\$ ${imovel['valor_aluguel']}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.precoColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          if (imovel['valor_venda'] != null)
                            Column(
                              children: [
                                Text(
                                  'Venda',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R\$ ${imovel['valor_venda']}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.precoColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Características
                  if (imovel['quantidade_quartos'] != null ||
                      imovel['quantidade_banheiros'] != null ||
                      imovel['quantidade_vagas'] != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                          children: [
                            if (imovel['quantidade_quartos'] != null &&
                                imovel['quantidade_quartos'] > 0)
                              _buildCaracteristica(
                                context,
                                Icons.bed,
                                '${imovel['quantidade_quartos']}',
                                'Quartos',
                              ),
                            if (imovel['quantidade_salas'] != null &&
                                imovel['quantidade_salas'] > 0)
                              _buildCaracteristica(
                                context,
                                Icons.living,
                                '${imovel['quantidade_salas']}',
                                'Salas',
                              ),
                            if (imovel['quantidade_banheiros'] != null &&
                                imovel['quantidade_banheiros'] > 0)
                              _buildCaracteristica(
                                context,
                                Icons.bathtub,
                                '${imovel['quantidade_banheiros']}',
                                'Banheiros',
                              ),
                            if (imovel['quantidade_vagas'] != null &&
                                imovel['quantidade_vagas'] > 0)
                              _buildCaracteristica(
                                context,
                                Icons.directions_car,
                                '${imovel['quantidade_vagas']}',
                                'Vagas',
                              ),
                            if (imovel['quantidade_suites'] != null &&
                                imovel['quantidade_suites'] > 0)
                              _buildCaracteristica(
                                context,
                                Icons.bed,
                                '${imovel['quantidade_suites']}',
                                'Suítes',
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Descrição
                  if (anuncio['descricao'] != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descrição',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              anuncio['descricao'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Características do imóvel
                  if (imovel['filtros'] != null && imovel['filtros'].isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Características',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final filtro in imovel['filtros'])
                                  Chip(
                                    label: Text(filtro),
                                    backgroundColor: AppColors.hoverColor
                                        .withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: AppColors.hoverColor,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Características do condomínio
                  if (imovel['condominio'] != null &&
                      imovel['condominio']['filtros'] != null &&
                      imovel['condominio']['filtros'].isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Características do Condomínio',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final filtro
                                    in imovel['condominio']['filtros'])
                                  Chip(
                                    label: Text(filtro),
                                    backgroundColor: AppColors.precoColor
                                        .withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: AppColors.precoColor,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  // Botão de ação
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Agendar Visita'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildCaracteristica(
    BuildContext context,
    IconData icon,
    String valor,
    String label,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.hoverColor, size: 24),
        const SizedBox(height: 4),
        Text(
          valor,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
