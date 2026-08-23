import 'package:flutter/material.dart';
import 'package:projeto_pi_mobile/view/dados_cliente.dart';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';
import 'package:projeto_pi_mobile/view/widgets/teste.dart';

class Opcoes extends StatefulWidget {
  const Opcoes({super.key});

  @override
  State<Opcoes> createState() => _OpcoesState();
}

class _OpcoesState extends State<Opcoes> {
  void abrirOpcoesCadastro(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: AppColors.hoverColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.home_work_outlined,
                    color: AppColors.hoverColor,
                  ),
                ),
                title: const Text('Cadastrar Imóvel'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/cadastro_imovel');
                },
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: AppColors.precoColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    color: AppColors.precoColor,
                  ),
                ),
                title: const Text('Cadastrar Pessoa'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/cadastro_cliente');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opções'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu Principal',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Opção de Cadastro
            _buildMenuCard(
              context,
              Icons.add_circle_outline,
              'Cadastro',
              'Cadastrar imóvel ou pessoa',
              AppColors.hoverColor,
              () => abrirOpcoesCadastro(context),
            ),
            const SizedBox(height: 12),
            BotaoCadastroExpandido(

            ),
            // Estoque
            _buildMenuCard(
              context,
              Icons.inventory_2_outlined,
              'Estoque',
              'Gerenciar imóveis',
              AppColors.precoColor,
              () {
                Navigator.pushReplacementNamed(context, '/estoque');
              },
            ),
            const SizedBox(height: 12),
            // Atendimentos
            _buildMenuCard(
              context,
              Icons.support_agent_outlined,
              'Atendimentos',
              'Ver atendimentos',
              Colors.blue,
              () {
                Navigator.pushReplacementNamed(
                  context,
                  '/atendimentos_cliente',
                );
              },
            ),
            const SizedBox(height: 12),
            // Meus Dados
            _buildMenuCard(
              context,
              Icons.person_outline,
              'Meu Perfil',
              'Ver e editar meus dados',
              Colors.purple,
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DadosCliente()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
