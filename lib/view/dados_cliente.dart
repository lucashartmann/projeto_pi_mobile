import 'package:flutter/material.dart';
import '../apis/usuario.dart';
import 'package:projeto_pi_mobile/view/login.dart';
import 'package:projeto_pi_mobile/view/widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class DadosCliente extends StatefulWidget {
  const DadosCliente({super.key});

  @override
  State<DadosCliente> createState() => _DadosClienteState();
}

class _DadosClienteState extends State<DadosCliente> {
  late Future<Map<String, dynamic>?> _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = carregarUser();
    _usuario.then((dados) {
      if (!mounted) return;
      if (dados == null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const TelaLogin()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _usuario,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
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
                        Text('Erro: ${snapshot.error}'),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Nenhum dado encontrado.'));
                } else {
                  final usuario = snapshot.data!;
                  final user = usuario['usuario'] ?? {};
                  final endereco = user['endereco'] ?? {};

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header com avatar
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.hoverColor.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.hoverColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user['nome'] ?? 'Usuário',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(usuario['tipo'] ?? 'Cliente'),
                              backgroundColor: AppColors.hoverColor.withValues(
                                alpha: 0.2,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.hoverColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Dados Básicos
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dados Pessoais',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              _buildDataRow(
                                context,
                                Icons.email_outlined,
                                'Email',
                                user['email'] ?? 'N/A',
                              ),
                              // const Divider(),
                              // _buildDataRow(
                              //   context,
                              //   Icons.phone_outlined,
                              //   'Telefone',
                              //   user['telefones']?[0] ?? 'N/A',
                              // ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.badge_outlined,
                                'CPF/CNPJ',
                                user['cpf_cnpj'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.card_membership_outlined,
                                'RG',
                                user['rg'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.cake_outlined,
                                'Data de Nascimento',
                                user['data_nascimento'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.date_range_outlined,
                                'Cadastrado em',
                                user['data_cadastro']?['date'] ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Endereço
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Endereço',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'Rua',
                                endereco['rua'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'Número',
                                endereco['numero'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'Complemento',
                                endereco['complemento'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'Bairro',
                                endereco['bairro'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'Cidade',
                                endereco['cidade'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'UF',
                                endereco['uf'] ?? 'N/A',
                              ),
                              const Divider(),
                              _buildDataRow(
                                context,
                                Icons.location_on_outlined,
                                'CEP',
                                endereco['cep'] ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                }
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 5),
    );
  }

  Widget _buildDataRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.hoverColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
